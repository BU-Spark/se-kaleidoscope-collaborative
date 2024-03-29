import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kaleidoscope_collaborative/screens/cloud_firestore_service.dart';
import 'package:kaleidoscope_collaborative/screens/SignUp/identity_Verifed_1_4.dart';
import 'identity_verification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kaleidoscope_collaborative/screens/LoggingIn/constants.dart';

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
  final FocusNode _usernameFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _confirmEmailFocus = FocusNode();
  final FocusNode _phoneNumberFocus = FocusNode();
  final FocusNode _confirmPhoneNumberFocus = FocusNode();

  final _fnameTextController = TextEditingController();
  final _lnameTextController = TextEditingController();
  final _usernameTextController = TextEditingController();
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
    _usernameFocus.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
    _emailFocus.dispose();
    _confirmEmailFocus.dispose();
    _phoneNumberFocus.dispose();
    _confirmPhoneNumberFocus.dispose();
    _fnameTextController.dispose();
    _lnameTextController.dispose();
    _usernameTextController.dispose();
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

  @override
  Widget build(BuildContext context) {

    _fnameFocus.addListener(() { setState(() {}); });
    _lnameFocus.addListener(() { setState(() {}); });
    _usernameFocus.addListener(() { setState(() {}); });
    _passwordFocus.addListener(() { setState(() {}); });
    _confirmPasswordFocus.addListener(() { setState(() {}); });
    _emailFocus.addListener(() { setState(() {}); });
    _confirmEmailFocus.addListener(() { setState(() {}); });
    _phoneNumberFocus.addListener(() { setState(() {}); });
    _confirmPhoneNumberFocus.addListener(() { setState(() {}); });


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
                SizedBox(height: _fnameFocus.hasFocus || _lnameFocus.hasFocus || _usernameFocus.hasFocus ? 20 : 48),

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
                SizedBox(height: 16),

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
                SizedBox(height: 16),

                // UserName input
                TextField(
                  focusNode: _usernameFocus,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Username',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: ()=> clearText(_usernameTextController),
                    ),
                  ),
                  controller: _usernameTextController,
                ),
                SizedBox(height: 32),

                // Password input
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
                  // onChanged: (value) {
                  //   _validatePasswords();
                  // },
                  controller: _passwordTextController,
                ),
                SizedBox(height: 16),

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
                SizedBox(height: 16),

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
                      labelText: 'Phone Number',
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
                SizedBox(height: 16),

                // Confirm Phone Number input
                TextField(
                  focusNode: _confirmPhoneNumberFocus,
                  enabled: isPhoneNumberActive,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: ' Confirm Phone Number',
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

                  onPressed: (_emailOrPhoneNumberMatch && (_passwordsMatch && (_emailMatch || _phoneNumberMatch))) ? ()  async {

                    if (isEmailActive) {
                      // If email is the chosen method, validate emails.
                      bool verificationSuccessful = false;

                      // Navigate to the Identity Verification page and await the result
                      verificationSuccessful = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => IdentityVerificationPage(verificationMethod: _emailTextController.text, resendCode: 'Email')),
                      );


                      if (verificationSuccessful) {

                        Map<String, dynamic> userData = {
                          'first_name': _fnameTextController.text,
                          'last_name': _lnameTextController.text,
                          'username': _usernameTextController.text,
                          'password': _passwordTextController.text,
                          'email': _emailTextController.text,
                          'phone_number': _phoneNumberTextController.text,
                        };
                        // Proceed with Firebase registration and Firestore data addition
                        try {
                          // Add user data to Firestore
                          await service?.addUserData(userData);

                          // For Firebase Auth registration
                            final newUser = _auth.createUserWithEmailAndPassword(email: _emailTextController.text, password: _passwordTextController.text);
                            if(newUser!=null){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => IdentityVerifiedPage()));
                            }
                          // Go to the identity verification page after adding the user
                        } catch (e) {
                          print('Error during Firebase signup: $e');
                        }
                      } else {
                        // Handle verification failure
                        print('Identity verification failed');
                      }
                    } else {
                      // If phone number is the chosen method, validate phone numbers.

                      bool verificationSuccessful = false;
                      // Send a verification code to the given phone number
                      await _auth.verifyPhoneNumber(
                        phoneNumber: _phoneNumberTextController.text,
                        verificationCompleted: (PhoneAuthCredential credential) async {
                          // Auto-resolve the SMS verification code
                        },
                        verificationFailed: (FirebaseAuthException e) {
                          // Handle verification failure
                          print('Phone number verification failed. Code: ${e.code}. Message: ${e.message}');
                        },
                        codeSent: (String verificationId, int? resendToken) async {
                          // Code has been sent to the user, navigate to the code verification page
                          verificationSuccessful = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => IdentityVerificationPage(verificationMethod:_phoneNumberTextController.text, resendCode: 'SMS')),
                          );

                          // Check the result of the code verification
                          if (verificationSuccessful) {
                            Map<String, dynamic> userData = {
                              'first_name': _fnameTextController.text,
                              'last_name': _lnameTextController.text,
                              'username': _usernameTextController.text,
                              'password': _passwordTextController.text,
                              'email': _emailTextController.text,
                              'phone_number': _phoneNumberTextController.text,
                            };

                            await service?.addUserData(userData);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => IdentityVerifiedPage()));

                          } else {
                            // Handle verification failure
                          }
                        },
                        codeAutoRetrievalTimeout: (String verificationId) {
                          // Auto-retrieval time has lapsed
                        },
                      );
                    }

                  } : null,


                  style: kButtonStyle,
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


