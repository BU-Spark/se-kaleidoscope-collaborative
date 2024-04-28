// This Flutter code defines the user interface for a "Create New Password" page, which is used for password reset.

import 'package:flutter/material.dart';
import 'package:kaleidoscope_collaborative/screens/LoggingIn/constants.dart';
import 'package:kaleidoscope_collaborative/screens/LoggingIn/reset_complete.dart';

// Define a StatefulWidget for creating a new password.
class CreatePassword extends StatefulWidget {
  const CreatePassword({Key? key}) : super(key: key);

  @override
  _CreatePasswordState createState() => _CreatePasswordState();
}

// The state class for CreatePassword StatefulWidget.
class _CreatePasswordState extends State<CreatePassword> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  // Function to clear the text in a text field.
  void clearText(TextEditingController controller) {
    controller.clear();
  }

  // Dispose controllers when the widget is disposed to prevent memory leaks.
  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // AppBar with back button.
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        // title: Text('Create new password', style: TextStyle(color: Colors.black)),
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
              // Displaying the app logo
              Image.asset(
                'images/logo.jpg',
                width: 117.0,
                height: 99.0,
              ),
              const SizedBox(height: 48),
              // Title for the password reset screen.
              const Text(
                'Create New Password',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              // Instruction text for creating a new password.
              const Text(
                'Your new password must be different from previously used passwords.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              // Password requirements description.
              Text(
                'Password should be: 7-10 Characters in length; 1 capital letter; 1 number; 1 special character',
                style: TextStyle(color: Colors.grey[700]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              // TextField for the new password.
              // TODO: Implement the logic to distinguish the new password from previously used passwords.
              // TODO: Also add input password text validation (password should be 7-10 Characters in length; 1 capital letter; 1 number; 1 special character)
              TextField(
                controller: _newPasswordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () => clearText(_newPasswordController),
                  ),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16),
              // TextField for confirming the new password.
              TextField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () => clearText(_confirmPasswordController),
                  ),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 24),
              // Button to submit the new password.
              // TODO: Check if _newPasswordController.text and _confirmPasswordController.text match. If it matches go to PasswordConfirmedScreen (reset_complete.dart) or else display error message.
              ElevatedButton(
                onPressed: () {
                  // Navigate to the password confirmed screen upon successful reset.
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const PasswordConfirmedScreen()));
                },
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
