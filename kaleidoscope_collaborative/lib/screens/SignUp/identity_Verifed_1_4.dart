import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:kaleidoscope_collaborative/screens/HomeAndLanding/onboarding_page.dart';

// Implementing Register New User 1.4 : Identity Verified Page

class IdentityVerifiedPage extends StatefulWidget {
  const IdentityVerifiedPage({super.key});

  @override
  _IdentityVerifiedPageState createState() => _IdentityVerifiedPageState();
}

class _IdentityVerifiedPageState extends State<IdentityVerifiedPage> {
  final _auth = FirebaseAuth.instance;
  late User loggedInUser;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    print("Entered verification");
  }

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
        Timer(const Duration(seconds: 1), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const OnboardingScreen()),
          );
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Identity Verified Page', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const OnboardingScreen()),
              ),
              child: const Icon(
                MaterialCommunityIcons.check_circle_outline,
                color: Colors.green,
                size: 80.0,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
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
