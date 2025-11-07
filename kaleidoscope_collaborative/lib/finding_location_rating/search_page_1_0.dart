import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaleidoscope_collaborative/config/app_theme.dart';
import 'search_page_1_1.dart';
import 'search_page_1_2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import '../config/globals.dart' as globals;

class SearchPage extends StatefulWidget {
  final String name;
  final bool skipFilters;

  SearchPage({required this.name, this.skipFilters = false});

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
          'Search',
          style: GoogleFonts.openSans(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: Colors.black87),
            onPressed: () {},
          ),
        ],
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
        toolbarHeight: 48,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    focusNode: _searchFocus,
                    autofocus: true,
                    style: GoogleFonts.openSans(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Type business, address, or name',
                      hintStyle: GoogleFonts.openSans(
                        color: Colors.grey.shade600,
                        fontSize: 16,
                      ),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: AppTheme.primaryColor,
                        size: 24,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(color: AppTheme.primaryColor, width: 2),
                      ),
                      fillColor: Colors.white,
                      filled: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    ),
                    onSubmitted: (query) {
                      _getSearch();
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: const BoxDecoration(
                    color: AppTheme.primaryColorDark,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.search, color: Colors.white),
                    onPressed: () {
                      _getSearch();
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          _buildRecentSearches(),
          Padding(
            padding: const EdgeInsets.only(top: 32),
            child: Center(
              child: Column(
                children: [
                  Icon(
                    Icons.search_outlined,
                    size: 64,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Start typing to search',
                    style: GoogleFonts.openSans(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
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
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  'Recent Searches',
                  style: GoogleFonts.openSans(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Column(
                children: List.generate(_searchHistory.length, (index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SearchPage1_1(
                            query: _searchHistory[index],
                            coordinateFuture: coordinates,
                            name: widget.name,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.history,
                            color: Colors.grey,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _searchHistory[index],
                              style: GoogleFonts.openSans(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, size: 20),
                            color: Colors.grey,
                            onPressed: () {
                              setState(() {
                                _searchHistory.removeAt(index);
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ],
          )
        : Container();
  }

  void _getSearch() async {
    String query = _searchController.text;

    if (query.isNotEmpty) {
      if (widget.skipFilters) {
        // Skip filters and go directly to results
        final queryResponse = coordinates.then((coords) {
          final lat = coords.latitude;
          final lng = coords.longitude;
          String baseUrl = globals.apiBaseUrl;
          String nearbyPlacesUrl = '$baseUrl/api/query/$query/$lat/$lng';
          return http.get(Uri.parse(nearbyPlacesUrl));
        }).catchError((error) {
          String baseUrl = globals.apiBaseUrl;
          String nearbyPlacesUrl = '$baseUrl/api/query/$query/40.7128/-74.0060';
          return http.get(Uri.parse(nearbyPlacesUrl));
        });

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SearchPage1_2(
              initialQuery: query,
              selectedFilters: const [],
              queryResponse: queryResponse,
              name: widget.name,
            ),
          ),
        );
      } else {
        // Normal flow with filters
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                SearchPage1_1(query: query, coordinateFuture: coordinates, name: widget.name),
          ),
        );
      }
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
