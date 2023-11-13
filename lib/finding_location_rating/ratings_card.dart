import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';

class RatingPage extends StatefulWidget
 
{
  @override
  _RatingPageState createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {
  final InAppReview inAppReview = InAppReview.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rating Cards'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset('images/logo.jpg', height: 100, width: 100),
                Column(
                  children: [
                    RatingBar(),
                    SizedBox(height: 10),
                    // Left align the text 
                    Text('John Doe', style: TextStyle(fontSize: 20), textAlign: TextAlign.left),

                  ],
                ),
              ],
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                inAppReview.requestReview();
              },
              child: Text('Rate Now'),
            ),
          ],
      ),
    );
  }
}

class RatingBar extends StatefulWidget
 
{
  @override
  _RatingBarState createState() => _RatingBarState();
}

class _RatingBarState extends State<RatingBar> {
  int rating = 0;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end, 
      children: [
        for (int i = 1; i <= 5; i++)
          IconButton(
            icon: Icon(Icons.star, size: 30, color: rating >= i ? Colors.yellow : Colors.grey),
            onPressed: () {
              setState(() {
                rating = i;
              });
            },
          ),
          // add white space to push the rating bar to the right 
          SizedBox(width: 40), 

      ],
      // Pad the end with spaces to push the rating bar to the right 
    
    );
  }
}