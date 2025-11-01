import 'package:flutter/material.dart';
import 'search_page_1_3.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchPage1_2 extends StatelessWidget {
  final String initialQuery;
  final List<String> selectedFilters;
  final String name;
  final Future<http.Response> queryResponse;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  SearchPage1_2(
      {required this.initialQuery,
      required this.selectedFilters,
      required this.queryResponse,
      required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Results', style: TextStyle(color: Colors.black)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          GestureDetector(
            child: Icon(Icons.history),
            onTap: () {},
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body:
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder<dynamic>(
                  future: _getResults(queryResponse, selectedFilters) ,
                  // Future that returns the name
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text("Loading places...", style: TextStyle(fontSize: 16)),
                        ),
                      );
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.error_outline, size: 48, color: Colors.red),
                              const SizedBox(height: 16),
                              const Text("Error loading places!", style: TextStyle(fontSize: 16)),
                              const SizedBox(height: 8),
                              Text(
                                "Please ensure the backend server is running on localhost:8000",
                                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    
                    var response = snapshot.data;
                    
                    // Check if response indicates an error (list with "Error" string)
                    if (response is List && response.isNotEmpty && response[0] == "Error") {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.error_outline, size: 48, color: Colors.red),
                              const SizedBox(height: 16),
                              const Text("Error loading places!", style: TextStyle(fontSize: 16)),
                              const SizedBox(height: 8),
                              Text(
                                "Unable to connect to backend server. Please ensure it's running on localhost:8000",
                                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    
                    // Ensure response is a list of Maps
                    if (response is! List) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text("Error: Invalid response format", style: TextStyle(fontSize: 16)),
                        ),
                      );
                    }
                    
                    List results = response;
                    
                    if (results.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.search_off, size: 48, color: Colors.grey),
                              const SizedBox(height: 16),
                              const Text("No places found for this query!",
                                  style: TextStyle(fontSize: 16)),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return ListView(
                        children: results
                            .where((item) => item is Map<String, dynamic>)
                            .map<Widget>((result) => _buildResultCard(context, result as Map<String, dynamic>))
                            .toList(),
                      );
                    }
                  })),
    );
  }

// The gray background layered card that displays the search results
  Widget _buildResultCard(BuildContext context, Map<String, dynamic> result) {
    return GestureDetector(
      onTap: () async {
        // Navigate to SearchPage1_3 with the selected result and place details

        Map<String, dynamic> placeDetails = result;
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SearchPage1_3(
                result: result, placeDetails: placeDetails, name: name),
          ),
        );
      },
      child: Card(
        color: Colors.grey[200],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              result['photo'],
              height: 150,
              width: double.infinity,
              fit: BoxFit.fill,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    result['name'] ?? '',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  // Additional details from the new API call
                  Builder(builder: (context) {
                    var date = DateTime.now();
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (result['current_opening_hours'] != null &&
                            result['current_opening_hours']['weekday_text'] !=
                                null) ...[
                          Text(
                              "Business Hours: ${result['current_opening_hours']['weekday_text'][date.weekday].split("day:")[1]}")
                        ],
                        Text(
                            "Address: ${result['formatted_address'] ?? 'N/A'}"),
                        Text(
                            "Phone Number: ${result['formatted_phone_number'] ?? 'N/A'}"),
                        Text(
                            "Wheelchair Access: ${result['wheelchair_accessible_entrance'] ?? 'N/A'}"),
                      ],
                    );
                  })
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<dynamic>> _getResults(Future<http.Response> futureResponse, List<String> filters) async {
    List<dynamic> filteredList = [];

    try {
      http.Response httpResponse = await futureResponse;
      
      print('HTTP Response Status: ${httpResponse.statusCode}');
      print('HTTP Response Body: ${httpResponse.body}');

      if (httpResponse.statusCode == 200) {
        // Parse the response JSON to get nearby places
        var decodedBody = json.decode(httpResponse.body);
        
        // Handle case where API returns error JSON
        if (decodedBody is Map && decodedBody.containsKey('error')) {
          print('API returned error: ${decodedBody['error']}');
          return ["Error"];
        }
        
        // Ensure decoded body is a list
        if (decodedBody is! List) {
          print('Unexpected response format: ${decodedBody.runtimeType}');
          return ["Error"];
        }
        
        List<dynamic> places = decodedBody;
        print('Parsed ${places.length} places from API');

        if (places.isEmpty) {
          print('No places found - this might be due to:');
          print('1. Invalid search query');
          print('2. Google Maps API key issues');
          print('3. Location bias problems');
          return [];
        }

        // Limit to 10 places
        if (places.length > 10) {
          places = places.sublist(0, 10);
        }

        // Filter places based on selected accommodations
        for (var placeResult in places) {
          if (placeResult is! Map<String, dynamic>) {
            print('Warning: Place result is not a Map, skipping');
            continue;
          }
          
          String? placeId = placeResult["place_id"];
          if (placeId == null || placeId.isEmpty) {
            print('Warning: Place result missing place_id, skipping');
            continue;
          }
          
          bool inFilter = await _filterResult(placeId, filters);
          if (inFilter) {
            filteredList.add(placeResult);
          }
        }
        print('After filtering: ${filteredList.length} places remain');
      } else {
        print('API request failed with status: ${httpResponse.statusCode}');
        print('Error body: ${httpResponse.body}');
        return ["Error"];
      }
    } catch (e) {
      print('Error in _getResults: $e');
      if (e is http.ClientException) {
        print('Connection error - make sure backend server is running on localhost:8000');
      }
      return ["Error"];
    }
    return filteredList;
  }

  // Future to check if an org passes filters
  Future<bool> _filterResult(String placeID, List<String> filters) async {
    if (filters.isEmpty) return true;

    var ratings = [1, 2, 3, 4, 5];

    var query = _firestore
        .collection('UserReview')
        .where('placeID', isEqualTo: placeID);

    for (var rawFilter in filters) {
      var filter = rawFilter.replaceAll(' ', '');
      if (filter.contains('Stars')) {
        query = query.where('overallRating',
            whereIn: ratings.getRange(int.parse(filter[0]), 5));
      } else {
        query = query.where('accommodations.$filter', isEqualTo: 5);
      }
    }

    var querySnapshot = await query.limit(1).get();

    // Check if the query returned any documents
    if (querySnapshot.docs.isNotEmpty) {
      return true;
    }
    return false;
  }
}
