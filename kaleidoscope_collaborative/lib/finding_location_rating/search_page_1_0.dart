import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'search_page_1_1.dart';
import 'no_result_found.dart';

/// TO DO:
/// 
/// search_page_1_0.dart:
/// It is fully functionally. 
/// 
/// Update the UI wherever necessary. 
class SearchPage extends StatefulWidget {
  final String?
      initialSearch; // Optional parameter to take initial search string

  const SearchPage({super.key, this.initialSearch});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();
  final List<String> _searchHistory = [];

  @override
  void initState() {
    super.initState();
    if (widget.initialSearch != null) {
      _searchController.text = widget.initialSearch!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBar(
          title: const Text('Search Page', style: TextStyle(color: Colors.black)),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: [
            GestureDetector(
              child: const Icon(Icons.history),
              onTap: () {},
            ),
          ],
          backgroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            // padding: EdgeInsets.only(top: kToolbarHeight + 8),
            padding: const EdgeInsets.all(16),
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      focusNode: _searchFocus,
                      autofocus:
                          true, // Ensures that the text field is focused when navigated to
                      decoration: InputDecoration(
                        hintText: 'Type business, address, or name',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[200],
                        contentPadding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      onTap: () {
                        FocusScope.of(context).requestFocus(_searchFocus);
                      },
                      onSubmitted: (query) {
                        _dummySearch(); // Adjust this method according to how you handle search submission
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      // _performSearch();
                      _dummySearch();
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildRecentSearches(),
          const Padding(
            padding: EdgeInsets.only(top: 16),
            child: Center(
              child: Text('Search results go here'),
            ),
          ),
        ],
      ),
    );
  }

  //  dummy perform search with set coordinates {lat: 42.3475186, lng: -71.1029006}

  void _dummySearch() async {
    String query = _searchController.text;
    var dummyCoordinates = {
      'lat': 42.34989710000001,
      'lng': -71.10323009999999
    };
    if (query.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          // builder: (context) => SearchPage1_1(query: query, coordinates: coordinates),
          builder: (context) =>
              SearchPage1_1(query: query, coordinates: dummyCoordinates),
        ),
      );
      setState(() {
        _searchHistory.add(query);
        _searchController.clear();
      });
    }
  }

  // Searching for a place
  void _performSearch() async {
    String query = _searchController.text;
    if (query.isNotEmpty) {
      /**
         * FOR THE SAKE OF THE DEMO, SINCE WE HAVE NOT YET ROUTED THE USER INFO WITH THE DB, 
         * LET'S SEE A HARD-CODED STARTER LOCATION, WHICH IS CDS'S LOCATION
         * {lat: 42.34989710000001, lng: -71.10323009999999}  
         * 
         * */
      // Make an HTTP request to get coordinates based on the search query
      var response = await http
          .get(Uri.parse('http://localhost:3000/api/coordinates/$query'));

      if (response.statusCode == 200) {
        // Parse the response to get the coordinates
        var coordinates = json.decode(response.body);
        print(coordinates);

        // Navigate to SearchPage1_1 with the query and coordinates, USING DUMMY COORDINATE FOR THE DEMO

        var dummyCoordinates = {
          'lat': 42.34989710000001,
          'lng': -71.10323009999999
        };
        Navigator.push(
          context,
          MaterialPageRoute(
            // builder: (context) => SearchPage1_1(query: query, coordinates: coordinates),
            builder: (context) =>
                SearchPage1_1(query: query, coordinates: dummyCoordinates),
          ),
        );
      } else {
        // Handle error
        print('Failed to get coordinates. Status code: ${response.statusCode}');
        // Push to the no result found page
        // Navigate to NoResultFoundPage when no results are found
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const NoResultFoundPage(),
          ),
        );
      }

      setState(() {
        _searchHistory.add(query);
        _searchController.clear();
      });
    }
  }

  Widget _buildRecentSearches() {
    return _searchHistory.isNotEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Recent Searches',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                child: Column(
                  children: List.generate(_searchHistory.length, (index) {
                    return Column(
                      children: [
                        InkWell(
                          onTap: () {
                            /**
                             * TO DO: REPLACE THIS WITH THE ACTUAL COORDINATE FROM THE SEARCH 
                             */
                            var dummyCoordinates = {
                              'lat': 42.34989710000001,
                              'lng': -71.10323009999999
                            };
                            _navigateToSearchPage1_1(
                                query: _searchHistory[index],
                                coordinates: dummyCoordinates);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Chip(
                                  label: Text(_searchHistory[index]),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    setState(() {
                                      _searchHistory.removeAt(index);
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Divider(height: 1, color: Colors.grey),
                      ],
                    );
                  }),
                ),
              ),
            ],
          )
        : Container();
  }

  void _navigateToSearchPage1_1(
      {required String query, Map<String, dynamic>? coordinates}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            SearchPage1_1(query: query, coordinates: coordinates),
      ),
    );
  }
}
