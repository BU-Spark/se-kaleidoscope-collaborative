import 'package:flutter/material.dart';
import 'package:kaleidoscope_collaborative/screens/constants.dart';

// Implementing the 1.1 Review Page

class AddReviewPage extends StatefulWidget{
  const AddReviewPage({super.key});
  @override
  _AddReviewPageState createState() => _AddReviewPageState();
}

class _AddReviewPageState extends State<AddReviewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Review Page',style: TextStyle(color:Colors.black)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
        elevation: 0, // Removes the shadow under the app bar
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Image.asset(
              'images/dummy.jpg',
              width: 117.0, // Set the width to match your design
              height: 99.0, // Set the height to match your design
            ),
            SizedBox(height: 0),

            // Organization Title
            Text(
              'Organization Name',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 10),

            Text(
              'Organization Type',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 48),


            // Move to the next page
            ElevatedButton(
              onPressed: () {
              },
              child: Text('Next'),
              style: kButtonStyle
            ),
            SizedBox(height: 16),

            TextButton(
              onPressed: () {
                // TODO: need to link to the business page - where the add a review button is
              },
              child: Text(
                  'Back to business page',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Color(0xFF6750A4),
                  ),
                ),
            ),
          ],
        ),
      ),
    );
  }
}