import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kaleidoscope_collaborative/config/app_theme.dart';
import 'package:kaleidoscope_collaborative/config/globals.dart' as globals;
import 'package:kaleidoscope_collaborative/screens/HomeAndLanding/home_page.dart';

class ProfileSetupWidgets {
  static Future<void> handleDeleteAccount(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Delete Account',
          style: GoogleFonts.openSans(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'This will permanently delete your account and all your data (profile, reviews, favorites). You will not be able to recover it.\n\nAre you sure you want to delete your account?',
          style: GoogleFonts.openSans(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text('Cancel', style: GoogleFonts.openSans()),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(
              'Delete',
              style: GoogleFonts.openSans(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const Center(child: CircularProgressIndicator(color: AppTheme.primaryColor)),
    );

    try {
      final auth = FirebaseAuth.instance;
      final firestore = FirebaseFirestore.instance;
      final user = auth.currentUser;
      final email = user?.email ?? globals.userEmail;
      if (email.isEmpty) {
        if (context.mounted) Navigator.of(context).pop();
        _showSnack(context, 'No account to delete.');
        return;
      }

      await firestore.collection('ProfileData').doc(email).delete();
      final favDocs = await firestore.collection('Favorites').where('userId', isEqualTo: email).get();
      for (final d in favDocs.docs) await d.reference.delete();
      final reviewDocs = await firestore.collection('UserReview').where('userID', isEqualTo: email).get();
      for (final d in reviewDocs.docs) await d.reference.delete();
      final userDocs = await firestore.collection('User').where('email', isEqualTo: email).get();
      for (final d in userDocs.docs) await d.reference.delete();

      await user?.delete();

      globals.userEmail = '';
      if (context.mounted) {
        Navigator.of(context).pop();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
          (Route<dynamic> route) => false,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Your account has been deleted.', style: GoogleFonts.openSans()),
            backgroundColor: Colors.green,
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (context.mounted) Navigator.of(context).pop();
      if (e.code == 'requires-recent-login') {
        globals.userEmail = '';
        await FirebaseAuth.instance.signOut();
        if (context.mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const DashboardScreen()),
            (Route<dynamic> route) => false,
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Your data was deleted. Sign in again and use Delete Account to fully remove your account.',
                style: GoogleFonts.openSans(),
              ),
              duration: const Duration(seconds: 5),
            ),
          );
        }
      } else {
        _showSnack(context, 'Could not delete account: ${e.message ?? e.code}');
      }
    } catch (e) {
      if (context.mounted) Navigator.of(context).pop();
      _showSnack(context, 'Failed to delete account. Please try again.');
      debugPrint('Delete account error: $e');
    }
  }

  static void _showSnack(BuildContext context, String message) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message, style: GoogleFonts.openSans()), backgroundColor: Colors.red),
    );
  }

  static Future<void> handleLogout(BuildContext context) async {
    try {
      globals.userEmail = '';
      await FirebaseAuth.instance.signOut();
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
          (Route<dynamic> route) => false,
        );
      }
    } catch (e) {
      debugPrint('Error signing out: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to log out. Please try again.',
              style: GoogleFonts.openSans(),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  static Widget buildProgressIndicator({
    required int currentStep,
    required int totalSteps,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Step $currentStep of $totalSteps',
              style: GoogleFonts.openSans(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryColorDark,
              ),
            ),
            Text(
              '${((currentStep / totalSteps) * 100).toInt()}%',
              style: GoogleFonts.openSans(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryColorDark,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: currentStep / totalSteps,
            backgroundColor: Colors.grey.shade200,
            valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
            minHeight: 8,
          ),
        ),
      ],
    );
  }

  static Widget buildBackButton(BuildContext context, {VoidCallback? onPressed}) {
    // Limit text scale factor to prevent overflow in buttons
    final textScaleFactor = MediaQuery.of(context).textScaleFactor.clamp(1.0, 1.2);
    
    return Container(
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: const Color(0xFFE6DDF3),
        border: Border.all(
          color: AppTheme.primaryColor,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed ?? () => Navigator.of(context).pop(),
          borderRadius: BorderRadius.circular(30),
          splashColor: AppTheme.primaryColor.withValues(alpha: 0.1),
          highlightColor: AppTheme.primaryColor.withValues(alpha: 0.05),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaleFactor: textScaleFactor,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.arrow_back,
                    color: AppTheme.primaryColorDark,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      'Back',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.openSans(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColorDark,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  static AppBar buildAppBar(BuildContext context, String title) {
    return AppBar(
      leading: Builder(
        builder: (context) => Center(
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black87),
            onPressed: () => Navigator.of(context).pop(),
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            constraints: const BoxConstraints(),
          ),
        ),
      ),
      title: Text(
        title,
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
      actions: [
        IconButton(
          icon: const Icon(Icons.logout, color: Colors.red),
          onPressed: () => handleLogout(context),
          tooltip: 'Log out',
        ),
      ],
    );
  }

  static Widget buildLogoutButton(BuildContext context) {
    // Limit text scale factor to prevent overflow in buttons
    final textScaleFactor = MediaQuery.of(context).textScaleFactor.clamp(1.0, 1.2);
    
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaleFactor: textScaleFactor,
      ),
      child: OutlinedButton.icon(
        onPressed: () => handleLogout(context),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.red, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          minimumSize: const Size(double.infinity, 56),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
        icon: const Icon(
          Icons.logout,
          color: Colors.red,
          size: 22,
        ),
        label: Text(
          'Log Out',
          style: GoogleFonts.openSans(
            color: Colors.red,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
