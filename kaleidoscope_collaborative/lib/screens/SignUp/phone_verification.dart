import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kaleidoscope_collaborative/screens/LoggingIn/constants.dart';

// Implementing Register New User 1.3.0 - 1.3.3 : Identity Verification Page

class PhoneVerificationPage extends StatefulWidget {
  final String phoneNumber;
  final String resendCode;
  const PhoneVerificationPage({super.key, required this.phoneNumber, required this.resendCode, required String verificationMethod});

  @override
  _IdentityVerificationPageState createState() => _IdentityVerificationPageState();
}

class _IdentityVerificationPageState extends State<PhoneVerificationPage> {
  final List<TextEditingController> _controllers = List.generate(6, (index) => TextEditingController());
  bool _isCodeIncorrect = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String _verificationId;

  @override
  void initState() {
    super.initState();
    _sendCodeToPhoneNumber();
  }

  void _sendCodeToPhoneNumber() async {
    await _auth.verifyPhoneNumber(
      phoneNumber: widget.phoneNumber, // The phone number to send the code to
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Auto-retrieval or instant verification completed
        await _auth.signInWithCredential(credential);
        Navigator.pop(context, true); // If successful, navigate or perform desired action
      },
      verificationFailed: (FirebaseAuthException e) {
        // Handle error and display a message to the user
        if (e.code == 'invalid-phone-number') {
          print('The provided phone number is not valid.');
        }
        // Add other error handling if needed
      },
      codeSent: (String verificationId, int? resendToken) {
        // Update the state with the new verificationId
        setState(() {
          _verificationId = verificationId;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // Auto retrieval timeout, update the state with the new verificationId
        setState(() {
          _verificationId = verificationId;
        });
      },
    );
  }

  void _verifyCode() async {
    final enteredCode = _controllers.map((controller) => controller.text).join();
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: _verificationId,
      smsCode: enteredCode,
    );

    try {
      await _auth.signInWithCredential(credential);
      Navigator.pop(context, true); // If successful, navigate or perform desired action
    } catch (e) {
      setState(() {
        _isCodeIncorrect = true;
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Phone Verification', style: TextStyle(color: Colors.black)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const SizedBox(height: 40),
            const Text(
              'Enter Verification Code',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 21.0, fontWeight: FontWeight.bold)),
            const SizedBox(height: 70),
            Text(
              'Verification Code sent to ${widget.phoneNumber}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16.0)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(6, (index) {
                return SizedBox(
                  width: 50,
                  child: TextField(
                    controller: _controllers[index],
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      errorText: _isCodeIncorrect && index == 5 ? 'Incorrect code' : null,
                    ),
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 1,
                    onChanged: (value) {
                      if (value.length == 1 && index < 5) {
                        FocusScope.of(context).nextFocus();
                      }
                      if (value.length == 1 && index == 5) {
                        _verifyCode();
                      }
                    },
                  ),
                );
              }),
            ),
            const SizedBox(height: 16),
            const Text(
              'Did not receive the text?',
              textAlign: TextAlign.center,),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _sendCodeToPhoneNumber,
              style: kButtonStyle,
              child: const Text('Resend SMS')
            ),
          ],
        ),
      ),
    );
  }
}
