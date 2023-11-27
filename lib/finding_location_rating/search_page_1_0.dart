import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();
  List<String> _searchHistory = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            GestureDetector(
              child: Icon(Icons.history),
              onTap: () {},
            ),
          ],
          backgroundColor: Colors.blue,
          elevation: 0,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.only(top: kToolbarHeight + 8),
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(8),
              ),
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _searchController,
                focusNode: _searchFocus,
                decoration: InputDecoration(
                  hintText: 'Search',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                ),
                onTap: () {
                  FocusScope.of(context).requestFocus(_searchFocus);
                },
                onSubmitted: (query) {
                  setState(() {
                    _searchHistory.add(query);
                    _searchController.clear();
                  });
                  // TODO: Perform search and display results
                  // route this to firebase database and display results
                },
              ),
            ),
          ),
          SizedBox(height: 16),
          _buildRecentSearches(),
          Padding(
            padding: EdgeInsets.only(top: 16),
            child: Center(
              child: Text('Search results go here'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentSearches() {
    return _searchHistory.isNotEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Recent Searches',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(height: 8),
              Container(
                height: _searchHistory.length * 50.0, // Adjust the height based on the number of items
                child: ListView.builder(
                  itemCount: _searchHistory.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Chip(
                            label: Text(_searchHistory[index]),
                          ),
                          IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                _searchHistory.removeAt(index);
                              });
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          )
        : Container();
  }
}
