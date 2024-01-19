import 'package:flutter/material.dart';
import 'search_page_1_3.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

/**
 * TO DO: 
 * search_page_1_2.dart: 
 * - boilerplate template for the search result item page with the location card implemented.
 * TO BE COMPLETED: 
 * - the location card is not currently being populated with the information from the database. 
 */
class SearchPage1_2 extends StatelessWidget {
  final String initialQuery;
  final List<String> selectedFilters;
  final List<dynamic> nearbyPlaces;

  SearchPage1_2({required this.initialQuery, 
  required this.selectedFilters, 
  required this.nearbyPlaces
  });

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

            /**
             * THE CODE BLOCK BELOW CONTAINS THE INITATIAL QUERY AND THE SELECTED FILTERS 
             * ONCE FINISHED SETTING UP THE DB, YOU CAN USE THESE INPUTS TO QUERY THE DB 
             * AND RETURN THE PROPER RATING OF EACH LOCATIONS 
             * 
             *             
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Text("Initial Query: $initialQuery"),
            // ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Text("Selected Filters:"),
            // ),
            // // Display selected filters
            // ...selectedFilters.map((filter) => Padding(
            //       padding: const EdgeInsets.all(8.0),
            //       child: Text(filter),
            //     )),
            // SizedBox(height: 16),
             */
            _buildDummyGroup(context),
    );  
    
  }

  // Logic for mapping the dummies to the UI, THIS CAN ALSO BE USED FOR THE REAL DATA once we set up the DB 
Widget _buildDummyGroup(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Builder(
      builder: (context) => Container(
        child: ListView(
          children: nearbyPlaces.map((result) => _buildResultCard(context, result)).toList(),
        ),
      ),
    ),
  );
}


// The gray background layered card that displays the search results 
  Widget _buildResultCard(BuildContext context, Map<String, dynamic> result) {
    return GestureDetector(
      onTap: () async  {
        // Navigate to SearchPage1_3 with the selected result and place details
        Map<String, dynamic> placeDetails = await fetchPlaceDetails(result['place_id']);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SearchPage1_3(result: result, 
            placeDetails: placeDetails, 
            ),
          ),
        );
      },
      child: Card(
        color: Colors.grey[200],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              // Pull the image FROM DB here, or BY default, our dummy picture 
              result['image'] ?? 'images/dental1.jpg',
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    result['name'] ?? '',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  // Additional details from the new API call
                  FutureBuilder(
                    future: fetchPlaceDetails(result['place_id']),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text("Loading additional details...");
                      } else if (snapshot.hasError) {
                        return Text("Error loading additional details");
                      } else {
                        // Access additional details from the snapshot.data, check for null values
                        Map<String, dynamic> placeDetails = snapshot.data ?? {};
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (placeDetails['current_opening_hours'] != null && placeDetails['current_opening_hours']['weekday_text'] != null)
                              Text("Business Hours: ${placeDetails['current_opening_hours']['weekday_text'].join(', ').split(',').join('\n')}"),
                            Text("Address: ${placeDetails['formatted_address'] ?? 'N/A'}"),
                            Text("Phone Number: ${placeDetails['formatted_phone_number'] ?? 'N/A'}"),
                            /**
                             * THE CODE BLOCK BELOW CONTAINS THE ADDITIONAL DETAILS THAT CAN BE DISPLAYED depends on the DB and 
                             * the type of location 
                             */
                            // Text("Reservable: ${placeDetails['reservable'] ?? 'N/A'}"),
                            // Text("Vegetarian Friendly: ${placeDetails['serves_vegetarian_food'] ?? 'N/A'}"),
                            Text("Wheelchair Access: ${placeDetails['wheelchair_accessible_entrance'] ?? 'N/A'}"),
                          ],
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  Future<Map<String, dynamic>> fetchPlaceDetails(String placeId) async {
    final url = Uri.parse('http://localhost:3000/api/place/$placeId');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, parse the JSON
        final Map<String, dynamic> placeDetails = json.decode(response.body);
        return placeDetails;
      } else {
        // If the server did not return a 200 OK response,
        // throw an exception.
        throw Exception('Failed to load place details');
      }
    } catch (error) {
      // Handle network errors or other exceptions
      print('Error: $error');
      throw Exception('Failed to load place details');
    }
  }
}

