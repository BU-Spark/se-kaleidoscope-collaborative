import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode(); // Create a FocusNode
  List<String> _searchHistory = []; // Define _searchHistory here
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          focusNode: _searchFocus, // Assign the FocusNode to the TextField
          decoration: InputDecoration(
            hintText: 'Search',
            border: InputBorder.none,
          ),
          onTap: () {
            FocusScope.of(context).requestFocus(_searchFocus); // Request focus when tapping the TextField
          },
          onSubmitted: (query) {
            setState(() {
              _searchHistory.add(query);
              _searchController.clear();
            });
            // TODO: Perform search and display results
          },
        ),
        actions: [
          GestureDetector(
            child: Icon(Icons.history),
            onTap: () {},
          ),
        ],
      ),
      body: Center(
        child: Text('Search results go here'),
      ),
    );
  }
}
