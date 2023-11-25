import 'package:flutter/material.dart';
import 'package:kaleidoscope_collaborative/screens/constants.dart';

// Implementing the 1.0 Sign Up Landing Page

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
              'Sign Up',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 48),

            Text(
              'Sign Up',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 48),

            // ElevatedButton(
            //   onPressed: () {
            //       Navigator.push(context, MaterialPageRoute(builder: (context) => SignupScreen()));
            //   },
            //   child: Text('Sign Up in App'),
            //   style: kButtonStyle
            // ),
            // SizedBox(height: 16),

            Row(
              children: <Widget>[
                Expanded(child: Divider(thickness: 1)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text('or'),
                ),
                Expanded(child: Divider(thickness: 1)),
              ],
            ),
            SizedBox(height: 16),

            // Sign Up with Facebook Button
            ElevatedButton(
              onPressed: () {
              },
              child: Text('Sign Up with Facebook'),
              style: kButtonStyle
            ),
            SizedBox(height: 16),

            ElevatedButton(
              onPressed: () {
              },
              child: Text('Sign Up with Google'),
              style: kButtonStyle
            ),
          ],
        ),
      ),
    );
  }
}