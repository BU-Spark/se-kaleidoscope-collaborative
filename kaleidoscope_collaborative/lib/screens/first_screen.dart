import 'package:flutter/material.dart';
import 'LoggingIn/constants.dart';
import 'LoggingIn/login_screen.dart';
import 'package:kaleidoscope_collaborative/screens/SignUp/signupLandingPage.dart';

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
        title: const Text('Kaleidoscope Collaborative', style: TextStyle(color: Colors.black)),
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
              const SizedBox(height: 30),
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
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const SignupLandingPage()));
                },
                style: kButtonStyle,
                child: const Text(
                  'Sign Up',
                  style: kButtonTextStyle,
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                },
                style: kButtonStyle,
                child: const Text(
                  'Log In',
                  style: kButtonTextStyle,
                ),
              ),
              TextButton(
                child: const Text('Skip for now'),
                onPressed: () {
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => LoginCompletePage()));
                },
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}