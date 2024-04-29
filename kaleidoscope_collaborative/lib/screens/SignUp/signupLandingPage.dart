import 'package:flutter/material.dart';
import 'package:kaleidoscope_collaborative/screens/LoggingIn/constants.dart';
import 'signup1_1.dart';

// Implementing the 1.0 Sign Up Landing Page

class SignupLandingPage extends StatefulWidget{
  const SignupLandingPage({super.key});
  @override
  _SignupLandingPageState createState() => _SignupLandingPageState();
}


class _SignupLandingPageState extends State<SignupLandingPage> {
    void showLoginFailedDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Login Failed'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign up Landing Page',style: TextStyle(color:Colors.black)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
        elevation: 0, 
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Image.asset(
              'images/logo.jpg',
              width: 117.0, 
              height: 99.0, 
            ),
            const SizedBox(height: 48),

            // Title
            const Text(
              'Sign Up',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 48),

            ElevatedButton(
              onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const SignupScreen()));
              },
              style: kButtonStyle,
              child: const Text('Sign Up in App')
            ),
            const SizedBox(height: 16),

            const Row(
              children: <Widget>[
                Expanded(child: Divider(thickness: 1)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text('or'),
                ),
                Expanded(child: Divider(thickness: 1)),
              ],
            ),
            const SizedBox(height: 16),

            // Sign Up with Facebook Button
            ElevatedButton(
              onPressed: () {
              },
              style: kButtonStyle,
              child: const Text('Log In with Facebook')
            ),
            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: () {
              },
              style: kButtonStyle,
              child: const Text('Log In with Google')
            ),
          ],
        ),
      ),
    );
  }
}