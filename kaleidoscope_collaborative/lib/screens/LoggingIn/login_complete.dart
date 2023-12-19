// This is the Login Complete Page, confirming user login and redirecting to the Dashboard screen.
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kaleidoscope_collaborative/screens/HomeAndLanding/home_page.dart';

// StatefulWidget for the Login Complete Page.
class LoginCompletePage extends StatefulWidget {
  LoginCompletePage({Key? key,}) : super(key: key);

  @override
  _LoginCompletePageState createState() => _LoginCompletePageState();
}

// State class for LoginCompletePage.
class _LoginCompletePageState extends State<LoginCompletePage> {
  // Firebase Authentication instance.
  final _auth = FirebaseAuth.instance;
  // Variable to store the currently logged-in user.
  late User loggedInUser;

  @override
  void initState() {
    super.initState();
    // Get the current user upon initialization.
    getCurrentUser();
  }

  // Function to get the current user using Firebase Authentication.
  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        // Print the email of the logged-in user to the console.
        print(loggedInUser.email);
        // After a short delay, navigate to the Dashboard screen.
        Timer(Duration(seconds: 1), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => DashboardScreen()),
          );
        });
      }
    } catch (e) {
      // Print any errors to the console.
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // AppBar with back button and white background.
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
            // Displaying the app logo.
            Image.asset(
              'images/logo.jpg',
              width: 117.0,
              height: 99.0,
            ),
            SizedBox(height: 20),
            // Welcome message displaying the user's email.
            Text(
              'Welcome ${loggedInUser.email}!',
              style: const TextStyle(
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
