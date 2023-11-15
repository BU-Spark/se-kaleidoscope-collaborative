import 'package:flutter/material.dart';
import 'package:kaleidoscope_collaborative/constants.dart';


class LoginScreen extends StatefulWidget{
  const LoginScreen({super.key});
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  @override
  void dispose() {
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    _emailFocus.addListener(() { setState(() {}); });
    _passwordFocus.addListener(() { setState(() {}); });

    return Scaffold(
      appBar: AppBar(
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
              Image.asset(
                'images/logo.jpg',
                width: 117.0, // Set the width to match your design
                height: 99.0, // Set the height to match your design
              ),
              SizedBox(height: _emailFocus.hasFocus || _passwordFocus.hasFocus ? 20 : 48),

              // Email input
              TextField(
                focusNode: _emailFocus,
                decoration: InputDecoration(
                  labelText: 'Email',
                  suffixIcon: Icon(Icons.close),
                ),
              ),
              SizedBox(height: 16),

              // Password input
              TextField(
                focusNode: _passwordFocus,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  suffixIcon: Icon(Icons.close),
                ),
              ),
              SizedBox(height: 32),

              // Log In button
              ElevatedButton(
                child: Text('Log In'),
                onPressed: () {
                  // Perform login
                },
                style: kButtonStyle,
              ),
              TextButton(
                child: Text('Forgot password?'),
                onPressed: () {
                  // Forgot password
                },
              ),
              SizedBox(height: 16),

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
              SizedBox(height: 16),

              // Social buttons
              ElevatedButton(
                child: Text('Log In with Facebook'),
                onPressed: () {
                  // Facebook login
                },
                style: kButtonStyle,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                child: Text('Log In with Google'),
                onPressed: () {
                  // Google login
                },
                style: kButtonStyle,
              ),
              SizedBox(height: 32),

              // Sign Up link
              TextButton(
                child: Text('Don’t have an account? Sign Up'),
                onPressed: () {
                  // Forgot password
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}


