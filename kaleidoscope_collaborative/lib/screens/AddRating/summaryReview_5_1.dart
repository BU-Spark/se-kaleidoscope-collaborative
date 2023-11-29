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
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Your review has been submitted successfully!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text('Here\'s a summary of your review:', style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            Text('Overall Rating', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            // Display stars for overall rating
            Row(
              children: List.generate(5, (index) {
                return Icon(
                  index < overallRating ? Icons.star : Icons.star_border,
                  color: index < overallRating ? Colors.amber : Colors.grey,
                );
              }),
            ),
            SizedBox(height: 20),
            Text('Accommodation Rating', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            // Display parameter ratings
            // ...
            if (writtenReview != null) ...[
              SizedBox(height: 20),
              Text('Written Review', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text(writtenReview!, style: TextStyle(fontSize: 16)),
            ],
            SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                // Go back to the business page or home page
              },
              child: Text('Back to Business'),
            ),
            ElevatedButton(
              onPressed: () {
                // Go to the home page
              },
              child: Text('Homepage'),
            ),
          ],
        ),
      ),
    );
  }
}
