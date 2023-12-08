import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:kaleidoscope_collaborative/screens/HomeAndLanding/onboarding_page.dart';


class IdentityVerifiedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Identity Verified Page',style: TextStyle(color:Colors.black)),

        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => OnboardingScreen()),
              ),
              child: Icon(
                MaterialCommunityIcons.check_circle_outline,
                color: Colors.green,
                size: 80.0, // Adjust the size as needed
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Identity Verified',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            // You can add more widgets here as needed
          ],
        ),
      ),
    );
  }
}
