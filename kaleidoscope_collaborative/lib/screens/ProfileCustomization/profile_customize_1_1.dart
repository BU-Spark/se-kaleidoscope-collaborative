import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaleidoscope_collaborative/config/app_theme.dart';
import 'package:kaleidoscope_collaborative/widgets/glassmorphic_button.dart';
import 'package:kaleidoscope_collaborative/widgets/profile_setup_widgets.dart';
import 'package:kaleidoscope_collaborative/screens/ProfileCustomization/profile_customize_1_2.dart';
import 'package:kaleidoscope_collaborative/models/profile.dart';

class CustomizeProfilePage_1_1 extends StatefulWidget {
  final ProfileData? existingProfileData;
  
  const CustomizeProfilePage_1_1({super.key, this.existingProfileData});

  @override
  _CustomizeProfilePage_1_1State createState() =>
      _CustomizeProfilePage_1_1State();
}

class _CustomizeProfilePage_1_1State extends State<CustomizeProfilePage_1_1> {
  final _ageController = TextEditingController();
  final _nameController = TextEditingController();
  final _occupationController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? selectedGender;

  @override
  void initState() {
    super.initState();
    // Pre-fill with existing data if available
    if (widget.existingProfileData != null) {
      _nameController.text = widget.existingProfileData!.name;
      _ageController.text = widget.existingProfileData!.age.toString();
      selectedGender = widget.existingProfileData!.gender;
      _occupationController.text = widget.existingProfileData!.occupation;
    }
  }

  @override
  void dispose() {
    _ageController.dispose();
    _nameController.dispose();
    _occupationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        leading: Center(
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black87),
            onPressed: () => Navigator.of(context).pop(),
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            constraints: const BoxConstraints(),
          ),
        ),
        title: Text(
          'Profile Setup',
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
            // Progress Indicator - Fixed at top
            Padding(
              padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 0),
              child: _buildProgressIndicator(currentStep: 2, totalSteps: 8),
            ),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Text(
                        'Tell us about yourself',
                        style: GoogleFonts.openSans(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Help us personalize your experience',
                        style: GoogleFonts.openSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Colors.black54,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 32),
                      _buildTextField('Name', _nameController, TextInputType.text),
                      const SizedBox(height: 16),
                      _buildTextField('Age', _ageController, TextInputType.number),
                      const SizedBox(height: 16),
                      _buildGenderDropdown(),
                      const SizedBox(height: 16),
                      _buildTextField('Occupation', _occupationController, TextInputType.text),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),

            // Action Buttons - Fixed at bottom
            Padding(
              padding: const EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 24.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildBackButton(context),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: GlassmorphicButton(
                          text: 'Next',
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              if (selectedGender == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Please select your gender',
                                      style: GoogleFonts.openSans(),
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              }
                              // Use existing profile data if available, otherwise create new
                              final profileData = widget.existingProfileData != null
                                  ? ProfileData(
                                      name: _nameController.text,
                                      age: int.parse(_ageController.text),
                                      gender: selectedGender ?? 'Not specified',
                                      occupation: _occupationController.text,
                                      relationship: widget.existingProfileData!.relationship,
                                      disability_familiarity: widget.existingProfileData!.disability_familiarity,
                                      accommodations: widget.existingProfileData!.accommodations,
                                      location_preference: widget.existingProfileData!.location_preference,
                                      profile_picture_path: widget.existingProfileData!.profile_picture_path,
                                      uploaded_profile_picture_status: widget.existingProfileData!.uploaded_profile_picture_status,
                                      uploaded_profile_picture: widget.existingProfileData!.uploaded_profile_picture,
                                    )
                                  : ProfileData(
                                      name: _nameController.text,
                                      age: int.parse(_ageController.text),
                                      gender: selectedGender ?? 'Not specified',
                                      occupation: _occupationController.text,
                                    );
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      CustomizeProfilePage_1_2(profileData: profileData),
                                ),
                              );
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

  Widget _buildProgressIndicator({required int currentStep, required int totalSteps}) {
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

  Widget _buildTextField(String label, TextEditingController controller, TextInputType keyboardType) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: GoogleFonts.openSans(fontSize: 16),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.openSans(
          fontSize: 16,
          color: Colors.black54,
        ),
        floatingLabelStyle: GoogleFonts.openSans(
          fontSize: 16,
          color: AppTheme.primaryColor,
          fontWeight: FontWeight.w600,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        suffixIcon: controller.text.isNotEmpty
            ? IconButton(
                icon: Icon(Icons.clear, color: Colors.grey.shade600),
                onPressed: () {
                  setState(() {
                    controller.clear();
                  });
                },
              )
            : null,
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter $label';
        }
        if (label == 'Age') {
          final age = int.tryParse(value);
          if (age == null || age <= 0) {
            return 'Please enter a valid age';
          }
        }
        return null;
      },
      onChanged: (value) {
        setState(() {}); // Update UI to show/hide clear button
      },
    );
  }

  Widget _buildGenderDropdown() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'Gender',
        labelStyle: GoogleFonts.openSans(
          fontSize: 16,
          color: Colors.black54,
        ),
        floatingLabelStyle: GoogleFonts.openSans(
          fontSize: 16,
          color: AppTheme.primaryColor,
          fontWeight: FontWeight.w600,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.primaryColor, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      value: selectedGender,
      style: GoogleFonts.openSans(fontSize: 16, color: Colors.black87),
      onChanged: (String? newValue) {
        setState(() {
          selectedGender = newValue;
        });
      },
      items: <String>['Male', 'Female', 'Non-Binary', 'Other', 'Prefer not to say']
          .map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget _buildBackButton(BuildContext context) {
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
          onTap: () => Navigator.of(context).pop(),
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
}
