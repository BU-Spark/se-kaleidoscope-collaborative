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
                      return const Text("Loading places!");
                    }
                    if (snapshot.hasError) {
                      return const Text("Error loading places!");
                    }
                    var response = snapshot.data ?? [];

                    if (response == "Error") {
                      return const Text("Error loading places!");
                    } else if (response.isEmpty) {
                      return Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        child: const Text("No places found for this query!",
                            style: TextStyle(fontSize: 15)),
                      );
                    } else {
                      return ListView(
                        children: response
                            .map<Widget>((result) => _buildResultCard(context, result)).toList(),
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

  Future<List> _getResults(futureResponse, filters) async {
    var filteredList = [];

    http.Response HttpResponse = await futureResponse ?? [];

    if (HttpResponse.statusCode == 200) {
      // Parse the response JSON to get nearby places
      List<dynamic> places = json.decode(HttpResponse.body);

      if (places.length > 10) {
        places = places.sublist(0, 10);
      } else {
        places = places.sublist(0, places.length);
      }

      for (var placeResult in places) {
        var inFilter = await _filterResult(placeResult["place_id"], filters);
        if (inFilter) {
          filteredList.add(placeResult);
        }
      }

    }
    return filteredList;
  }

  // Future to check if an org passes filters
  Future<bool> _filterResult(String placeID, filters) async {
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
