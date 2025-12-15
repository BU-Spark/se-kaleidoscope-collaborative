import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaleidoscope_collaborative/config/app_theme.dart';
import 'package:kaleidoscope_collaborative/utils/photo_url_helper.dart';
import 'package:kaleidoscope_collaborative/widgets/favorite_button.dart';
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
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        leading: Center(
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            constraints: const BoxConstraints(),
          ),
        ),
        title: Text(
          'Search Results',
          style: GoogleFonts.openSans(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
        toolbarHeight: 48,
      ),
      body:
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder<dynamic>(
                  future: _getResults(queryResponse, selectedFilters) ,
                  // Future that returns the name
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const CircularProgressIndicator(
                                color: AppTheme.primaryColor,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                "Loading places...",
                                style: GoogleFonts.openSans(
                                  fontSize: 16,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error_outline,
                                size: 64,
                                color: Colors.red.shade400,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                "Error loading places!",
                                style: GoogleFonts.openSans(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Please ensure the backend server is running on localhost:8000",
                                style: GoogleFonts.openSans(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                ),
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
                          padding: const EdgeInsets.all(32.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.cloud_off_outlined,
                                size: 64,
                                color: Colors.orange.shade400,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                "Connection Error",
                                style: GoogleFonts.openSans(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Unable to connect to backend server. Please ensure it's running on localhost:8000",
                                style: GoogleFonts.openSans(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    
                    // Ensure response is a list of Maps
                    if (response is! List) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Text(
                            "Error: Invalid response format",
                            style: GoogleFonts.openSans(
                              fontSize: 16,
                              color: Colors.red.shade700,
                            ),
                          ),
                        ),
                      );
                    }
                    
                    List results = response;
                    
                    if (results.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 64,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                "No places found",
                                style: GoogleFonts.openSans(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Try adjusting your filters or search query",
                                style: GoogleFonts.openSans(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                ),
                              ),
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
    // Construct the photo URL using the helper
    final photoUrl = PhotoUrlHelper.getPhotoUrl(result['photo']);
    
    return GestureDetector(
      onTap: () async {
        Map<String, dynamic> placeDetails = result;
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SearchPage1_3(
                result: result, placeDetails: placeDetails, name: name),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  child: PhotoUrlHelper.isValidPhotoReference(result['photo'])
                      ? Image.network(
                      photoUrl,
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 180,
                          color: Colors.grey.shade300,
                          child: Center(
                            child: Icon(
                              Icons.image_not_supported,
                              size: 64,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          height: 180,
                          color: Colors.grey.shade200,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: AppTheme.primaryColor,
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          ),
                        );
                      },
                    )
                  : Container(
                      height: 180,
                      color: Colors.grey.shade300,
                      child: Center(
                        child: Icon(
                          Icons.place,
                          size: 64,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ),
                ),
                // Favorite button
                Positioned(
                  top: 12,
                  right: 12,
                  child: FavoriteButton(
                    placeId: result['place_id'] ?? '',
                    placeName: result['name'] ?? 'Unknown Place',
                    placePhoto: result['photo'] ?? '',
                    placePrimaryType: result['primary_type'] ?? 'place',
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              // padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    result['name'] ?? 'Unknown Place',
                    style: GoogleFonts.openSans(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Builder(builder: (context) {
                    var date = DateTime.now();
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (result['current_opening_hours'] != null &&
                            result['current_opening_hours']['weekday_text'] != null &&
                            result['current_opening_hours']['weekday_text'].length > date.weekday) ...[
                          _buildDetailRow(
                            Icons.access_time,
                            result['current_opening_hours']['weekday_text'][date.weekday]
                                .split("day:")[1].trim(),
                          ),
                          const SizedBox(height: 4),
                        ],
                        if (result['formatted_address'] != null) ...[
                          _buildDetailRow(
                            Icons.location_on_outlined,
                            result['formatted_address'],
                          ),
                          const SizedBox(height: 4),
                        ],
                        if (result['formatted_phone_number'] != null) ...[
                          _buildDetailRow(
                            Icons.phone_outlined,
                            result['formatted_phone_number'],
                          ),
                          const SizedBox(height: 4),
                        ],
                        if (result['wheelchair_accessible_entrance'] != null) ...[
                          _buildDetailRow(
                            Icons.accessible,
                            result['wheelchair_accessible_entrance'] == true
                                ? 'Wheelchair Accessible'
                                : 'No Wheelchair Access Info',
                          ),
                        ],
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

  Widget _buildDetailRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 18,
          color: AppTheme.primaryColor,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.openSans(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
        ),
      ],
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
