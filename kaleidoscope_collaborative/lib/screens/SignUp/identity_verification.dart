import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kaleidoscope_collaborative/screens/LoggingIn/constants.dart';

// Implementing Register New User 1.3.0 - 1.3.3 : Identity Verification Page

//TO DO:
// Adding the authentication code - hard coded for now - to be replaced with the code sent to the user's email/phone number
// Implement the function for the "Resend" button and "Try another verification method" button

class IdentityVerificationPage extends StatefulWidget{
  final String verificationMethod;
  final String resendCode;
  const IdentityVerificationPage({super.key, required this.verificationMethod, required this.resendCode});
  @override
  _IdentityVerificationPageState createState() => _IdentityVerificationPageState();
}

class _IdentityVerificationPageState extends State<IdentityVerificationPage> {
  final List<TextEditingController> _controllers = List.generate(6, (index) => TextEditingController());
  bool _isCodeIncorrect = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String _verificationId;

  @override
  void initState() {
    super.initState();
    if (widget.verificationMethod == 'phone-number') {
      _sendCodeToPhoneNumber();
    } else {
      _sendVerificationEmail();
    }
  }


  void _sendCodeToPhoneNumber() async {
    await _auth.verifyPhoneNumber(
      phoneNumber: widget.verificationMethod, // The phone number to send the code to
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Auto-retrieval or instant verification completed
        await _auth.signInWithCredential(credential);
        // If successful, navigate or perform desired action
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
        _verificationId = verificationId;
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // Auto retrieval timeout, update the state with the new verificationId
        _verificationId = verificationId;
      },
    );
  }
  // Call this function when the 4th box is filled
  void _verifyCode() async {
    final enteredCode = _controllers.map((controller) => controller.text).join();
    // Create a PhoneAuthCredential with the code
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: _verificationId,
      smsCode: enteredCode,
    );

    // Sign in with the credential
    try {
      await _auth.signInWithCredential(credential);
      // If successful, navigate or perform desired action
      Navigator.pop(context, true);
    } catch (e) {
      // Handle the error and update the UI accordingly
      setState(() {
        _isCodeIncorrect = true;
      });
    }
  }


  void _sendVerificationEmail() async {
    User? user = _auth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  // Call this function when the verification code is entered
  void _verifyEmail() async {
    User? user = _auth.currentUser;
    if (user != null && !user.emailVerified) {
      try {
        await user.reload();
        if (user.emailVerified) {
          // If email is verified successfully, you can navigate or perform other actions
          // For example:
          Navigator.pop(context, true);
        } else {
          // Email verification failed
          setState(() {
            _isCodeIncorrect = true;
          });
        }
      } catch (e) {
        print("Error verifying email: $e");
        setState(() {
          _isCodeIncorrect = true;
        });
      }
    }
  }
  @override
  void dispose() {
    // Dispose the controllers when the state is disposed
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

//   @override
//   Widget build(BuildContext context) {
//     // _fnameFocus.addListener(() { setState(() {}); });
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Identity Verification Page',style: TextStyle(color:Colors.black)),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//         backgroundColor: Colors.white,
//         elevation: 0, // Removes the shadow under the app bar
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: <Widget>[
//             Image.asset(
//               'images/logo.jpg',
//               width: 117.0, // Set the width to match your design
//               height: 99.0, // Set the height to match your design
//             ),
//             SizedBox(height: 40),

//             Text(
//               'Enter Verification Code',
//               textAlign: TextAlign.center,
//               style: TextStyle(fontSize: 21.0, fontWeight: FontWeight.bold)),
//               SizedBox(height: 70), 

//             Text(
//               'Verification Code sent to ${widget.verificationMethod}',
//               textAlign: TextAlign.center,
//               style: TextStyle(fontSize: 16.0)),
//               SizedBox(height: 16),

//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: List.generate(6, (index) {
//                   return SizedBox(
//                     width: 50,
//                     child: TextField(
//                       controller: _controllers[index],
//                       decoration: InputDecoration(
//                         border: OutlineInputBorder(),
//                         errorText: _isCodeIncorrect && index == 5 ? 'Incorrect code' : null, // Show error on the last box only
//                       ),
//                       keyboardType: TextInputType.number,
//                       textAlign: TextAlign.center,
//                       maxLength: 1,
//                       onChanged: (value) {
//                         if (value.length == 1 && index < 5) {
//                           // Move to the next field if the current one is filled
//                           FocusScope.of(context).nextFocus();
//                         }
//                         if (value.length == 1 && index == 5) {
//                           // If the last box is filled, verify the code
//                           _verifyCode();
//                         }
//                       },
//                     ),
//                   );
//                 }),
//               ),

//             SizedBox(height: 16),
//             Text(
//               'Did not receive the text?',
//               textAlign: TextAlign.center,),
//               SizedBox(height: 16),

//             // Resend SMS
//             ElevatedButton(
//               onPressed: () {
//               },
//               child: Text('Resend ${widget.resendCode}'),
//               style: kButtonStyle
//             ),
//             SizedBox(height: 16),


//             // Try another verification method
//             ElevatedButton(
//               onPressed: () {
//               },
//               child: Text('Try another verification method'),
//               style: kButtonStyle
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Identity Verification'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.verificationMethod == 'phone-number' ? 'Enter Verification Code' : 'Check your email',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 21.0, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            if (widget.verificationMethod == 'phone-number')
              _phoneVerificationUI(),
            if (widget.verificationMethod == 'email')
              _emailVerificationUI(),
          ],
        ),
      ),
    );
  }

  Widget _phoneVerificationUI() {
    return const Column(
      children: [
        // UI Components for phone verification...
      ],
    );
  }

Widget _emailVerificationUI() {
  return Scaffold(
      appBar: AppBar(
        title: const Text('Identity Verification Page',style: TextStyle(color:Colors.black)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
        elevation: 0, // Removes the shadow under the app bar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Image.asset(
              'images/logo.jpg',
              width: 117.0, // Set the width to match your design
              height: 99.0, // Set the height to match your design
            ),
            const SizedBox(height: 40),

            const Text(
              'Enter Verification Code',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 21.0, fontWeight: FontWeight.bold)),
              const SizedBox(height: 70), 

            Text(
              'Verification Code sent to ${widget.verificationMethod}',
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
                        errorText: _isCodeIncorrect && index == 5 ? 'Incorrect code' : null, // Show error on the last box only
                      ),
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      onChanged: (value) {
                        if (value.length == 1 && index < 5) {
                          // Move to the next field if the current one is filled
                          FocusScope.of(context).nextFocus();
                        }
                        if (value.length == 1 && index == 5) {
                          // If the last box is filled, verify the code
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

            // Resend SMS
            ElevatedButton(
              onPressed: () {
              },
              style: kButtonStyle,
              child: Text('Resend ${widget.resendCode}')
            ),
            const SizedBox(height: 16),


            // Try another verification method
            ElevatedButton(
              onPressed: () {
              },
              style: kButtonStyle,
              child: const Text('Try another verification method')
            ),
          ],
        ),
      ),
    );
  }
}