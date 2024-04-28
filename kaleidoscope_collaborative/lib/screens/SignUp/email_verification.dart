import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kaleidoscope_collaborative/screens/LoggingIn/login_screen.dart';

// Implementing Register New User 1.3.0 - 1.3.3 : Identity Verification Page

//TO DO:
// Adding the authentication code - hard coded for now - to be replaced with the code sent to the user's email/phone number
// Implement the function for the "Resend" button and "Try another verification method" button

class EmailVerificationPage extends StatefulWidget {
  final String email;
  const EmailVerificationPage({Key? key, required this.email, required String verificationMethod, required String resendCode}) : super(key: key);

  @override
  _EmailVerificationPageState createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Start checking for email verification immediately
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      await _checkEmailVerified();
    });
  }

  Future<void> _checkEmailVerified() async {
    // Call this before checking email verification status
    await _auth.currentUser?.reload();
    User? user = _auth.currentUser;
    
    if (user != null && user.emailVerified) {
      _timer?.cancel();
      // Navigate to your desired route upon verification
      Navigator.of(context).pushReplacementNamed('/verificationComplete');
    }
  }

  Future<void> _resendEmail() async {
    print("thi;");
    User? user = _auth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
      // Show a snackbar to let the user know the email was resent
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Verification email resent. Check your email.')),
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Your Email'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('A verification email has been sent to ${widget.email}. Please check your email and follow the instructions to verify your account.'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _resendEmail,
              child: const Text('Resend Email'),
            ),
            const SizedBox(height: 24),
            TextButton(
              onPressed: () async {
                // Sign out the user
                await FirebaseAuth.instance.signOut();
                // Navigate to the SignupScreen
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const LoginScreen(), // This should be your signup screen widget
                ));
              },
              child: const Text('Cancel and sign in'),
            ),
          ],
        ),
      ),
    );
  }
}