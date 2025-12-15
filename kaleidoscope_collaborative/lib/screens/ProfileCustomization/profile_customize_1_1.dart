import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaleidoscope_collaborative/config/app_theme.dart';
import 'package:kaleidoscope_collaborative/widgets/glassmorphic_button.dart';
import 'package:kaleidoscope_collaborative/widgets/profile_setup_widgets.dart';
import 'package:kaleidoscope_collaborative/screens/ProfileCustomization/profile_customize_1_2.dart';
import 'package:kaleidoscope_collaborative/models/profile.dart';

class CustomizeProfilePage_1_1 extends StatefulWidget {
  const CustomizeProfilePage_1_1({super.key});

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
                              final profileData = ProfileData(
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.arrow_back,
                  color: AppTheme.primaryColorDark,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Back',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.openSans(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColorDark,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
