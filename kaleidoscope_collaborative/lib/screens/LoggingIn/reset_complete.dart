// This screen confirms the successful password reset and redirects to the Onboarding screen after a brief delay.
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:kaleidoscope_collaborative/screens/first_screen.dart';


// StatefulWidget for the Password Confirmed Screen.
class PasswordConfirmedScreen extends StatefulWidget {
  const PasswordConfirmedScreen({super.key});

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
    Timer(const Duration(seconds: 1), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const FirstScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // AppBar with a title indicating the current screen.
        title: const Text('2.9 Forgot Password'),
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
