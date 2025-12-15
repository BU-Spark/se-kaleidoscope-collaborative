import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kaleidoscope_collaborative/config/app_theme.dart';
import 'package:kaleidoscope_collaborative/widgets/glassmorphic_button.dart';
import 'package:kaleidoscope_collaborative/widgets/profile_setup_widgets.dart';
import 'package:kaleidoscope_collaborative/models/profile.dart';
import 'package:kaleidoscope_collaborative/screens/HomeAndLanding/home_page.dart';
import 'package:kaleidoscope_collaborative/services/cloud_firestore_service.dart';
import 'package:kaleidoscope_collaborative/config/globals.dart' as globals;
import 'dart:typed_data';
import 'dart:convert';

class CustomizeProfilePage_1_7 extends StatelessWidget {
  final ProfileData profileData;

  const CustomizeProfilePage_1_7({Key? key, required this.profileData})
      : super(key: key);

  Uint8List decodeImage(String base64String) {
    return base64Decode(base64String);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: ProfileSetupWidgets.buildAppBar('Profile Setup'),
      body: SafeArea(
        child: Column(
          children: [
            // Progress Indicator
            Padding(
              padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 0),
              child: ProfileSetupWidgets.buildProgressIndicator(
                currentStep: 8,
                totalSteps: 8,
              ),
            ),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 16),

                    // Success Icon
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_circle,
                        size: 50,
                        color: Colors.green,
                      ),
                    ),

                    const SizedBox(height: 24),

                    Text(
                      'Congratulations!',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.openSans(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Your profile is all set up and ready to go!',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.openSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.black54,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Profile Summary Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.2)),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryColor.withValues(alpha: 0.08),
                            blurRadius: 20,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Your Profile',
                            style: GoogleFonts.openSans(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryColorDark,
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Profile Picture
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppTheme.primaryColor, width: 3),
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.primaryColor.withValues(alpha: 0.2),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(13),
                              child: profileData.uploaded_profile_picture_status == 1 &&
                                      profileData.uploaded_profile_picture != null
                                  ? Image.memory(
                                      decodeImage(profileData.uploaded_profile_picture!),
                                      fit: BoxFit.cover,
                                    )
                                  : profileData.profile_picture_path.isNotEmpty
                                      ? Image.asset(
                                          profileData.profile_picture_path,
                                          fit: BoxFit.cover,
                                        )
                                      : Container(
                                          color: Colors.grey.shade200,
                                          child: const Icon(Icons.person, size: 50),
                                        ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Profile Details
                          _buildInfoSection(
                            'Relationship',
                            profileData.relationship.isNotEmpty
                                ? profileData.relationship
                                : 'Not specified',
                          ),
                          const SizedBox(height: 16),

                          _buildInfoSection(
                            'Disability/Support category best matching your needs',
                            profileData.disability_familiarity.isNotEmpty
                                ? profileData.disability_familiarity.join(', ')
                                : 'No disabilities selected',
                          ),
                          const SizedBox(height: 16),

                          _buildInfoSection(
                            'Accommodations',
                            profileData.accommodations.isNotEmpty
                                ? profileData.accommodations.join(', ')
                                : 'None selected',
                          ),
                          const SizedBox(height: 16),

                          _buildInfoSection(
                            'Frequently visits',
                            profileData.location_preference.isNotEmpty
                                ? profileData.location_preference.join(', ')
                                : 'No preferences set',
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // Action Buttons
            Padding(
              padding: const EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 24.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: ProfileSetupWidgets.buildBackButton(context),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: GlassmorphicButton(
                          text: 'Finish',
                          onPressed: () async {
                        // Get current user from Firebase Auth
                        final currentUser = FirebaseAuth.instance.currentUser;

                        if (currentUser == null || currentUser.email == null) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Please log in first to save your profile.',
                                  style: GoogleFonts.openSans(),
                                ),
                                backgroundColor: Colors.orange,
                                duration: const Duration(seconds: 3),
                              ),
                            );
                          }
                          return;
                        }

                        // Update the global userEmail for other parts of the app
                        globals.userEmail = currentUser.email!;

                        Map<String, dynamic> profileDataMap = profileData.toMap();

                        try {
                          await CloudFirestoreService(FirebaseFirestore.instance)
                              .addOrUpdateProfileData(profileDataMap);

                          if (context.mounted) {
                            // Show success message
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Profile saved successfully!',
                                  style: GoogleFonts.openSans(),
                                ),
                                backgroundColor: Colors.green,
                                duration: const Duration(seconds: 2),
                              ),
                            );

                            // Navigate to home
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const DashboardScreen()),
                              (Route<dynamic> route) => false,
                            );
                          }
                        } catch (e) {
                          debugPrint('Error saving profile: $e');
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Error: ${e.toString()}',
                                  style: GoogleFonts.openSans(),
                                ),
                                backgroundColor: Colors.red,
                                duration: const Duration(seconds: 4),
                              ),
                            );
                          }
                        }
                      },
                    ),
                  ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ProfileSetupWidgets.buildLogoutButton(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.openSans(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryColorDark,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Text(
            content,
            style: GoogleFonts.openSans(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.black87,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
