import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaleidoscope_collaborative/config/app_theme.dart';
import 'package:kaleidoscope_collaborative/widgets/glassmorphic_button.dart';
import 'signup1_1.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kaleidoscope_collaborative/screens/firebase_options.dart';
import 'package:kaleidoscope_collaborative/screens/LoggingIn/login_complete.dart';

// Implementing the 1.0 Sign Up Landing Page

class SignupLandingPage extends StatefulWidget{
  const SignupLandingPage({super.key});
  @override
  _SignupLandingPageState createState() => _SignupLandingPageState();
}


class _SignupLandingPageState extends State<SignupLandingPage> {
    void showLoginFailedDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Login Failed'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Limit text scale factor for the entire signup landing page
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
          backgroundColor: AppTheme.backgroundColor,
          elevation: 0,
          toolbarHeight: 48,
        ),
        backgroundColor: AppTheme.backgroundColor,
        body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Image.asset(
              'images/logo.jpg',
              width: 120.0,
              height: 100.0,
            ),
            const SizedBox(height: 24),

            // Title
            Text(
              'Sign Up',
              textAlign: TextAlign.center,
              style: GoogleFonts.openSans(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 48),

            GlassmorphicButton(
              text: 'Sign Up in App',
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const SignupScreen()));
              },
            ),
            const SizedBox(height: 16),

            Row(
              children: <Widget>[
                const Expanded(child: Divider(thickness: 1)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    'or',
                    style: GoogleFonts.openSans(
                      color: Colors.black54,
                    ),
                  ),
                ),
                const Expanded(child: Divider(thickness: 1)),
              ],
            ),
            const SizedBox(height: 16),

            // Sign Up with Facebook Button
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
                  }
                } catch (e) {
                  // If an error occurs, log the error and show a dialog to the user.
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

            GlassmorphicButton(
              text: 'Log In with Google',
              onPressed: () async {
                try {
                  await signInWithGoogle(context);
                } catch (error) {
                  print('Google sign-in failed: $error');
                  if (context.mounted) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Login Error'),
                        content: const Text(
                            'Failed to sign in with Google. Please try again.'),
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
      if (userCredential.user != null && context.mounted) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const LoginCompletePage()));
      }
    }
  } catch (error) {
    print('Google sign-in failed: $error');
    rethrow; // Re-throw to be handled by the caller
  }
}