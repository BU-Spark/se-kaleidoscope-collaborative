import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kaleidoscope_collaborative/screens/SignUp/email_verification.dart';
import 'package:kaleidoscope_collaborative/screens/SignUp/phone_verification.dart';
import 'package:kaleidoscope_collaborative/screens/cloud_firestore_service.dart';
import 'package:kaleidoscope_collaborative/screens/SignUp/identity_Verifed_1_4.dart';
import 'identity_verification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kaleidoscope_collaborative/screens/LoggingIn/constants.dart';
import 'package:intl/intl.dart';


// Implementing the 1.1 -  1.2.3 Sign Up Page

class SignupScreen extends StatefulWidget{
  const SignupScreen({super.key});
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  CloudFirestoreService? service;

  final FocusNode _fnameFocus = FocusNode();
  final FocusNode _lnameFocus = FocusNode();
  final TextEditingController _birthdayTextController = TextEditingController();
  // final FocusNode _usernameFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _confirmEmailFocus = FocusNode();
  final FocusNode _phoneNumberFocus = FocusNode();
  final FocusNode _confirmPhoneNumberFocus = FocusNode();

  final _fnameTextController = TextEditingController();
  final _lnameTextController = TextEditingController();
  // final _usernameTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _confirmPasswordTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _confirmEmailTextController = TextEditingController();
  final _phoneNumberTextController = TextEditingController();
  final _confirmPhoneNumberTextController = TextEditingController();

  bool isEmailActive = true;
  bool isPhoneNumberActive = true;

  bool _passwordsMatch = true;
  bool _emailMatch = true;
  bool _phoneNumberMatch = true;
  bool _emailOrPhoneNumberMatch = false;

  DateTime? _selectedBirthday;

  @override
  void initState() {
    // Initialize an instance of Cloud Firestore
    service = CloudFirestoreService(FirebaseFirestore.instance);
    super.initState();
  }

  void setEmailActive() {
    setState(() {
      isEmailActive = true;
      isPhoneNumberActive = false;
      clearText(_phoneNumberTextController);
      clearText(_confirmPhoneNumberTextController);
      _emailOrPhoneNumberMatch = false;
    });
  }

  void setPhoneNumberActive() {
    setState(() {
      isEmailActive = false;
      isPhoneNumberActive = true;
      clearText(_emailTextController);
      clearText(_confirmEmailTextController);
      _emailOrPhoneNumberMatch = false;
    });
  }


  void clearText(TextEditingController controller) {
    controller.clear();
  }


  @override
  void dispose() {
    _fnameFocus.dispose();
    _lnameFocus.dispose();
    _birthdayTextController.dispose();
    // _usernameFocus.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
    _emailFocus.dispose();
    _confirmEmailFocus.dispose();
    _phoneNumberFocus.dispose();
    _confirmPhoneNumberFocus.dispose();
    _fnameTextController.dispose();
    _lnameTextController.dispose();
    // _usernameTextController.dispose();
    _passwordTextController.dispose();
    _confirmPasswordTextController.dispose();
    _emailTextController.dispose();
    _confirmEmailTextController.dispose();
    _phoneNumberTextController.dispose();
    _confirmPhoneNumberTextController.dispose();
    super.dispose();
  }

  void _validatePasswords() {
    setState(() {
      _passwordsMatch = _passwordTextController.text == _confirmPasswordTextController.text;

    });
  }

  void _validateEmailId() {
    setState(() {
      _emailMatch = _emailTextController.text == _confirmEmailTextController.text;
      _phoneNumberMatch = false;
      _emailOrPhoneNumberMatch = _emailMatch;

    });
  }

  void _validatePhoneNumber() {
    setState(() {
      _phoneNumberMatch = _phoneNumberTextController.text == _confirmPhoneNumberTextController.text;
      _emailMatch = false;
      _emailOrPhoneNumberMatch = _phoneNumberMatch;
    });
  }

