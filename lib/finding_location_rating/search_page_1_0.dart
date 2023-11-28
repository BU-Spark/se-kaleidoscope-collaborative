import 'package:flutter/material.dart';
// direct to the sample search result, TO BE UPDATED AFTER API IMPLEMENTATION
import 'search_page_1_1.dart';


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
        // Back arrow bug, i just implemented another one to fix it 
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
              child: Row(
                children: [
                  Expanded(
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
                        _performSearch();
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      _performSearch();
                    },
                  ),
                ],
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

void _performSearch() {
  String query = _searchController.text;
  if (query.isNotEmpty) {
    setState(() {
      _searchHistory.add(query);
      _searchController.clear();
    });

    // Navigate to SearchPage1_1 with the query
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchPage1_1(),
      ),
    );
  }
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
                child: Column(
                  children: List.generate(_searchHistory.length, (index) {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
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
                        ),
                        Divider(height: 1, color: Colors.grey),
                      ],
                    );
                  }),
                ),
              ),
            ],
          )
        : Container();
  }
}
