import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kaleidoscope_collaborative/config/app_theme.dart';
import 'package:kaleidoscope_collaborative/widgets/glassmorphic_button.dart';
import 'package:kaleidoscope_collaborative/models/profile.dart';
import 'package:kaleidoscope_collaborative/screens/HomeAndLanding/home_page.dart';
import 'package:kaleidoscope_collaborative/screens/ProfileCustomization/profile_customize_1_0.dart';
import 'package:kaleidoscope_collaborative/config/globals.dart' as globals;
import 'dart:typed_data';
import 'dart:convert';

class finished_customization_page extends StatelessWidget {
  final ProfileData profileData;

  const finished_customization_page({Key? key, required this.profileData})
      : super(key: key);

  Uint8List decodeImage(String base64String) {
    return base64Decode(base64String);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        leading: Center(
          child: IconButton(
            icon: const Icon(Icons.close, color: Colors.black87),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const DashboardScreen()),
                (Route<dynamic> route) => false,
              );
            },
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            constraints: const BoxConstraints(),
          ),
        ),
        title: Text(
          'Profile Overview',
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
      body: SafeArea(
        child: Column(
          children: [
            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // const SizedBox(height: 16),

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

                    const SizedBox(height: 16),

                    Text(
                      'Profile Complete!',
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
                      'Your profile has been set up successfully',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.openSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.black54,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 16),

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
                            'Familiar with',
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

            // Action Buttons - Fixed at bottom
            Padding(
              padding: const EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 24.0),
              child: Column(
                children: [
                  // Edit Profile button
                  SizedBox(
                    width: double.infinity,
                    child: GlassmorphicButton(
                      text: 'Edit Profile',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CustomizeProfilePage(),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Logout button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        try {
                          globals.userEmail = '';
                          await FirebaseAuth.instance.signOut();
                          if (context.mounted) {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const DashboardScreen()),
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
                      },
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
                      ),
                    ),
                  ),
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
