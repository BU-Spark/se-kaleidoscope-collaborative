import 'package:flutter/material.dart';
import 'search_page_1_2.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'no_result_found.dart';

/// TO DO: 
/// 
/// search_page_1_1.dart: 
/// - Accomodations needed and filter page is implemented closely to the figma wireframes. 
/// - the selection of accomodation logic is completed. 
/// - the confirmation of filered accomodations is completed.
/// - the routing to the ratings page is completed. 
/// TO BE COMPLETED: 
/// - directing the filter searches to the database to retrieve the information. 
class SearchPage1_1 extends StatefulWidget {
  final String query;
  final Map<String, dynamic>? coordinates;

  const SearchPage1_1({super.key, required this.query, required this.coordinates});

  @override
  _SearchPage1_1State createState() => _SearchPage1_1State();
}

class _SearchPage1_1State extends State<SearchPage1_1> {
  final TextEditingController _searchController = TextEditingController();
  List<String> selectedFilters = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.query;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBar(
          title: const Text('Filter Page', style: TextStyle(color: Colors.black)),
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              // padding: EdgeInsets.only(top: kToolbarHeight + 8),
            padding: const EdgeInsets.all(8),

              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16),
                        ),
                        readOnly: true,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        // Handle search as needed
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text("Filters", style: TextStyle(fontSize: 18)),
                  const SizedBox(height: 8),
                  const Text(
                    "Please select the accommodation you need. Pre-selected accommodations are based on your profile.",
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 16),
                  _buildBoldedWordRowWithBoxes(
                    "Accomodation(s) Needed",
                    selectedFilters.isEmpty
                        ? []
                        : selectedFilters
                            .map((filter) => filter)
                            .toList(),
                  ),
                  _buildBoldedWordRowWithBoxes(
                    "Mobility",
                    [
                      "Accessible Washroom",
                      "Alternative Entrance",
                      "Handrails",
                      "Elevator",
                      "Lowered Counter",
                    ],
                  ),
                  _buildBoldedWordRowWithBoxes(
                    "Stimuli",
                    [
                      "Outdoor Access Only",
                      "Reduced Crowd",
                      "Scent Free",
                      "Digital Menu",
                    ],
                  ),
                  _buildBoldedWordRowWithBoxes(
                    "Communication",
                    [
                      "Braille",
                      "Customer Service",
                      "Service Animal Friendly",
                      "Sign Language/ASL",
                    ],
                  ),
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
        color: const Color(0xFF6750A4),
        child: TextButton(
          onPressed: () {
            _showResults();
          },
          child: const Text(
            "Show Results",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

void _showResults() async {
  // Get the initial query
  String initialQuery = widget.query;

  // Check if coordinates are available
  if (widget.coordinates != null) {
    // Extract latitude and longitude
    double? latitude = widget.coordinates!['lat'] as double?;
    print("THIS IS THE LATITUDE: ");
    print(latitude);
    double? longitude = widget.coordinates!['lng'] as double?;
    print("THIS IS THE LATITUDE: ");
    print(latitude);
    // Check if latitude and longitude are not null
    if (latitude != null && longitude != null) {
      // Construct the API endpoint for nearby places
      String nearbyPlacesUrl =
          'http://localhost:3000/api/nearby/$latitude,$longitude/500/hospital';

      setState(() {
        isLoading = true;
      });

      try {
        // Send a request to get nearby places
        final nearbyPlacesResponse = await http.get(Uri.parse(nearbyPlacesUrl));

        if (nearbyPlacesResponse.statusCode == 200) {
          // Parse the response JSON to get nearby places
          List<dynamic> nearbyPlaces = json.decode(nearbyPlacesResponse.body);
          // Display the nearby places's count 
          print('Nearby places count: ${nearbyPlaces.length}'); 

          // Now you have the nearby places, you can navigate to the next page
          // with the initial query, selected filters, and nearby places data

          // If the nearby places is empty, navigate to the no result found page 
          if (nearbyPlaces.isEmpty) {
            // Navigate to NoResultFoundPage when no results are found
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NoResultFoundPage(),
              ),
            );
          }

          // Navigate to SearchPage1_2 with the initial query, selected filters, and TOP 5 nearby places 
          if (nearbyPlaces.length > 5) {
            nearbyPlaces = nearbyPlaces.sublist(0, 5); // Get the top 5 nearby places 
          } else {
            nearbyPlaces = nearbyPlaces.sublist(0, nearbyPlaces.length); // Get all nearby places
          }
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SearchPage1_2(
                initialQuery: initialQuery,
                selectedFilters: selectedFilters,
                nearbyPlaces: nearbyPlaces,
              ),
            ),
          );
        } else {
          // Handle the error when getting nearby places
          print('Error getting nearby places: ${nearbyPlacesResponse.statusCode}');
        }
      } catch (e) {
        print('Error: $e');
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      // Handle the case where latitude or longitude is null
      print('Error: Latitude or longitude is null.');
    }
  } else {
    // Handle the case where coordinates are null
    print('Error: Coordinates are null.');
  }
}



  Widget _buildBoldedWordRowWithBoxes(String word, List<String> boxes) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            word,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: boxes.map((box) => _buildUniqueGrayBox(word, box)).toList(),
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
        margin: const EdgeInsets.only(right: 8, bottom: 8),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected ? const Color.fromARGB(255, 222, 202, 251): Colors.grey[300],
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              box,
              style: TextStyle(color: isSelected ? Colors.black : Colors.black),
            ),
            const SizedBox(width: 4),
            if (isSelected)
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedFilters.remove(box);
                  });
                },
                child: const Icon(
                  Icons.clear,
                  color: Colors.black,
                  size: 16,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
