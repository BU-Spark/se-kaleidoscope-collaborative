import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kaleidoscope_collaborative/screens/AddRating/review_page_3_1_paramterRatingPage.dart';
import 'package:kaleidoscope_collaborative/screens/AddRating/text_review_4_1.dart';
import 'package:kaleidoscope_collaborative/screens/constants.dart';

class ChooseRatingParametersPage extends StatefulWidget {
  final int overallRating;
  const ChooseRatingParametersPage({Key? key, required this.overallRating}) : super(key: key);

  @override
  _ChooseRatingParametersPageState createState() => _ChooseRatingParametersPageState();
}

class _ChooseRatingParametersPageState extends State<ChooseRatingParametersPage> {
  final Map<String, int> parameterRatings = {};
  // Map to keep track of each category and its items
  // Map<String, List<String>> categoryItems = {
  //   'Mobility accommodation': ['Accessible Washroom', 'Alternative Entrance', 'Handrails', 'Elevator', 'Lowered Counter', 'Ramp'],
  //   'Stimuli accommodation': ['Outdoor Access Only', 'Reduced Crowd', 'Scent Free', 'Digital Menu'],
  //   'Communication accommodation': ['Braille', 'Customer Service', 'Service Animal Friendly', 'Sign Language'],
  // };

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, List<String>> categoryItems = {};

  @override
  void initState() {
    super.initState();
    fetchAccommodations();
  }
  Future<void> fetchAccommodations() async {
  Map<String, List<String>> accommodationsMap = {};

  // Fetch the collection
  QuerySnapshot querySnapshot = await _firestore.collection('Accommodation').get();

  // Iterate through the documents and group by 'accommodation_category'
  for (var doc in querySnapshot.docs) {
    var data = doc.data() as Map<String, dynamic>;
    String category = data['accommodation_category'];
    String name = data['name'];

    // If the category is already in the map, add the name to the list
    if (accommodationsMap.containsKey(category)) {
      accommodationsMap[category]!.add(name);
    } else {
      // Otherwise, create a new list with the name
      accommodationsMap[category] = [name];
    }
  }

  // return accommodationsMap;
  setState(() {
      categoryItems = accommodationsMap;
    });
}



  // List to keep track of selected items
  List<String> selectedItems = [];

  // Function to handle selection
  void selectItem(String category, String item) {
    setState(() {
      selectedItems.add(item);
      categoryItems[category]?.remove(item);
    });
  }

  // Function to handle deselection
  void deselectItem(String category, String item) {
    setState(() {
      selectedItems.remove(item);
      categoryItems[category]?.add(item);
    });
  }

  // Function to build the list of chips for current selection
  Widget buildCurrentSelection() {
    return Wrap(
      spacing: 8.0,
      children: selectedItems.map((item) {
        return Chip(
          label: Text(item),
          onDeleted: () {
            // Find the category of the item
            String? category = categoryItems.keys.firstWhere(
              (k) => categoryItems[k]?.contains(item) == false,
              orElse: () => '',
            );
            if (category.isNotEmpty) {
              deselectItem(category, item);
            }
          },
          backgroundColor: Color.fromARGB(255, 222, 202, 251), // Light violet purple color
        );
      }).toList(),
    );
  }

  // Function to build the list of chips for category items
  Widget buildCategoryChips(String category) {
    List<String>? items = categoryItems[category];
    if (items == null || items.isEmpty) return SizedBox.shrink();

    return Wrap(
      spacing: 8.0,
      children: items.map((item) {
        return ChoiceChip(
          label: Text(item),
          selected: false,
          onSelected: (_) => selectItem(category, item),
          backgroundColor: Colors.grey.shade200,
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose Rating Parameters Page', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                // Small Image on the top left corner
                Image.asset(
                  'images/dummy.jpg',
                  width: 117.0, // Set the width to match your design
                  height: 99.0, // Set the height to match your design
                ),
                SizedBox(width: 16.0), // Add some spacing between the image and text
                // Organization Title and Type
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Organization Name',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Organization Type',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 48),
                  ],
                ),
              ],
            ),
        
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text(
              'What accommodation(s) have you observed here?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Current selection',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            buildCurrentSelection(),
            for (String category in categoryItems.keys) ...[
              SizedBox(height: 20),
              Text(
                category,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              buildCategoryChips(category),
            ],
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    // Implement skip logic
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TextReviewPage(overallRating: widget.overallRating, parameterRatings: parameterRatings,)), 
                    );
                  },
                  child: Text('Skip'),
                  style: kSmallButtonStyle,
                ),
                ElevatedButton(
                  onPressed: () async {
                    for (String parameter in selectedItems) {
                      // Wait for the ParameterRatingPage to pop before continuing to the next item
                      final int? rating = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ParameterRatingPage(parameterName: parameter),
                        ),
                      );

                      // Handle the result here, e.g., save the rating for each parameter
                      // Store the rating; if the result is null, it indicates that the user skipped this parameter
                      if (rating != null) {
                      parameterRatings[parameter] = rating;}
                      // If result is null, the user may have skipped rating this parameter
                    }
                    // After rating all parameters, navigate to the TextReviewPage
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TextReviewPage(overallRating: widget.overallRating, parameterRatings: parameterRatings,)), 
                    );
                    
                    // After rating all parameters, you might navigate to a summary or review submission page
                  },
                  child: Text('Next'),
                  style: kSmallButtonStyle,
                ),

              ],

            ),
            SizedBox(height: 16),
            Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      'Back to business page',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Color(0xFF6750A4),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