  void _submitForm() async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: _emailTextController.text.trim(), password: _passwordTextController.text.trim(),
      );

      // send an email verification

      User? user = userCredential.user;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
  

      // navigate to the EmailVerificationPage
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => EmailVerificationPage(email: _emailTextController.text.trim()),
        ));
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to sign up: $e.message')),
      );
    }
  }

  Future<void> _selectBirthday(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedBirthday ?? DateTime(2000), // Adjust as necessary
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedBirthday) {
      setState(() {
        _selectedBirthday = picked;
        // Update the text controller with formatted date
        _birthdayTextController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    _fnameFocus.addListener(() { setState(() {}); });
    _lnameFocus.addListener(() { setState(() {}); });
    // _usernameFocus.addListener(() { setState(() {}); });
    _passwordFocus.addListener(() { setState(() {}); });
    _confirmPasswordFocus.addListener(() { setState(() {}); });
    _emailFocus.addListener(() { setState(() {}); });
    _confirmEmailFocus.addListener(() { setState(() {}); });
    _phoneNumberFocus.addListener(() { setState(() {}); });
    _confirmPhoneNumberFocus.addListener(() { setState(() {}); });

  void showEmailVerificationFailedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Email Verification Failed'),
          content: Text('We were unable to verify your email. Please try the verification process again.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void showPhoneVerificationFailedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Phone Verification Failed'),
          content: Text('We were unable to verify your phone number. Please try the verification process again.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('1.1 Sign Up', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Scrollbar(
        thumbVisibility: true,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Image.asset(
                  'images/logo.jpg',
                  width: 117.0, 
                  height: 99.0, 
                ),
                SizedBox(height: _fnameFocus.hasFocus || _lnameFocus.hasFocus ? 20 : 48),

                // First Name input
                TextField(
                  focusNode: _fnameFocus,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'First Name',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: ()=> clearText(_fnameTextController),
                    ),
                  ),
                  controller: _fnameTextController,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),

                // Last Name input
                TextField(
                  focusNode: _lnameFocus,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Last Name',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: ()=> clearText(_lnameTextController),
                    ),
                  ),
                  controller: _lnameTextController,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),

                // Birthday input
                GestureDetector(
                  onTap: () => _selectBirthday(context),
                  child: AbsorbPointer(
                    child: TextField(
                      controller: _birthdayTextController, // Use the controller here
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Birthday',
                        suffixIcon: Icon(Icons.calendar_today),
                        // Removed hintText as controller now controls the text
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),

                TextField(
                  focusNode: _passwordFocus,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: ()=> clearText(_passwordTextController),
                    ),
                  ),
                  controller: _passwordTextController,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),

                // Confirm Password input
                TextField(
                  focusNode: _confirmPasswordFocus,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: ' Confirm Password',
                    errorText: _passwordsMatch ? null : 'Passwords do not match',

                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: ()=> clearText(_confirmPasswordTextController),

                    ),
                  ),
                  controller: _confirmPasswordTextController,
                  onChanged: (value) {
                    _validatePasswords();
                  },
                ),
                SizedBox(height: 32),

                // Email input
                GestureDetector(
                  child:
                  TextField(
                    focusNode: _emailFocus,
                    enabled: isEmailActive,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: ()=> clearText(_emailTextController),
                      ),
                    ),
                    controller: _emailTextController,
                    onTap: () => setEmailActive(),
                  ),
                  onTap: () => setEmailActive(),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),

                // Confirm Email input
                TextField(
                  focusNode: _confirmEmailFocus,
                  enabled: isEmailActive,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: ' Confirm Email',
                    errorText: _emailMatch ? null : 'Email ids do not match',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: ()=> clearText(_confirmEmailTextController),
                    ),
                  ),
                  controller: _confirmEmailTextController,
                  onChanged: (value) {
                    _validateEmailId();
                  },
                  onTap: () => setEmailActive(),
                ),
                SizedBox(height: 32),



                // Divider with 'or'
                const Row(
                  children: <Widget>[
                    Expanded(child: Divider(
                      color: Colors.black,
                      thickness: 1,
                    )),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text('or'),
                    ),
                    Expanded(child: Divider(
                      color: Colors.black,
                      thickness: 1,
                    )),
                  ],
                ),
                SizedBox(height: 32),

                // Phone Number input
                GestureDetector(
                  child:
                  TextField(
                    focusNode: _phoneNumberFocus,
                    enabled: isPhoneNumberActive,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Phone Number (optional)',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: ()=> clearText(_phoneNumberTextController),
                      ),
                    ),
                    controller: _phoneNumberTextController,
                    onTap: () => setPhoneNumberActive(),
                  ),
                  onTap: () => setPhoneNumberActive(),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),

                // Confirm Phone Number input
                TextField(
                  focusNode: _confirmPhoneNumberFocus,
                  enabled: isPhoneNumberActive,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: ' Confirm Phone Number (optional)',
                    errorText: _phoneNumberMatch ? null : 'Phone numbers do not match',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: ()=> clearText(_confirmPhoneNumberTextController),
                    ),
                  ),
                  controller: _confirmPhoneNumberTextController,
                  onChanged: (value) {
                    _validatePhoneNumber();
                  },
                  onTap: () => setPhoneNumberActive(),
                ),
                SizedBox(height: 32),

                ElevatedButton(
                  child: Text('Submit'),
                  onPressed: (_emailOrPhoneNumberMatch && (_passwordsMatch && (_emailMatch || _phoneNumberMatch)))
                      ? () async {
                          if (isEmailActive && _emailMatch) {
                            // Navigate to Email Verification page
                            final emailVerificationSuccessful = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EmailVerificationPage(
                                  email: _emailTextController.text, // Corrected this line
                                ),
                              ),
                            );
                          } else if (isPhoneNumberActive && _phoneNumberMatch) {
                            // Navigate to Phone Verification page
                            final phoneVerificationSuccessful = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PhoneVerificationPage(
                                  phoneNumber: _phoneNumberTextController.text,
                                  resendCode: 'SMS',
                                ),
                              ),
                            );
                          }
                        }
                      : null, // Disable button if conditions are not met
                  style: kButtonStyle, // Your custom button style
                ),
                SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


