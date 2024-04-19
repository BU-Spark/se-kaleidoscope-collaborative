import 'package:flutter/material.dart';
import 'search_page_1_3.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

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

  SearchPage1_2(
      {required this.initialQuery,
      required this.selectedFilters,
      required this.nearbyPlaces});

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
          Padding(
        padding: const EdgeInsets.all(8.0),
        child: Builder(
          builder: (context) => Container(
            child: ListView(
              children: nearbyPlaces
                  .map((result) => _buildResultCard(context, result))
                  .toList(),
            ),
          ),
        ),
      ),
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
              result: result,
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
            FadeInImage.assetNetwork(
              // Pull the image FROM DB here, or BY default, our dummy picture
              placeholder: 'images/dental1.jpg',
              image: result['icon'],
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
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  // Additional details from the new API call

                  Builder(
                    builder: (context) {
                      var date = DateTime.now();
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            if (result['current_opening_hours'] != null && result['current_opening_hours']['weekday_text'] != null) ...[
                              Text("Business Hours: ${result['current_opening_hours']['weekday_text'][date.weekday].split("day:")[1]}")
                            ],
                            Text("Address: ${result['formatted_address'] ?? 'N/A'}"),
                            Text("Phone Number: ${result['formatted_phone_number'] ?? 'N/A'}"),
                            /**
                             * THE CODE BLOCK BELOW CONTAINS THE ADDITIONAL DETAILS THAT CAN BE DISPLAYED depends on the DB and
                             * the type of location
                             */
                            // Text("Reservable: ${placeDetails['reservable'] ?? 'N/A'}"),
                            // Text("Vegetarian Friendly: ${placeDetails['serves_vegetarian_food'] ?? 'N/A'}"),
                            Text("Wheelchair Access: ${result['wheelchair_accessible_entrance'] ?? 'N/A'}"),
                        ],
                      );
                    }
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Map<String, dynamic>> fetchPlaceDetails(String placeId) async {
    final url = Uri.parse('http://10.0.2.2:8000/api/place/$placeId');

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
