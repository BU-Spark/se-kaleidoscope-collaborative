import 'package:flutter/material.dart';
import 'package:kaleidoscope_collaborative/constants.dart';


class SignupScreen extends StatefulWidget{
  const SignupScreen({super.key});
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('1.0 Sign up Landing Page'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Handle back button press
          },
        ),
        elevation: 0, // Removes the shadow under the app bar
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Image.asset(
              'images/logo.jpg',
              width: 117.0, // Set the width to match your design
              height: 99.0, // Set the height to match your design
            ),
            SizedBox(height: 48),

            // Title
            Text(
              'Sign Up',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 48),

            ElevatedButton(
              onPressed: () {
              },
              child: Text('Sign Up in App'),
              style: kButtonStyle
            ),
            SizedBox(height: 16),

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