import 'package:flutter/material.dart';
import 'ratings_card.dart';

class SearchPage1_3 extends StatelessWidget {
  final Map<String, dynamic> result;
  final Map<String, dynamic> placeDetails;

  SearchPage1_3({required this.result, required this.placeDetails});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(result['name'] ?? ''),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /**
             * TO DO:
             * 
             * Extract the images from dB and turn the images into a carousel if there are multiple images 
             */
            Image.asset(
              result['image'] ?? 'images/dental2.jpg',
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    result['name'] ?? '',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  if (placeDetails.isNotEmpty) ...[
                    if (placeDetails['current_opening_hours'] != null &&
                        placeDetails['current_opening_hours']['weekday_text'] != null)
                      Text(
                          "Business Hours: ${placeDetails['current_opening_hours']['weekday_text'].join(', ').split(',').join('\n')}"),
                    Text("Address: ${placeDetails['formatted_address'] ?? 'N/A'}"),
                    Text("Rating: ${result['rating'] ?? ''}"),
                    Text("Phone Number: ${placeDetails['formatted_phone_number'] ?? 'N/A'}"),
                  ],
                ],
              ),
            ),
            // "Add a Review" button
            ElevatedButton(
              onPressed: () {
                // Implement the action when the button is pressed
              },
              child: Text("Add a Review"),
            ),
            // Display the content of RatingPage directly
            RatingPageContent(),
          ],
        ),
      ),
    );
  }
}

// Extracted widget for RatingPage content
class RatingPageContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        // "Add a Review" button (also above the rating bar)
        // Include the content from RatingPage or customize as needed
        // You can directly use the widgets from RatingPage or modify them accordingly
        // ...
        // For example:
        Text("Community Reviews", style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
        SizedBox(height: 5),
        Text(
          'Joe Smith',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
         RatingBar(),
        const Padding(
          padding: EdgeInsets.only(left: 20, right: 45), // Adjust the horizontal padding as needed
          child: 
          ExpandableText(
            initialText: 'I’ve been going for a few weeks and my son loves it. He gets to try new things in a safe environment.',
            expandedText:
                'I’ve been going for a few weeks and my son loves it. He gets to try new things in a safe environment. It also allows him to spend some time with friends and learn important social skills.',
          ),
        ),   
        FeatureBoxes(),
      ],
    );
  }
}

// Expanding text
class ExpandableText extends StatefulWidget {
  final String initialText;
  final String expandedText;

  const ExpandableText({required this.initialText, required this.expandedText});

  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isExpanded ? widget.expandedText : widget.initialText,
          style: TextStyle(fontSize: 12), // Adjusted font size
        ),
        TextButton(
          onPressed: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          child: Text(isExpanded ? 'Read Less' : 'Read More'),
        ),
      ],
    );
  }
}

// Rating bar
class RatingBar extends StatefulWidget {
  const RatingBar({super.key});
  @override
  _RatingBarState createState() => _RatingBarState();
}

class _RatingBarState extends State<RatingBar> {
  int rating = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (int i = 1; i <= 5; i++)
          Container(
            width: 30, // Adjusted width
            height: 30, // Adjusted height
            margin: const EdgeInsets.symmetric(horizontal: 2), // Adjusted spacing
            decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromRGBO(47, 10, 158, 0.612)),
            child: IconButton(
              icon: Icon(Icons.star,
                  size: 20, color: rating >= i ? Colors.yellow : Colors.white),
              onPressed: () {
                setState(() {
                  rating = i;
                });
              },
            ),
          ),
        const SizedBox(height: 10),
      ],
    );
  }
}

// Feature boxes
class FeatureBoxes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Create the rectangles with a for loop
        // HERE, the logic is to retrieve this info from the database, LOOP through the data and match the following:
        for (int i = 0; i < 2; i++)
          MyRectangle(title: 'Feature $i', imagePath: 'images/logo.jpg'),
        // Add more instances with different titles and image paths as needed
      ],
    );
  }
}

class MyRectangle extends StatelessWidget {
  final String title;
  final String imagePath; // Path to the image asset

  const MyRectangle({required this.title, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min, // Set mainAxisSize to min to stretch based on content
        children: [
          // Image on the left
          Image.asset(
            imagePath,
            height: 80, // Adjust the height of the image
            width: 80, // Adjust the width of the image
          ),
          SizedBox(width: 16), // Add spacing between image and title
          // Title on the right
          Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
