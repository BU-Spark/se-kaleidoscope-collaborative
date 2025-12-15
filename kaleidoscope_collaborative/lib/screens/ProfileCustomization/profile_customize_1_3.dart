import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaleidoscope_collaborative/config/app_theme.dart';
import 'package:kaleidoscope_collaborative/widgets/glassmorphic_button.dart';
import 'package:kaleidoscope_collaborative/widgets/profile_setup_widgets.dart';
import 'package:kaleidoscope_collaborative/models/profile.dart';
import 'package:kaleidoscope_collaborative/screens/ProfileCustomization/profile_customize_1_4.dart';

class CustomizeProfilePage_1_3 extends StatefulWidget {
  final ProfileData profileData;

  const CustomizeProfilePage_1_3({Key? key, required this.profileData})
      : super(key: key);

  @override
  _CustomizeProfilePage_1_3State createState() =>
      _CustomizeProfilePage_1_3State();
}

class _CustomizeProfilePage_1_3State extends State<CustomizeProfilePage_1_3> {
  Map<String, bool> disabilityFamiliarity = {
    'Autism Spectrum Disorder': false,
    'Deafness': false,
    'Hearing Impairment': false,
    'Visual Impairment or Blindness': false,
    'Deaf-Blindness': false,
    'Speech or Language Impairment': false,
    'Specific Learning Disability (SLD - dyslexia, dysgraphia, dyscalculia)':
        false,
    'Emotional Disturbance': false,
    'Orthopedic Impairment': false,
    'Traumatic Brain Injury': false,
    'Intellectual Disability': false,
    'Others': false,
  };

  final TextEditingController _othersController = TextEditingController();

  @override
  void dispose() {
    _othersController.dispose();
    super.dispose();
  }

  void _onDisabilityFamiliarityChanged(String key, bool value) {
    setState(() {
      disabilityFamiliarity[key] = value;
      // Clear the text field if "Others" is unchecked
      if (key == 'Others' && !value) {
        _othersController.clear();
      }
    });
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
                currentStep: 4,
                totalSteps: 8,
              ),
            ),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Text(
                      'Disability Awareness',
                      style: GoogleFonts.openSans(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Which disabilities will you need accomodation for? (Select all that apply)',
                      style: GoogleFonts.openSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: Colors.black54,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ...disabilityFamiliarity.keys.map((String key) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Column(
                          children: [
                            _buildCheckboxTile(key, disabilityFamiliarity[key]!),
                            // Show text field if "Others" is selected
                            if (key == 'Others' && disabilityFamiliarity[key]!)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: _buildOthersTextField(),
                              ),
                          ],
                        ),
                      );
                    }).toList(),
                    const SizedBox(height: 16),
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
                          text: 'Next',
                          onPressed: () {
                            // Validate "Others" field if selected
                            if (disabilityFamiliarity['Others'] == true && 
                                _othersController.text.trim().isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Please specify the disability in the "Others" field',
                                    style: GoogleFonts.openSans(),
                                  ),
                                  backgroundColor: Colors.orange,
                                ),
                              );
                              return;
                            }

                            List<String> selectedDisabilities = disabilityFamiliarity.entries
                                .where((entry) => entry.value)
                                .map((entry) {
                                  // Replace "Others" with the actual text input
                                  if (entry.key == 'Others') {
                                    return _othersController.text.trim();
                                  }
                                  return entry.key;
                                })
                                .toList();

                            widget.profileData.disability_familiarity = selectedDisabilities;

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CustomizeProfilePage_1_4(profileData: widget.profileData),
                              ),
                            );
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

  Widget _buildCheckboxTile(String title, bool value) {
    return Container(
      decoration: BoxDecoration(
        color: value ? AppTheme.primaryColor.withValues(alpha: 0.1) : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: value ? AppTheme.primaryColor : Colors.grey.shade300,
          width: value ? 2 : 1,
        ),
      ),
      child: CheckboxListTile(
        title: Text(
          title,
          style: GoogleFonts.openSans(
            fontSize: 15,
            fontWeight: value ? FontWeight.w600 : FontWeight.w400,
            color: value ? AppTheme.primaryColorDark : Colors.black87,
          ),
        ),
        value: value,
        activeColor: AppTheme.primaryColor,
        checkColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        onChanged: (bool? newValue) {
          if (newValue != null) {
            _onDisabilityFamiliarityChanged(title, newValue);
          }
        },
      ),
    );
  }

  Widget _buildOthersTextField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.primaryColor.withValues(alpha: 0.5),
          width: 1.5,
        ),
      ),
      child: TextField(
        controller: _othersController,
        style: GoogleFonts.openSans(fontSize: 15),
        decoration: InputDecoration(
          hintText: 'Please specify the disability...',
          hintStyle: GoogleFonts.openSans(
            fontSize: 14,
            color: Colors.grey.shade500,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          suffixIcon: _othersController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear, color: Colors.grey.shade600),
                  onPressed: () {
                    setState(() {
                      _othersController.clear();
                    });
                  },
                )
              : null,
        ),
        onChanged: (value) {
          setState(() {}); // Update UI to show/hide clear button
        },
      ),
    );
  }
}
