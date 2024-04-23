import 'package:flutter/material.dart';
import 'package:kaleidoscope_collaborative/models/profile.dart';
import 'package:kaleidoscope_collaborative/screens/ProfileCustomization/profile_customize_1_7.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';
import 'package:image/image.dart' as img;

//import 'package:kaleidoscope_collaborative/screens/ProfileCustomization/profile_customize_1_5.dart';
class ProfilePicture {
  final String imagePath;
  final int index;

  ProfilePicture({required this.imagePath, required this.index});
}

class CustomizeProfilePage_1_6 extends StatefulWidget {
  final ProfileData profileData;

  CustomizeProfilePage_1_6({Key? key, required this.profileData})
      : super(key: key);

  @override
  _CustomizeProfilePage_1_6State createState() =>
      _CustomizeProfilePage_1_6State();
}

class _CustomizeProfilePage_1_6State extends State<CustomizeProfilePage_1_6> {
  String? selectedProfileImagePath;
  String? selectedImagePath;
  bool isImageUploaded = false;

  Future<String> resizeAndCompressImage(String imagePath) async {
    // Load the image file
    img.Image? originalImage =
        img.decodeImage(await File(imagePath).readAsBytes());

    img.Image resizedImage =
        img.copyResize(originalImage!, width: 500, height: 500);

    // Compress the image as a JPEG
    List<int> jpeg = img.encodeJpg(resizedImage,
        quality: 85); // Adjust quality for further size optimization

    // Convert the image to a base64 string
    String base64Image = base64Encode(jpeg);

    return base64Image;
  }

  Future<String> encodeImageToBase64(String imagePath) async {
    File imageFile = File(imagePath);
    List<int> imageBytes = await imageFile.readAsBytes();
    return base64Encode(imageBytes);
  }

  @override
  Widget build(BuildContext context) {
    final List<String> paths = [
      'images/defaultProfilePictures/default_image_1.png',
      'images/defaultProfilePictures/default_image_2.png',
      'images/defaultProfilePictures/default_image_3.png',
      'images/defaultProfilePictures/default_image_4.png',
      'images/defaultProfilePictures/default_image_5.png',
      'images/defaultProfilePictures/default_image_6.png',
    ];
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double spacerHeight = height / 21;
    double halfSpacerHeight = height / 42;
    double textfieldHeight = height / 104;
    double container = width / 1.9;
    double padding = width / 24;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: spacerHeight),
                const Text(
                  'Customize Profile',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                    fontSize: 32,
                    color: Colors.black,
                    letterSpacing: 0.1,
                  ),
                ),
                SizedBox(height: halfSpacerHeight),
                const Text(
                  "Tell us a bit about yourself!",
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    letterSpacing: 0.5,
                    color: Colors.black,
                  ),
                  softWrap: true,
                ),
                const SizedBox(height: 20),
                Container(
                  width: container,
                  child: const Text(
                    'Choose a Profile Picture!!!',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: Colors.black,
                      letterSpacing: 0.15,
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    height: 259,
                    width: 300,
                    child: _buildProfileImagesGrid(context, paths),
                  ),
                ),
                SizedBox(height: halfSpacerHeight),
                Container(
                  width: container,
                  child: const Text(
                    'Or Upload Your Own!',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: Colors.black,
                      letterSpacing: 0.15,
                    ),
                  ),
                ),
                SizedBox(height: halfSpacerHeight),
                _buildUploadContainer(context),
                SizedBox(height: spacerHeight),
                _buildActionButtons(context, paths),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUploadContainer(BuildContext context) {
    return Center(
      child: Container(
        width: 300.0,
        height: 222.0,
        decoration: BoxDecoration(
          color: Color.fromRGBO(103, 80, 164, 0.11),
          borderRadius: BorderRadius.circular(28.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Icon(
              Icons.mobile_friendly,
              size: 30.0,
              color: Color.fromRGBO(103, 80, 164, 1),
            ),
            Text(
              isImageUploaded ? 'Successfully Uploaded' : 'Upload Image',
              style: TextStyle(
                color: Color.fromRGBO(103, 80, 164, 1),
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              width: 234,
              child: Text(
                'This image will appear to other Ditto users when you review locations!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromRGBO(67, 71, 78, 1),
                  fontSize: 13,
                  letterSpacing: 0.25,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final ImagePicker _picker = ImagePicker();
                final XFile? image =
                    await _picker.pickImage(source: ImageSource.gallery);
                if (image != null) {
                  setState(() {
                    selectedProfileImagePath = image.path;
                    isImageUploaded = true;
                  });
                }
                if (image != null) {
                  // Encode the image to base64
                  String base64Image = await resizeAndCompressImage(image.path);
                  // Update the instance with the encoded image
                  setState(() {
                    widget.profileData.uploaded_profile_picture = base64Image;
                    //widget.profileData.profile_picture_path = image.path;
                    widget.profileData.uploaded_profile_picture_status = 1;
                    isImageUploaded = true;
                  });
                }
              },
              child: Text('Upload Image'),
              style: ElevatedButton.styleFrom(
                primary: Color.fromRGBO(103, 80, 164, 1),
                onPrimary: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, paths) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double spacerHeight = height / 21;
    double halfSpacerHeight = height / 42;
    double textfieldHeight = height / 104;
    double container = width / 1.9;
    double padding = width / 24;
    return ButtonBar(
      buttonPadding: EdgeInsets.zero,
      alignment: MainAxisAlignment.end,
      children: [
        OutlinedButton(
          onPressed: () => Navigator.pop(context),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Color(0xFF74777F), width: 1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
            minimumSize: const Size(84, 40),
          ),
          child: const Text(
            'back',
            style: TextStyle(
              color: Color(0xFF275EA7),
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w500,
              fontSize: 14,
              letterSpacing: 0.1,
            ),
          ),
        ),
        SizedBox(width: padding),
        ElevatedButton(
          onPressed: () {
            // Check if selectedImagePath is null or empty; if so, use the first image path as default
            if (selectedImagePath == null || selectedImagePath!.isEmpty) {
              selectedImagePath = paths[0];
            }

            // Assign the selected or default image path to profileData
            widget.profileData.profile_picture_path = selectedImagePath!;

            // Navigate to the next page, passing the updated profileData
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    CustomizeProfilePage_1_7(profileData: widget.profileData),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            primary: Color(0xFF275EA7),
            onPrimary: Colors.white,
            elevation: 0,
            shape: StadiumBorder(),
            minimumSize: const Size(84, 40),
          ),
          child: const Text(
            'next',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w500,
              fontSize: 14,
              letterSpacing: 0.1,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileImagesGrid(BuildContext context, List<String> paths) {
    // This method will build the grid of profile images
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1,
      ),
      itemCount: paths.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedImagePath = paths[index]; // Set the selected image index
            });
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: selectedImagePath == paths[index]
                    ? Colors.blue
                    : Colors.transparent, // Highlight selected image
                width: 3,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Image.asset(paths[index]), // Display the image
          ),
        );
      },
    );
  }
}
