// This screen confirms the successful password reset and redirects to the Onboarding screen after a brief delay.
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:kaleidoscope_collaborative/screens/HomeAndLanding/onboarding_page.dart';
import 'package:kaleidoscope_collaborative/screens/first_screen.dart';

import 'login_complete.dart';

// StatefulWidget for the Password Confirmed Screen.
class PasswordConfirmedScreen extends StatefulWidget {
  @override
  _PasswordConfirmedScreenState createState() =>
      _PasswordConfirmedScreenState();
}

// State class for PasswordConfirmedScreen.
class _PasswordConfirmedScreenState extends State<PasswordConfirmedScreen> {
  @override
  void initState() {
    super.initState();
    // Automatically navigate to OnboardingScreen after a 3-second delay.
    Timer(Duration(seconds: 1), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => FirstScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // AppBar with a title indicating the current screen.
        title: Text('2.9 Forgot Password'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: const Center(
        // Displaying a confirmation message.
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'New Password Confirmed!',
            style: TextStyle(
              fontSize: 24.0,
            ),
          ),
        ),
      ),
    );
  }
}
