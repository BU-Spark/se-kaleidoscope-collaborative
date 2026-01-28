import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaleidoscope_collaborative/config/app_theme.dart';
import 'package:kaleidoscope_collaborative/widgets/glassmorphic_button.dart';
import 'package:kaleidoscope_collaborative/widgets/profile_setup_widgets.dart';
import 'package:kaleidoscope_collaborative/models/profile.dart';
import 'package:kaleidoscope_collaborative/screens/ProfileCustomization/profile_customize_1_7.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';
import 'package:image/image.dart' as img;

class CustomizeProfilePage_1_6 extends StatefulWidget {
  final ProfileData profileData;

  const CustomizeProfilePage_1_6({Key? key, required this.profileData})
      : super(key: key);

  @override
  _CustomizeProfilePage_1_6State createState() =>
      _CustomizeProfilePage_1_6State();
}

class _CustomizeProfilePage_1_6State extends State<CustomizeProfilePage_1_6> {
  String? selectedProfileImagePath;
  String? selectedImagePath;
  bool isImageUploaded = false;

  @override
  void initState() {
    super.initState();
    // Pre-fill profile picture selection with existing data
    if (widget.profileData.uploaded_profile_picture_status == 1 &&
        widget.profileData.uploaded_profile_picture != null &&
        widget.profileData.uploaded_profile_picture!.isNotEmpty) {
      isImageUploaded = true;
      // Keep the existing base64 image in profileData
    } else if (widget.profileData.profile_picture_path.isNotEmpty) {
      selectedImagePath = widget.profileData.profile_picture_path;
    }
  }

  final List<String> defaultImagePaths = [
    'images/defaultProfilePictures/default_image_1.png',
    'images/defaultProfilePictures/default_image_2.png',
    'images/defaultProfilePictures/default_image_3.png',
    'images/defaultProfilePictures/default_image_4.png',
    'images/defaultProfilePictures/default_image_5.png',
    'images/defaultProfilePictures/default_image_6.png',
  ];

  Future<String> resizeAndCompressImage(String imagePath) async {
    img.Image? originalImage =
        img.decodeImage(await File(imagePath).readAsBytes());

    img.Image resizedImage =
        img.copyResize(originalImage!, width: 500, height: 500);

    List<int> jpeg = img.encodeJpg(resizedImage, quality: 85);
    String base64Image = base64Encode(jpeg);

    return base64Image;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: ProfileSetupWidgets.buildAppBar(context, 'Profile Setup'),
      body: SafeArea(
        child: Column(
          children: [
            // Progress Indicator
            Padding(
              padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 0),
              child: ProfileSetupWidgets.buildProgressIndicator(
                currentStep: 7,
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
                      'Profile Picture',
                      style: GoogleFonts.openSans(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Choose a profile picture from our defaults or upload your own',
                      style: GoogleFonts.openSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: Colors.black54,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Default Images Grid
                    Text(
                      'Choose from defaults',
                      style: GoogleFonts.openSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildProfileImagesGrid(),
                    const SizedBox(height: 32),

                    // Upload Section
                    Text(
                      'Or upload your own',
                      style: GoogleFonts.openSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildUploadContainer(),
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
                          text: 'Next',
                          onPressed: () {
                            if (selectedImagePath == null || selectedImagePath!.isEmpty) {
                              selectedImagePath = defaultImagePaths[0];
                            }
                            widget.profileData.profile_picture_path = selectedImagePath!;

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CustomizeProfilePage_1_7(profileData: widget.profileData),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImagesGrid() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1,
        ),
        itemCount: defaultImagePaths.length,
        itemBuilder: (context, index) {
          final isSelected = selectedImagePath == defaultImagePaths[index];
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedImagePath = defaultImagePaths[index];
                isImageUploaded = false;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: isSelected ? AppTheme.primaryColor : Colors.grey.shade300,
                  width: isSelected ? 3 : 2,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppTheme.primaryColor.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  defaultImagePaths[index],
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildUploadContainer() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isImageUploaded
              ? AppTheme.primaryColor
              : AppTheme.primaryColor.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          // Show uploaded image preview if available
          if (isImageUploaded && widget.profileData.uploaded_profile_picture != null)
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.primaryColor, width: 3),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(13),
                child: Image.memory(
                  base64Decode(widget.profileData.uploaded_profile_picture!),
                  fit: BoxFit.cover,
                ),
              ),
            )
          else
            Icon(
              isImageUploaded ? Icons.check_circle : Icons.cloud_upload,
              size: 48,
              color: isImageUploaded ? Colors.green : AppTheme.primaryColor,
            ),
          const SizedBox(height: 16),
          Text(
            isImageUploaded ? 'Image Uploaded Successfully!' : 'Upload Your Image',
            style: GoogleFonts.openSans(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isImageUploaded ? Colors.green : AppTheme.primaryColorDark,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'This image will appear to other users when you review locations',
            textAlign: TextAlign.center,
            style: GoogleFonts.openSans(
              fontSize: 14,
              color: Colors.black54,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () async {
                final ImagePicker picker = ImagePicker();
                final XFile? image =
                    await picker.pickImage(source: ImageSource.gallery);
                if (image != null) {
                  String base64Image = await resizeAndCompressImage(image.path);
                  setState(() {
                    selectedProfileImagePath = image.path;
                    widget.profileData.uploaded_profile_picture = base64Image;
                    widget.profileData.uploaded_profile_picture_status = 1;
                    isImageUploaded = true;
                    selectedImagePath = null;
                  });
                }
              },
              icon: const Icon(Icons.add_photo_alternate),
              label: Text(
                isImageUploaded ? 'Change Image' : 'Select Image',
                style: GoogleFonts.openSans(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
