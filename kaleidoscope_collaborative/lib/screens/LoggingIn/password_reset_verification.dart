// This screen handles verification of users by entering a code sent to their email or phone.
import 'package:flutter/material.dart';
import 'package:kaleidoscope_collaborative/screens/LoggingIn/verification_complete.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:kaleidoscope_collaborative/screens/LoggingIn/constants.dart';

// StatefulWidget for the Verification Code Screen.
class VerificationCodeScreen extends StatefulWidget {
  final String unique_id;
  final String verification_type;        // TODO: Add an additional variable to accept the verification code sent to user. It needs to be a required parameter.

  const VerificationCodeScreen({Key? key, required this.unique_id, required this.verification_type}) : super(key: key);

  @override
  _VerificationCodeScreenState createState() => _VerificationCodeScreenState();
}

// State class for VerificationCodeScreen.
class _VerificationCodeScreenState extends State<VerificationCodeScreen> {
  // Text editing controller for PIN input.
  final TextEditingController _pinController = TextEditingController();

  // Dispose controller when the widget is disposed.
  @override
  void dispose() {
    _pinController.dispose();
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
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Displaying the app logo.
              Image.asset(
                'images/logo.jpg',
                height: 99.0,
              ),
              const SizedBox(height: 48),
              // Title for entering the verification code.
              const Text(
                'Enter Verification Code',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              // Display where the verification code was sent.
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Password reset verification sent to\n${widget.unique_id}',
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 24),
              // PIN code text field.
              PinCodeTextField(
                appContext: context,
                length: 4,
                controller: _pinController,
                onChanged: (String value) {
                  // Navigate to verification complete screen when code is filled.
                  if (value.length == 4) {
                    Future.delayed(const Duration(milliseconds: 100), () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const VerificationComplete()));    // TODO: Compare the verification code sent to user with the user's input into PinCodeTextField. If the codes match navigate to VerificationComplete page. Or else display an error message.
                    });
                  }
                },
                // Styling for the PIN code field.
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(5),
                  fieldHeight: 50,
                  fieldWidth: 50,
                  activeFillColor: Colors.white,
                  inactiveColor: Colors.blue,
                  selectedColor: Colors.blue,
                  activeColor: Colors.blue,
                ),
                keyboardType: TextInputType.number,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
              ),
              const SizedBox(height: 24),
              // Option to resend the verification code.
              Text(
                'Did not receive the ${widget.verification_type}?',
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              // Button to resend email.
              ElevatedButton(
                onPressed: () {
                  //TODO: Implement resend logic (same as the logic implemented in forgot password page)
                },
                style: kButtonStyle,
                child: const Text('Resend Email'),
              ),
              const SizedBox(height: 16),
              // Button to change email address.
              ElevatedButton(
                onPressed: () {
                  // TODO: Go back to forgot password page
                },
                style: kButtonStyle,
                child: const Text('Try another email address'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
