import 'package:flutter/material.dart';

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
      body: Column(
        children: [
          Text("Initial Query: $initialQuery"),
          Text("Selected Filters:"),
          // Display selected filters
          ...selectedFilters.map((filter) => Text(filter)),
          // Additional content goes here
        ],
      ),
    );
  }
}
