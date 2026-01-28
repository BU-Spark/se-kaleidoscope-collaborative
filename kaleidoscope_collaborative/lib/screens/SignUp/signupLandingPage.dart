import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaleidoscope_collaborative/config/app_theme.dart';
import 'package:kaleidoscope_collaborative/widgets/glassmorphic_button.dart';
import 'signup1_1.dart';
import 'package:kaleidoscope_collaborative/screens/auth/social_auth.dart';

// Implementing the 1.0 Sign Up Landing Page

class SignupLandingPage extends StatefulWidget {
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
    // Limit text scale factor for the entire signup landing page
    final textScaleFactor =
        MediaQuery.of(context).textScaleFactor.clamp(1.0, 1.3);

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaleFactor: textScaleFactor,
      ),
      child: Scaffold(
        appBar: AppBar(
          leading: Center(
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              constraints: const BoxConstraints(),
            ),
          ),
          backgroundColor: AppTheme.backgroundColor,
          elevation: 0,
          toolbarHeight: 48,
        ),
        backgroundColor: AppTheme.backgroundColor,
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Image.asset(
                'images/logo.jpg',
                width: 120.0,
                height: 100.0,
              ),
              const SizedBox(height: 24),

              // Title
              Text(
                'Sign Up',
                textAlign: TextAlign.center,
                style: GoogleFonts.openSans(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 48),

              GlassmorphicButton(
                text: 'Sign Up in App',
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(
                          builder: (context) => const SignupScreen()));
                },
              ),
              const SizedBox(height: 16),

              Row(
                children: <Widget>[
                  const Expanded(child: Divider(thickness: 1)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      'or',
                      style: GoogleFonts.openSans(
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  const Expanded(child: Divider(thickness: 1)),
                ],
              ),
              const SizedBox(height: 16),

              // Sign Up with Apple (iOS only) – shown first on iOS per Guideline 4.8
              if (Platform.isIOS) ...[
                GlassmorphicButton(
                  text: 'Sign Up with Apple',
                  onPressed: () async {
                    try {
                      await signInWithApple(context);
                    } catch (e) {
                      print('Apple sign-in error: $e');
                      if (context.mounted) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Login Error'),
                            content: const Text(
                                'Failed to sign in with Apple. Please try again.'),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('OK'),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                            ],
                          ),
                        );
                      }
                    }
                  },
                ),
                const SizedBox(height: 16),
              ],

              GlassmorphicButton(
                text: 'Sign Up with Google',
                onPressed: () async {
                  try {
                    await signInWithGoogle(context);
                  } catch (error) {
                    print('Google sign-in failed: $error');
                    if (context.mounted) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Login Error'),
                          content: const Text(
                              'Failed to sign in with Google. Please try again.'),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('OK'),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ],
                        ),
                      );
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
