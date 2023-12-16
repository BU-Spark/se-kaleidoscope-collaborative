import 'package:flutter/material.dart';
import 'package:kaleidoscope_collaborative/screens/AddRating/temp_rating_card.dart';
import 'package:kaleidoscope_collaborative/screens/HomeAndLanding/onboarding_page.dart';
import 'LoggingIn/constants.dart';
import 'LoggingIn/login_screen.dart';
import 'signupLandingPage.dart';


// import search bar 


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
        automaticallyImplyLeading: false,
        title: Text('Kaleidoscope Collaborative', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
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
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SignupLandingPage()));
                },
                style: kButtonStyle,
                child: const Text(
                  'Sign Up',
                  style: kButtonTextStyle,
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                },
                style: kButtonStyle,
                child: const Text(
                  'Log In',
                  style: kButtonTextStyle,
                ),
              ),
              TextButton(
                child: Text('Skip for now'),
                onPressed: () {
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