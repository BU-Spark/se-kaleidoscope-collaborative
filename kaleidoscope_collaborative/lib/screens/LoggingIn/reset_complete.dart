import 'package:flutter/material.dart';
import 'dart:async';
import 'package:kaleidoscope_collaborative/screens/HomeAndLanding/onboarding_page.dart';


class PasswordConfirmedScreen extends StatefulWidget {
  @override
  _PasswordConfirmedScreenState createState() => _PasswordConfirmedScreenState();
}

class _PasswordConfirmedScreenState extends State<PasswordConfirmedScreen> {

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OnboardingScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('2.9 Forgot Password'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: const Center(
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

