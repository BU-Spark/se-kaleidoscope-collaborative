import 'package:flutter/material.dart';
import 'package:kaleidoscope_collaborative/screens/constants.dart';

class ChooseRatingParametersPage extends StatefulWidget {
  const ChooseRatingParametersPage({Key? key}) : super(key: key);

  @override
  _ChooseRatingParametersPageState createState() => _ChooseRatingParametersPageState();
}

class _ChooseRatingParametersPageState extends State<ChooseRatingParametersPage> {
  // Define the categories and their accommodations
  final Map<String, List<String>> categories = {
    'Mobility accommodation': ['Accessible Washroom', 'Alternative Entrance', 'Handrails', 'Elevator', 'Lowered Counter', 'Ramp'],
    'Stimuli accommodation': ['Outdoor Access Only', 'Reduced Crowd', 'Scent Free', 'Digital Menu'],
    'Communication accommodation': ['Braille', 'Customer Service', 'Service Animal Friendly', 'Sign Language'],
  };

  // Selected accommodations
  List<String> selectedAccommodations = [];

  // Function to handle selection and deselection of accommodations
  void toggleAccommodation(String accommodation) {
    setState(() {
      if (selectedAccommodations.contains(accommodation)) {
        selectedAccommodations.remove(accommodation);
      } else {
        selectedAccommodations.add(accommodation);
      }
    });
  }

  // Function to build choice chips for a category
  List<Widget> buildChoiceChips(String category) {
    return categories[category]!
        .map((accommodation) => ChoiceChip(
              label: Text(accommodation),
              selected: selectedAccommodations.contains(accommodation),
              onSelected: (_) => toggleAccommodation(accommodation),
            ))
        .toList();
  }

  // Function to build chips for current selection
  Widget buildCurrentSelectionChips() {
    return Wrap(
      spacing: 8.0,
      runSpacing: 4.0,
      children: selectedAccommodations
          .map((accommodation) => Chip(
                label: Text(accommodation),
                onDeleted: () => toggleAccommodation(accommodation),
              ))
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose Rating Parameter Page', style: TextStyle(color: Colors.black)),
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
            const SizedBox(height: 20),

            Text(
              'What accommodation(s) have you observed here?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              'Current selection',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            buildCurrentSelectionChips(),
            ...categories.keys.map((category) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      category,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 4.0,
                      children: buildChoiceChips(category),
                    ),
                  ],
                )),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Implement skip logic
                    },
                    child: const Text('Skip'),
                    style: kSmallButtonStyle,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Implement next logic
                    },
                    child: const Text('Next'),
                    style: kSmallButtonStyle,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

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
