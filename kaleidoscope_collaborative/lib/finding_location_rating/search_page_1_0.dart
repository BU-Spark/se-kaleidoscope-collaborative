import 'package:flutter/material.dart';
import 'search_page_1_1.dart';
import 'package:geolocator/geolocator.dart';

class SearchPage extends StatefulWidget {
  final String name;

  SearchPage({required this.name});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();
  final List<String> _searchHistory = [];
  late Future<Position> coordinates;

  @override
  void initState() {
    super.initState();
    coordinates = _determinePosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppBar(
          title: Text('Search Page', style: TextStyle(color: Colors.black)),
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
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            // padding: EdgeInsets.only(top: kToolbarHeight + 8),
            padding: EdgeInsets.all(16),
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      focusNode: _searchFocus,
                      decoration: InputDecoration(
                        hintText: 'Type business, address, or name',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[200],
                        contentPadding: EdgeInsets.symmetric(vertical: 15),
                      ),
                      onTap: () {
                        FocusScope.of(context).requestFocus(_searchFocus);
                      },
                      onSubmitted: (query) {
                        _getSearch();
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      _getSearch();
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
        SizedBox(height: 8),
        Container(
          child: Column(
            children: List.generate(_searchHistory.length, (index) {
              return Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              SearchPage1_1(query: _searchHistory[index],
                                  coordinateFuture: coordinates, name:widget.name)
                        ),
                      );
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

  void _getSearch() async {
    String query = _searchController.text;

    if (query.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              SearchPage1_1(query: query, coordinateFuture: coordinates, name:widget.name),
        ),
      );
      setState(() {
        _searchHistory.add(query);
        _searchController.clear();
      });
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

}