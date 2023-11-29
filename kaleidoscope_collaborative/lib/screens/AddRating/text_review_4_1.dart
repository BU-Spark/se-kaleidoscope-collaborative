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
        title: Text('Life Ki Do Martial Arts'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
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
            Spacer(),
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
