import 'package:flutter/material.dart';

class SearchPage1_1 extends StatefulWidget {
  final String query;

  SearchPage1_1({required this.query});

  @override
  _SearchPage1_1State createState() => _SearchPage1_1State();
}

class _SearchPage1_1State extends State<SearchPage1_1> {
  TextEditingController _searchController = TextEditingController();
  List<String> selectedFilters = [];

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.query;
  }

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
      body: SingleChildScrollView(
        child: Column(
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
            // Additional content goes here
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildBoldedWordRowWithBoxes(
                    "Filter",
                    selectedFilters.isEmpty
                        ? []
                        : selectedFilters
                        // Get the entire phrase 
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
        margin: EdgeInsets.only(right: 8, bottom: 8),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.purple : Colors.grey,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              box,
              style: TextStyle(color: isSelected ? Colors.white : Colors.black),
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
                  color: Colors.white,
                  size: 16,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
