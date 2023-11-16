import 'package:flutter/material.dart';
import 'constants.dart';
import "login_screen.dart";
import 'signup_screen.dart';
import './finding_location_rating/ratings_card.dart';

class FirstScreen extends StatefulWidget{
  const FirstScreen({super.key});
  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text("Kaleidoscope Collaborative"),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Spacer(),
              Image.asset("images/text_logo.jpg"), // Your logo asset
              SizedBox(height: 30),
              const Text(
                'Discover Disability Inclusive\nServices Around You!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignupScreen()),
                  );
                },
                style: kButtonStyle,
                child: Text(
                  'Sign Up',
                  style: kButtonTextStyle,
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                style: kButtonStyle,
                child: Text(
                  'Log In',
                  style: kButtonTextStyle,
                ),
              ),

              // HERE IS TESTING THE RATING CARD:
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RatingPage()),
                  );
                },
                style: kButtonStyle,
                child: Text(
                  'Rating Card',
                  style: kButtonTextStyle,
                ),
              ),

              TextButton(
                child: Text('Skip for now'),
                onPressed: () {
                  // Handle Skip
                },
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
