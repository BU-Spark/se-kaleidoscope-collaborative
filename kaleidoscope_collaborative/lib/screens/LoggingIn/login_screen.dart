// This is the Login Screen for user authentication with email and password, and options for social login.
import 'dart:io' show Platform;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaleidoscope_collaborative/config/app_theme.dart';
import 'package:kaleidoscope_collaborative/config/globals.dart' as globals;
import 'package:kaleidoscope_collaborative/screens/LoggingIn/forgot_password.dart';
import 'package:kaleidoscope_collaborative/screens/LoggingIn/login_complete.dart';
import 'package:kaleidoscope_collaborative/screens/SignUp/signupLandingPage.dart';
import 'package:kaleidoscope_collaborative/screens/auth/social_auth.dart';
import 'package:kaleidoscope_collaborative/widgets/glassmorphic_button.dart';

// StatefulWidget for the Login Screen.
class LoginScreen extends StatefulWidget {
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

  // Helper function to get user-friendly error messages
  String _getErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'wrong-password':
        return 'Incorrect password. Please try again or use "Forgot password?" to reset it.';
      case 'user-not-found':
        return 'No account found with this email. Please sign up or check your email address.';
      case 'invalid-email':
        return 'Invalid email address. Please check and try again.';
      case 'user-disabled':
        return 'This account has been disabled. Please contact support.';
      case 'too-many-requests':
        return 'Too many failed login attempts. Please try again later.';
      case 'operation-not-allowed':
        return 'Email/password sign-in is not enabled. Please contact support.';
      case 'account-exists-with-different-credential':
        return 'An account already exists with the same email but different sign-in method. Please sign in with Google or Apple instead.';
      case 'invalid-credential':
        return 'Invalid credentials. Please check your email and password.';
      case 'network-request-failed':
        return 'Network error. Please check your internet connection and try again.';
      default:
        return 'Login failed: ${e.message ?? 'Unknown error occurred'}. Please try again.';
    }
  }

  // Show error dialog to user
  void _showErrorDialog(String message) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Login Error',
          style: GoogleFonts.openSans(fontWeight: FontWeight.bold),
        ),
        content: Text(
          message,
          style: GoogleFonts.openSans(fontSize: 14),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('OK', style: GoogleFonts.openSans()),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  // Dispose focus nodes and controllers when the widget is disposed.
  @override
  void dispose() {
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _emailTextController.dispose();
    _passwordTextController.dispose();
    super.dispose();
  }

  InputDecoration _buildInputDecoration(String label, {Widget? suffixIcon}) {
    return InputDecoration(
      labelText: label,
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide:
            BorderSide(color: AppTheme.primaryColor.withValues(alpha: 0.3)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: AppTheme.primaryColor, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Add listeners to focus nodes to update UI on focus change.
    _emailFocus.addListener(() {
      setState(() {});
    });
    _passwordFocus.addListener(() {
      setState(() {});
    });

    // Limit text scale factor for the entire login screen
    final textScaleFactor = MediaQuery.of(context).textScaleFactor.clamp(1.0, 1.3);

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaleFactor: textScaleFactor,
      ),
      child: Scaffold(
      appBar: AppBar(
        leading: Center(
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            constraints: const BoxConstraints(),
          ),
        ),
        title: Text(
          'Log In',
          style: GoogleFonts.openSans(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
        toolbarHeight: 48,
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
              SizedBox(
                  height: _emailFocus.hasFocus || _passwordFocus.hasFocus
                      ? 20
                      : 48),

              // TextField for email input.
              // TODO: Email text input validation on the front end
              TextField(
                focusNode: _emailFocus,
                obscureText: false,
                keyboardType: TextInputType.emailAddress,
                decoration: _buildInputDecoration(
                  'Email',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () => clearText(_emailTextController),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    email =
                        value; // Update email variable with the text field value
                  });
                },
                controller: _emailTextController,
              ),

              const SizedBox(height: 16),

              // TODO: Password input validation on the front end
              // TextField for password input.
              TextField(
                focusNode: _passwordFocus,
                obscureText: true,
                decoration: _buildInputDecoration(
                  'Password',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () => clearText(_passwordTextController),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    password =
                        value; // Update email variable with the text field value
                  });
                },
                controller: _passwordTextController,
              ),
              const SizedBox(height: 32),

              // Button for user login.
              GlassmorphicButton(
                text: 'Log In',
                onPressed: () async {
                  // Basic validation
                  if (email.trim().isEmpty) {
                    _showErrorDialog('Please enter your email address.');
                    return;
                  }
                  if (password.isEmpty) {
                    _showErrorDialog('Please enter your password.');
                    return;
                  }

                  try {
                    await _auth.signInWithEmailAndPassword(
                        email: email.trim(), password: password);
                    if (mounted) {
                      globals.userEmail = _emailTextController.text;
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginCompletePage()));
                    }
                  } on FirebaseAuthException catch (e) {
                    print('Login error: ${e.code} - ${e.message}');
                    if (mounted) {
                      _showErrorDialog(_getErrorMessage(e));
                    }
                  } catch (e) {
                    print('Unexpected login error: $e');
                    if (mounted) {
                      _showErrorDialog('An unexpected error occurred. Please try again.');
                    }
                  }
                },
              ),
              // Button to navigate to Forgot Password screen.
              TextButton(
                child: const Text('Forgot password?'),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ForgotPasswordScreen()));
                },
              ),
              const SizedBox(height: 16),

              const Row(
                children: <Widget>[
                  Expanded(
                      child: Divider(
                    color: Colors.black,
                    thickness: 1,
                  )),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text('or'),
                  ),
                  Expanded(
                      child: Divider(
                    color: Colors.black,
                    thickness: 1,
                  )),
                ],
              ),
              const SizedBox(height: 16),

              // Log In with Apple (iOS only) – shown first on iOS per Guideline 4.8
              if (Platform.isIOS) ...[
                GlassmorphicButton(
                  text: 'Log In with Apple',
                  onPressed: () async {
                    try {
                      await signInWithApple(context);
                    } on FirebaseAuthException catch (e) {
                      print('Apple sign-in error: ${e.code} - ${e.message}');
                      if (mounted) {
                        String message;
                        switch (e.code) {
                          case 'account-exists-with-different-credential':
                            message = 'An account already exists with the same email but was created with email/password or Google. Please sign in with that method instead.';
                            break;
                          case 'invalid-credential':
                            message = 'Invalid Apple credentials. Please try again.';
                            break;
                          case 'operation-not-allowed':
                            message = 'Apple sign-in is not enabled. Please contact support.';
                            break;
                          default:
                            message = 'Failed to sign in with Apple: ${e.message ?? 'Unknown error'}. Please try again.';
                        }
                        _showErrorDialog(message);
                      }
                    } catch (e) {
                      print('Apple sign-in error: $e');
                      if (mounted) {
                        _showErrorDialog('Failed to sign in with Apple. Please try again.');
                      }
                    }
                  },
                ),
                const SizedBox(height: 16),
              ],
              GlassmorphicButton(
                text: 'Log In with Google',
                onPressed: () async {
                  try {
                    await signInWithGoogle(context);
                  } on FirebaseAuthException catch (e) {
                    print('Google sign-in error: ${e.code} - ${e.message}');
                    if (mounted) {
                      String message;
                      switch (e.code) {
                        case 'account-exists-with-different-credential':
                          message = 'An account already exists with the same email but was created with email/password or Apple. Please sign in with that method instead.';
                          break;
                        case 'invalid-credential':
                          message = 'Invalid Google credentials. Please try again.';
                          break;
                        case 'operation-not-allowed':
                          message = 'Google sign-in is not enabled. Please contact support.';
                          break;
                        case 'network-request-failed':
                          message = 'Network error. Please check your internet connection and try again.';
                          break;
                        default:
                          message = 'Failed to sign in with Google: ${e.message ?? 'Unknown error'}. Please try again.';
                      }
                      _showErrorDialog(message);
                    }
                  } catch (e) {
                    print('Google sign-in error: $e');
                    if (mounted) {
                      _showErrorDialog('Failed to sign in with Google. Please try again.');
                    }
                  }
                },
              ),
              const SizedBox(height: 32),

              TextButton(
                child: const Text('Don’t have an account? Sign Up'),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignupLandingPage()));
                },
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
      ),
    );
  }
}
