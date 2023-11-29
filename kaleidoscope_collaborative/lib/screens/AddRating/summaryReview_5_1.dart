import 'package:flutter/material.dart';
import 'package:kaleidoscope_collaborative/screens/constants.dart';

class SummaryReviewPage extends StatelessWidget {
  final int overallRating;
  final Map<String, int> parameterRatings;
  final String? writtenReview;

  const SummaryReviewPage({
    Key? key,
    required this.overallRating,
    required this.parameterRatings,
    this.writtenReview,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Review Summary', style: TextStyle(color: Colors.black)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
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
            SizedBox(height: 20),
            Text('Your review has been submitted successfully!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text('Here\'s a summary of your review:', style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            Text('Overall Rating', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            // Display stars for overall rating
            Row(
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      // Circle icon as the background
                      Icon(

                        index < overallRating ? Icons.circle : Icons.circle,
                        color: index < overallRating ? Color(0xFF6750A4) : Colors.grey,
                        size: 30, 
                      ),
                      // Star icon on top of the circle
                      Align(
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.star,
                          color: Colors.white, // The color for the circle
                          size: 28, // The size of the circle
                        ),
                      ),
                    ],
                  ),
                  onPressed: null,);
              }),
            ),
            SizedBox(height: 20),
            Text('Accommodation Rating', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            // Display parameter ratings
            // ...
            Column(
              children: parameterRatings.entries.map((entry) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(entry.key),
                    Row(
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      // Circle icon as the background
                      Icon(

                        index < overallRating ? Icons.circle : Icons.circle,
                        color: index < overallRating ? Color(0xFF6750A4) : Colors.grey,
                        size: 30, 
                      ),
                      // Star icon on top of the circle
                      Align(
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.star,
                          color: Colors.white, // The color for the circle
                          size: 28, // The size of the circle
                        ),
                      ),
                    ],
                  ),
                  onPressed: null,);
              }),
            ),
                    ],
                );
              }).toList(),
            ),
            if (writtenReview != null) ...[
              SizedBox(height: 20),
              Text('Written Review', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
             TextField(
                controller: TextEditingController(text: writtenReview),
                maxLines: 10,
                enabled: false, // This makes the TextField non-editable
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  ),
                ),
              ),
            ],
            SizedBox(height: 20),


            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                   
                   },
                  child: Text('Back to Business'),
                  style: kSmallButtonStyle,
                ),
                ElevatedButton(
                  onPressed: () {
              },
                  child: Text('Homepage'),
                  style: kSmallButtonStyle,
                ),

              ],

            ),
            SizedBox(height: 16),

          ],
        ),
      ),
    );
  }
}
