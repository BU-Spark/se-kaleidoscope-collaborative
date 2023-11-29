import 'package:flutter/material.dart';
import 'package:kaleidoscope_collaborative/screens/constants.dart';

class TextReviewPage extends StatefulWidget {
  const TextReviewPage({Key? key}) : super(key: key);

  @override
  _TextReviewPageState createState() => _TextReviewPageState();
}

class _TextReviewPageState extends State<TextReviewPage> {
  final TextEditingController _controller = TextEditingController();
  bool _hasWrittenReview = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Write a Review Page', style: TextStyle(color: Colors.black)),
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
            
            Text('Write your review', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            TextField(
              controller: _controller,
              maxLines: 10,
              decoration: InputDecoration(
                hintText: 'What did you like or dislike about your experience at this business?',
              ),
              onChanged: (text) {
                setState(() {
                  _hasWrittenReview = text.isNotEmpty;
                });
              },
            ),
            SizedBox(height: 20),

            ElevatedButton(
              onPressed: _hasWrittenReview ? () {
                // Implement submit logic with _controller.text
              } : null,
              child: Text('Submit'),
            ),
            TextButton(
              onPressed: () {
                // Implement skip and submit logic
              },
              child: Text('Skip and Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
