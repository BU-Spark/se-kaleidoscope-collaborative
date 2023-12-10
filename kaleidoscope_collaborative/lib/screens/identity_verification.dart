import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kaleidoscope_collaborative/screens/HomeAndLanding/onboarding_page.dart';
import 'package:kaleidoscope_collaborative/screens/LoggingIn/constants.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:kaleidoscope_collaborative/screens/identity_Verifed_1_4.dart';

// Implementing the Idenity Verification Page

class IdentityVerificationPage extends StatefulWidget{
  final String verificationMethod;
  final String resendCode;
  const IdentityVerificationPage({super.key, required this.verificationMethod, required this.resendCode});
  @override
  _IdentityVerificationPageState createState() => _IdentityVerificationPageState();
}

class _IdentityVerificationPageState extends State<IdentityVerificationPage> {
   List<TextEditingController> _controllers = List.generate(4, (index) => TextEditingController());
  bool _isCodeIncorrect = false;

   final _auth = FirebaseAuth.instance;
   late User loggedInUser;

  // Call this function when the 4th box is filled
  void _verifyCode() {
    String enteredCode = _controllers.map((controller) => controller.text).join();
    if (enteredCode == '1234') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => IdentityVerifiedPage()),
      );
    } else {
      setState(() {
        _isCodeIncorrect = true;
      });
    }
  }

  @override
  void initState(){
      super.initState();
      getCurrentUser();
      print("Entered verification");
  }

   void getCurrentUser() async{
     try{
       final user = _auth.currentUser;
       if(user!=null){
         loggedInUser = user;
         print(loggedInUser.email);
       }
     }
     catch(e){
       print(e);
     }
   }
  
  @override
  void dispose() {
    // Dispose the controllers when the state is disposed
    _controllers.forEach((controller) => controller.dispose());
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    // _fnameFocus.addListener(() { setState(() {}); });
    bool _onEditing = true;
    String? _code;
    return Scaffold(
      appBar: AppBar(
        title: Text('Identity Verification Page',style: TextStyle(color:Colors.black)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
        elevation: 0, // Removes the shadow under the app bar
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Image.asset(
              'images/logo.jpg',
              width: 117.0, // Set the width to match your design
              height: 99.0, // Set the height to match your design
            ),
            SizedBox(height: 40),

            Text(
              'Enter Verification Code',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 21.0, fontWeight: FontWeight.bold)),
              SizedBox(height: 70),

            Text(
              'Verification Code sent to ${widget.verificationMethod}',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16.0)),
              SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(4, (index) {
                  return SizedBox(
                    width: 50,
                    child: TextField(
                      controller: _controllers[index],
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        errorText: _isCodeIncorrect ? 'Incorrect code' : null, // Show error on the last box only
                      ),
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      onChanged: (value) {
                        if (value.length == 1 && index < 3) {
                          // Move to the next field if the current one is filled
                          FocusScope.of(context).nextFocus();
                        }
                        if (value.length == 1 && index == 3) {
                          // If the last box is filled, verify the code
                          _verifyCode();
                        }
                      },
                    ),
                  );
                }),
              ),

            SizedBox(height: 16),
            Text(
              'Did not receive the text?',
              textAlign: TextAlign.center,),
              SizedBox(height: 16),

            // Resend SMS
            ElevatedButton(
              onPressed: () {
              },
              child: Text('Resend ${widget.resendCode}'),
              style: kButtonStyle
            ),
            SizedBox(height: 16),


            // Try another verification method
            ElevatedButton(
              onPressed: () {
              },
              child: Text('Try another verification method'),
              style: kButtonStyle
            ),
          ],
        ),
      ),
    );
  }
}