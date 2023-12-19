// This is the Login Screen for user authentication with email and password, and options for social media login.
import 'package:flutter/material.dart';
import 'package:kaleidoscope_collaborative/screens/LoggingIn/constants.dart';
import 'package:kaleidoscope_collaborative/screens/LoggingIn/login_complete.dart';
import 'package:kaleidoscope_collaborative/screens/LoggingIn/forgot_password.dart';
import 'package:firebase_auth/firebase_auth.dart';

// StatefulWidget for the Login Screen.
class LoginScreen extends StatefulWidget{
  const LoginScreen({super.key});
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

// State class for LoginScreen.
class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  // Variables to store email and password input.
  String email = '';
  String password = '';

  // FocusNodes to manage focus of text fields.
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final _passwordTextController = TextEditingController();
  final _emailTextController = TextEditingController();

  // Function to clear text in a text field.
  void clearText(TextEditingController controller) {
    controller.clear();
  }

  // Dispose focus nodes and controllers when the widget is disposed.
  @override
  void dispose() {
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Add listeners to focus nodes to update UI on focus change.
    _emailFocus.addListener(() { setState(() {}); });
    _passwordFocus.addListener(() { setState(() {}); });

    return Scaffold(
      appBar: AppBar(
        // AppBar with back button
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Log in', style: TextStyle(color: Colors.black)),
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
                'images/logo.jpg',
                width: 117.0, // Set the width to match your design
                height: 99.0, // Set the height to match your design
              ),
              SizedBox(height: _emailFocus.hasFocus || _passwordFocus.hasFocus ? 20 : 48),

              // TextField for email input.
              TextField(
                focusNode: _emailFocus,
                obscureText: false,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: ()=> clearText(_emailTextController),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    email = value; // Update email variable with the text field value
                  });
                },
                controller: _emailTextController,
              ),

              SizedBox(height: 16),

              // TextField for password input.
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
                onChanged: (value) {
                  setState(() {
                    password = value; // Update email variable with the text field value
                  });
                },
                controller: _passwordTextController,
              ),
              SizedBox(height: 32),

              // Button for user login.
              ElevatedButton(
                child: Text('Log In'),
                onPressed: () async {
                  try{
                    // For registration
                    // final newUser = _auth.createUserWithEmailAndPassword(email: email, password: password);
                    // if(newUser!=null){
                    //   Navigator.push(context, MaterialPageRoute(builder: (context) => RegCompletePage()));
                    // }

                    final existingUser = await _auth.signInWithEmailAndPassword(email: email, password: password);
                    if(existingUser!=null){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => LoginCompletePage()));
                    }
                  }
                  catch(e){
                    print(e);
                  }
                },
                style: kButtonStyle,
              ),
              // Button to navigate to Forgot Password screen.
              TextButton(
                child: Text('Forgot password?'),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPasswordScreen()));
                },
              ),
              SizedBox(height: 16),

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
              SizedBox(height: 16),

              ElevatedButton(
                child: Text('Log In with Facebook'),
                onPressed: () {
                },
                style: kButtonStyle,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                child: Text('Log In with Google'),
                onPressed: () {
                },
                style: kButtonStyle,
              ),
              SizedBox(height: 32),

              TextButton(
                child: Text('Don’t have an account? Sign Up'),
                onPressed: () {
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}



