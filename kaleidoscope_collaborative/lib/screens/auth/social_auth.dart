import 'dart:io' show Platform;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import 'package:kaleidoscope_collaborative/screens/firebase_options.dart';
import 'package:kaleidoscope_collaborative/screens/LoggingIn/login_complete.dart';

/// Signs in with Google and navigates to [LoginCompletePage] on success.
/// Throws [FirebaseAuthException] on authentication errors.
Future<void> signInWithGoogle(BuildContext context) async {
  final GoogleSignIn googleSignIn = GoogleSignIn(
    clientId: DefaultFirebaseOptions.currentPlatform.iosClientId ??
        '181675201017-kva2g5btcr9n70itatmtffa27h4sss3u.apps.googleusercontent.com',
  );

  try {
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      // User cancelled the sign-in
      return;
    }

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
  } on FirebaseAuthException {
    // Re-throw Firebase Auth errors so they can be handled by the caller
    rethrow;
  } catch (e) {
    // Wrap other errors in FirebaseAuthException for consistent handling
    throw FirebaseAuthException(
      code: 'google-sign-in-failed',
      message: e.toString(),
    );
  }
}

/// Signs in with Apple (iOS only) and navigates to [LoginCompletePage] on success.
/// No-op on non-iOS platforms.
/// Throws [FirebaseAuthException] on authentication errors.
Future<void> signInWithApple(BuildContext context) async {
  if (!Platform.isIOS) return;

  try {
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    final oauthCredential = OAuthProvider('apple.com').credential(
      idToken: appleCredential.identityToken,
      accessToken: appleCredential.authorizationCode,
    );

    final userCredential =
        await FirebaseAuth.instance.signInWithCredential(oauthCredential);
    if (userCredential.user != null && context.mounted) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginCompletePage()));
    }
  } on SignInWithAppleAuthorizationException catch (e) {
    if (e.code == AuthorizationErrorCode.canceled) {
      return; // User cancelled, no error to show
    }
    // Convert Apple sign-in errors to FirebaseAuthException
    throw FirebaseAuthException(
      code: 'apple-sign-in-failed',
      message: e.toString(),
    );
  } on FirebaseAuthException {
    // Re-throw Firebase Auth errors so they can be handled by the caller
    rethrow;
  } catch (e) {
    // Wrap other errors in FirebaseAuthException for consistent handling
    throw FirebaseAuthException(
      code: 'apple-sign-in-failed',
      message: e.toString(),
    );
  }
}
