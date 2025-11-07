import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kaleidoscope_collaborative/screens/first_screen.dart';
import 'package:kaleidoscope_collaborative/screens/HomeAndLanding/home_page.dart';

/// AuthWrapper checks if user is logged in and routes accordingly
/// - If logged in: Navigate to DashboardScreen (home page)
/// - If not logged in: Navigate to FirstScreen (login/signup)
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Show loading indicator while checking auth state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // If user is logged in, go to home page
        if (snapshot.hasData && snapshot.data != null) {
          return const DashboardScreen();
        }

        // If not logged in, show first screen (login/signup)
        return const FirstScreen();
      },
    );
  }
}
