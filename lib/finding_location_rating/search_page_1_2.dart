import 'package:flutter/material.dart';
import 'search_page_1_3.dart';

class SearchPage1_2 extends StatelessWidget {
  final String initialQuery;
  final List<String> selectedFilters;

  SearchPage1_2({required this.initialQuery, required this.selectedFilters});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search Results"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Initial Query: $initialQuery"),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Selected Filters:"),
            ),
            // Display selected filters
            ...selectedFilters.map((filter) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(filter),
                )),
            SizedBox(height: 16),
            Text(
              "Search Results:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            // Display dummy groups (cards with search results)
            _buildDummyGroup(
              "Dentists",
              [
                {
                  'name': 'Dentist 1',
                  'image': 'images/dental1.jpg',
                  'address': '123 Main St',
                  'businessHours': '9 AM - 5 PM',
                  'rating': '4.5',
                },
                // Add more entries as needed
              ],
            ),
            _buildDummyGroup(
              "Hospitals",
              [
                {
                  'name': 'Hospital 1',
                  'image': 'images/dental2.jpg',
                  'address': '456 Oak St',
                  'businessHours': '24/7',
                  'rating': '4.8',
                },
                // Add more entries as needed
              ],
            ),
            _buildDummyGroup(
              "Pharmacies",
              [
                {
                  'name': 'Pharmacy 1',
                  'image': 'images/dental3.jpg',
                  'address': '789 Pine St',
                  'businessHours': '8 AM - 10 PM',
                  'rating': '4.2',
                },
                // Add more entries as needed
              ],
            ),
          ],
        ),
      ),
    );
    
  }

  // Logic for mapping the dummies to the UI, THIS CAN ALSO BE USED FOR THE REAL DATA once we set up the DB 
Widget _buildDummyGroup(String groupName, List<Map<String, String>> searchResults) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Builder(
      builder: (context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            groupName,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          // Display search results for the dummy group
          ...searchResults.map((result) => _buildResultCard(context, result)).toList(),
        ],
      ),
    ),
  );
}



// The gray background layered card that displays the search results 
Widget _buildResultCard(BuildContext context, Map<String, String> result) {
  return GestureDetector(
    onTap: () {
      // Navigate to SearchPage1_3 with the selected result
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => SearchPage1_3(result: result),
        ),
      );
    },
    child: Card(
      color: Colors.grey[200],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            result['image'] ?? 'images/default_image.jpg',
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
                Text("Address: ${result['address'] ?? ''}"),
                Text("Business Hours: ${result['businessHours'] ?? ''}"),
                Text("Rating: ${result['rating'] ?? ''}"),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}


}

