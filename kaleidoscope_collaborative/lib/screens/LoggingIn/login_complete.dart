import 'package:flutter/material.dart';
import 'dart:async';

import 'package:kaleidoscope_collaborative/screens/HomeAndLanding/onboarding_page.dart';

// Replace with the actual import of your new page
// import 'new_page.dart';

class LoginCompletePage extends StatefulWidget {
  final String username;

  LoginCompletePage({Key? key, required this.username}) : super(key: key);

  @override
  _LoginCompletePageState createState() => _LoginCompletePageState();
}

class _LoginCompletePageState extends State<LoginCompletePage> {

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
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'images/logo.jpg',
              width: 117.0,
              height: 99.0,
            ),
            SizedBox(height: 20),
            Text(
              'Welcome ${widget.username}!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


