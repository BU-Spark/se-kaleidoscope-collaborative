// This is the Forgot Password Screen for users to reset their password using email or phone number.
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kaleidoscope_collaborative/screens/LoggingIn/constants.dart';

// StatefulWidget for the Forgot Password Screen.
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

// State class for ForgotPasswordScreen.
class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  // Text editing controllers for email and phone number fields.
  final _emailTextController = TextEditingController();
  final _phoneTextController = TextEditingController();

  // Function to clear text in a text field.
  void clearText(TextEditingController controller) {
    controller.clear();
  }

  // Dispose controllers when the widget is disposed to prevent memory leaks.
  @override
  void dispose() {
    _emailTextController.dispose();
    _phoneTextController.dispose();
    super.dispose();
  }

  Future passwordReset() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailTextController.text.trim());
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            content: Text('Password reset link sent! Check your email')
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      print(e);
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(content: Text(e.message.toString()),
        ); 
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // AppBar with back button and title.
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Forgot Password', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Displaying the app logo.
              Image.asset(
                'images/logo.jpg', // Ensure you have an image at this path
                width: 117.0,
                height: 99.0,
              ),
              const SizedBox(height: 48),
              // Title for the forgot password screen.
              const Text(
                'Forgot password',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              // Instruction text for entering email or phone number.
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  'Please enter your email or phone number to receive instructions to reset your password.',
                  textAlign: TextAlign.center,
                ),
              ),
              // TextField for entering the email.
              TextField(
                controller: _emailTextController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () => clearText(_emailTextController),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Button to send reset instructions to the entered email.
              ElevatedButton(
                onPressed: passwordReset,
                style: kButtonStyle,
                child: const Text('Reset Password'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}