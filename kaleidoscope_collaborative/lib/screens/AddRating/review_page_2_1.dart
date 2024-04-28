import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kaleidoscope_collaborative/screens/AddRating/review_page_3_1_paramterRatingPage.dart';
import 'package:kaleidoscope_collaborative/screens/AddRating/text_review_4_1.dart';
import 'package:kaleidoscope_collaborative/screens/LoggingIn/constants.dart';

// Implementing Add a Review 2.1 : Choosing Accommodations for Rating Page

class ChooseRatingParametersPage extends StatefulWidget {
  final String OrganizationName;
  final String OrganizationType;
  final String UserId;
  final String OrganizationId;
  final String OrgImgLink;
  final int overallRating;
  const ChooseRatingParametersPage({Key? key, required this.overallRating,
  required this.OrganizationName, required this.OrganizationType, 
  required this.UserId, required this.OrganizationId , required this.OrgImgLink}) : super(key: key);

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
          backgroundColor: const Color.fromARGB(255, 222, 202, 251), // Light violet purple color
        );
      }).toList(),
    );
  }

  // Function to build the list of chips for category items
  Widget buildCategoryChips(String category) {
    List<String>? items = categoryItems[category];
    if (items == null || items.isEmpty) return const SizedBox.shrink();

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
        title: const Text('Choose Rating Parameters Page', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Image.asset(
                  widget.OrgImgLink,
                  fit: BoxFit.cover,
                  width: 117.0,
                  height: 99.0,
                ),
                const SizedBox(width: 16.0), 
                // Organization Title and Type
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.OrganizationName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.OrganizationType,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 48),
                    ],
                  ),
                ),
              ],
            ),
        
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              'What accommodation(s) have you observed here?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'Current selection',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            buildCurrentSelection(),
            for (String category in categoryItems.keys) ...[
              const SizedBox(height: 20),
              Text(
                category,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              buildCategoryChips(category),
            ],
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    // Implement skip logic
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TextReviewPage(overallRating: widget.overallRating, parameterRatings: parameterRatings,
                      OrganizationName: widget.OrganizationName, OrganizationType: widget.OrganizationType, UserId: widget.UserId, OrganizationId: widget.OrganizationId, OrgImgLink: widget.OrgImgLink)), 
                    );
                  },
                  style: kSmallButtonStyle,
                  child: const Text('Skip'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    for (String parameter in selectedItems) {
                      // Wait for the ParameterRatingPage to pop before continuing to the next item
                      final int? rating = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ParameterRatingPage(parameterName: parameter, 
                          OrganizationName: widget.OrganizationName, OrganizationType: widget.OrganizationType, UserId: widget.UserId, OrganizationId: widget.OrganizationId, OrgImgLink: widget.OrgImgLink),
                        ),
                      );

                      if (rating != null) {
                      parameterRatings[parameter] = rating;}
                      // If result is null, the user may have skipped rating this parameter
                    }
                    // After rating all parameters, navigate to the TextReviewPage
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TextReviewPage(overallRating: widget.overallRating, parameterRatings: parameterRatings,
                      OrganizationName: widget.OrganizationName, OrganizationType: widget.OrganizationType, UserId: widget.UserId, OrganizationId: widget.OrganizationId, OrgImgLink: widget.OrgImgLink)), 
                    );    
                 },
                  style: kSmallButtonStyle,
                  child: const Text('Next'),
                ),

              ],

            ),
            const SizedBox(height: 16),
            Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text(
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
