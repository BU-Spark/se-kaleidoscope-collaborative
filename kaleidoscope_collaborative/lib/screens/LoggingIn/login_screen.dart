// This is the Login Screen for user authentication with email and password, and options for social media login.
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaleidoscope_collaborative/config/app_theme.dart';
import 'package:kaleidoscope_collaborative/screens/LoggingIn/login_complete.dart';
import 'package:kaleidoscope_collaborative/widgets/glassmorphic_button.dart';
import 'package:kaleidoscope_collaborative/screens/LoggingIn/forgot_password.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:kaleidoscope_collaborative/config/globals.dart'
    as globals; // Import the globals

import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kaleidoscope_collaborative/screens/SignUp/signupLandingPage.dart';
import 'package:kaleidoscope_collaborative/screens/firebase_options.dart';

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

    return Scaffold(
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
                  try {
                    await _auth.signInWithEmailAndPassword(
                        email: email, password: password);
                    globals.userEmail = _emailTextController.text;
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginCompletePage()));
                  } catch (e) {
                    print(e);
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

              GlassmorphicButton(
                text: 'Log In with Facebook',
                onPressed: () async {
                  try {
                    final UserCredential? userCredential =
                        await signInWithFacebook();
                    if (userCredential != null && context.mounted) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginCompletePage()));
                    } else {}
                  } catch (e) {
                    // If an error occurs, log the error and show a dialog or a toast to the user.
                    print('Facebook login error: $e');
                    if (context.mounted) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Login Error'),
                          content: const Text(
                              'Failed to sign in with Facebook. Please try again.'),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('OK'),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ],
                        ),
                      );
                    }
                  }
                },
              ),
              const SizedBox(height: 16),
              // TODO: Implement login using google:
              //  Login to firebase -> Go to authentication tab -> Click on Sign-in method -> Add new provider -> choose Google and follow the steps given to integrate it with the onPressed method of the button
              GlassmorphicButton(
                text: 'Log In with Google',
                onPressed: () {
                  signInWithGoogle(context).catchError((error) {
                    print('Google sign-in failed: $error');
                  });
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
    );
  }
}

Future<UserCredential?> signInWithFacebook() async {
  final LoginResult loginResult = await FacebookAuth.instance.login();
  if (loginResult.status == LoginStatus.success) {
    final AccessToken accessToken = loginResult.accessToken!;
    // Create a credential to sign in with Firebase
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(accessToken.token);
    // Use the credential to sign in with Firebase and return the UserCredential
    return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  } else if (loginResult.status == LoginStatus.cancelled) {
    print('Facebook login was cancelled by the user.');
    return null;
  } else {
    final errorMessage = loginResult.message ?? 'Unknown error occurred.';
    print('Facebook login failed: $errorMessage');
    throw FirebaseAuthException(
      code: 'ERROR_FACEBOOK_LOGIN_FAILED',
      message: errorMessage,
    );
  }
}

Future<void> signInWithGoogle(BuildContext context) async {
  final GoogleSignIn googleSignIn = GoogleSignIn(
    clientId: DefaultFirebaseOptions.currentPlatform.iosClientId ??
        '181675201017-kva2g5btcr9n70itatmtffa27h4sss3u.apps.googleusercontent.com',
  );

  try {
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      if (userCredential.user != null) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const LoginCompletePage()));
      }
    }
  } catch (error) {
    print('Google sign-in failed: $error');
    // Handle the error e.g., show a dialog or a snackbar
  }
}
