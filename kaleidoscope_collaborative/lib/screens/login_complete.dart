import 'package:flutter/material.dart';


class LoginCompletePage extends StatelessWidget {
  final String username;

  // Accepting the username as a parameter
  LoginCompletePage({Key? key, required this.username}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Assuming you have a LogoWidget defined elsewhere
            Image.asset(
            'images/logo.jpg',
              width: 117.0, // Set the width to match your design
              height: 99.0, // Set the height to match your design
            ),
            SizedBox(height: 20),
            Text(
              'Welcome $username!', // Display the passed username
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