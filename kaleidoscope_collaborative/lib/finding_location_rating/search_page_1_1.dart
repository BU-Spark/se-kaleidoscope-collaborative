import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaleidoscope_collaborative/config/app_theme.dart';
import 'search_page_1_2.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import '../config/globals.dart' as globals;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/profile.dart';
import '../models/accommodations_constants.dart';

class SearchPage1_1 extends StatefulWidget {
  final String query;
  final String name;
  final Future<Position> coordinateFuture;

  SearchPage1_1({required this.query, required this.coordinateFuture, required this.name});

  @override
  _SearchPage1_1State createState() => _SearchPage1_1State();
}

class _SearchPage1_1State extends State<SearchPage1_1> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> selectedFilters = [];
  late Future<http.Response> queryResponse;

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.query;
    String initialQuery = widget.query;

    queryResponse = widget.coordinateFuture.then((coordinates) {
      final lat = coordinates.latitude;
      final lng = coordinates.longitude;
      // Use baseUrl from globals.dart configuration
      String baseUrl = globals.apiBaseUrl;
      String nearbyPlacesUrl = '$baseUrl/api/query/$initialQuery/$lat/$lng';
      print('Making API request to: $nearbyPlacesUrl');
      return http.get(Uri.parse(nearbyPlacesUrl));
    }).catchError((error) {
      print('Location error: $error');
      // Use New York City as fallback location instead of null/null
      String baseUrl = globals.apiBaseUrl;
      String nearbyPlacesUrl = '$baseUrl/api/query/$initialQuery/40.7128/-74.0060';
      print('Making fallback API request to: $nearbyPlacesUrl');
      return http.get(Uri.parse(nearbyPlacesUrl));
    }
    );

    // Load profile filters if user is logged in
    _loadProfileFilters();
  }

  /// Loads user's profile accommodations and pre-selects matching filters
  Future<void> _loadProfileFilters() async {
    try {
      // Check if user is logged in
      if (globals.userEmail.isEmpty) {
        return; // Not logged in, skip pre-selection
      }

      // Fetch user's profile data from Firestore
      final doc = await FirebaseFirestore.instance
          .collection('ProfileData')
          .doc(globals.userEmail)
          .get();

      if (!doc.exists) {
        return; // Profile doesn't exist, skip pre-selection
      }

      // Parse profile data
      final profileData = ProfileData.fromFirestore(
        doc.data() as Map<String, dynamic>,
      );

      // Only keep accommodations that are in our canonical list
      // This filters out custom "Others" values that can't be used for search
      final profileFilters = profileData.accommodations
          .where((acc) => kAllAccommodations.contains(acc))
          .toList();

      // Update selected filters if widget is still mounted
      if (!mounted) return;

      setState(() {
        selectedFilters
          ..clear()
          ..addAll(profileFilters);
      });
    } catch (e) {
      print('Error loading profile filters: $e');
      // Silently fail - user can still use filters manually
    }
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
          'Filters',
          style: GoogleFonts.openSans(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
        toolbarHeight: 48,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _searchController,
                readOnly: true,
                onTap: () {
                  Navigator.of(context).pop();
                },
                style: GoogleFonts.openSans(
                  fontSize: 16,
                  color: Colors.black87,
                ),
                decoration: InputDecoration(
                  hintText: 'Search for places...',
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
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Filter Options",
                    style: GoogleFonts.openSans(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Please select the accommodations you need. Pre-selected accommodations are based on your profile.",
                    style: GoogleFonts.openSans(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Render accommodation categories from shared constants
                  ...kAccommodationCategories.entries.map((entry) {
                    return _buildBoldedWordRowWithBoxes(entry.key, entry.value);
                  }).toList(),
                  // Customer Reviews section (separate from accommodations)
                  _buildBoldedWordRowWithBoxes(
                    "Customer Reviews",
                    [
                      "1 Star & Up",
                      "2 Stars & Up",
                      "3 Stars & Up",
                      "4 Stars & Up",
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: ElevatedButton(
            onPressed: () {
              print(selectedFilters);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchPage1_2(
                      initialQuery: widget.query,
                      selectedFilters: selectedFilters,
                      queryResponse: queryResponse,
                      name: widget.name),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColorDark,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Show Results",
                  style: GoogleFonts.openSans(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBoldedWordRowWithBoxes(String word, List<String> boxes) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            word,
            style: GoogleFonts.openSans(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                boxes.map((box) => _buildUniqueGrayBox(word, box)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildUniqueGrayBox(String word, String box) {
    bool isSelected = selectedFilters.contains(box);

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            selectedFilters.remove(box);
          } else {
            selectedFilters.add(box);
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryColor.withValues(alpha: 0.15)
              : Colors.grey.shade200,
          border: Border.all(
            color: isSelected
                ? AppTheme.primaryColor
                : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              box,
              style: GoogleFonts.openSans(
                color: isSelected ? AppTheme.primaryColorDark : Colors.black87,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                fontSize: 14,
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: 6),
              Icon(
                Icons.check_circle,
                color: AppTheme.primaryColorDark,
                size: 18,
              ),
            ],
          ],
        ),
      ),
    );
  }

}
