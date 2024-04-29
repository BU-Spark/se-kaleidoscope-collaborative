import 'package:flutter/material.dart';
import 'search_page_1_2.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

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
      String nearbyPlacesUrl = 'http://10.0.2.2:8000/api/query/$initialQuery/$lat/$lng';
      return http.get(Uri.parse(nearbyPlacesUrl));
    }).catchError((error) {
      print(error);
      String nearbyPlacesUrl = 'http://10.0.2.2:8000/api/query/$initialQuery/null/null';
      return http.get(Uri.parse(nearbyPlacesUrl));
    }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppBar(
          title: Text('Filter Page', style: TextStyle(color: Colors.black)),
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              // padding: EdgeInsets.only(top: kToolbarHeight + 8),
              padding: EdgeInsets.all(8),

              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                ),
                margin: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16),
                        ),
                        readOnly: true,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        // Handle search as needed
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text("Filters", style: TextStyle(fontSize: 18)),
                  SizedBox(height: 8),
                  Text(
                    "Please select the accommodation you need. Pre-selected accommodations are based on your profile.",
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 16),
                  _buildBoldedWordRowWithBoxes(
                    "Accomodation(s) Needed",
                    selectedFilters.isEmpty
                        ? []
                        : selectedFilters.map((filter) => filter).toList(),
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
                      "Sign Language ASL", //removed /because not allowed in DB
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
        color: Color(0xFF6750A4),
        child: TextButton(
          onPressed: () {
            print(selectedFilters);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SearchPage1_2(
                    initialQuery: widget.query,
                    selectedFilters: selectedFilters,
                    queryResponse: queryResponse,
                    name:widget.name
                ),
              ),
            );
          },
          child: Text(
            "Show Results",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildBoldedWordRowWithBoxes(String word, List<String> boxes) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            word,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Wrap(
            spacing: 8,
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
        margin: EdgeInsets.only(right: 8, bottom: 8),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected
              ? Color.fromARGB(255, 222, 202, 251)
              : Colors.grey[300],
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              box,
              style: TextStyle(color: isSelected ? Colors.black : Colors.black),
            ),
            SizedBox(width: 4),
            if (isSelected)
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedFilters.remove(box);
                  });
                },
                child: Icon(
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
