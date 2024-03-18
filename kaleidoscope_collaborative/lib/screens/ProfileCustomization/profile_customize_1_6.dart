import 'package:flutter/material.dart';
import 'package:kaleidoscope_collaborative/screens/ProfileCustomization/customization.dart';
import 'package:kaleidoscope_collaborative/screens/ProfileCustomization/Visualize.dart';
//import 'package:kaleidoscope_collaborative/screens/ProfileCustomization/profile_customize_1_5.dart';

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

  @override
  Widget build(BuildContext context) {
    String path =
        "/Users/jiasonghuang/Desktop/se-kaleidoscope-collaborative/kaleidoscope_collaborative/lib/screens/ProfileCustomization/";
    //CHANGE TO PATH IN SERVER
    List<String> profileImages = [
      path + 'default_image_1.png',
      path + 'default_image_2.png',
      path + 'default_image_3.png',
      path + 'default_image_4.png',
      path + 'default_image_5.png',
      path + 'default_image_6.png',
    ];

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 40),
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
                const SizedBox(height: 20),

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
                  width: 232,
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
                const SizedBox(height: 20),
                Container(
                  height: 193,
                  width: 259,
                ),
                Container(
                  width: 232,
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
                const SizedBox(height: 20),
                _buildUploadContainer(context),
                const SizedBox(height: 40), // Space before buttons
                _buildActionButtons(context),
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
        width: 300.0, // Fixed width
        height: 222.0, // Fixed height
        decoration: BoxDecoration(
          color: Color.fromRGBO(103, 80, 164, 0.11), // Background color
          borderRadius: BorderRadius.circular(28.0), // Radius
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Icon(
              Icons.mobile_friendly, // Replace with your desired icon
              size: 30.0, // Icon size
              color: Color.fromRGBO(103, 80, 164, 1), // Icon color
            ),
            Text(
              'Upload Image',
              style: TextStyle(
                color: Color.fromRGBO(103, 80, 164, 1), // Text color
                fontSize: 18.0, // Font size
                fontWeight: FontWeight.bold, // Font weight
              ),
            ),
            Container(
              width: 234,
              child: Text(
                'This image will appear to other Ditto users when you review locations!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromRGBO(67, 71, 78, 1), // Text color
                  fontSize: 13, // Font size
                  letterSpacing: 0.25,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Handle the image upload logic
              },
              child: Text('Upload Image'),
              style: ElevatedButton.styleFrom(
                primary: Color.fromRGBO(103, 80, 164, 1), // Button color
                onPrimary: Colors.white, // Text color
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return ButtonBar(
      buttonPadding:
          EdgeInsets.zero, // Removes padding between the buttons if necessary
      alignment:
          MainAxisAlignment.end, // Aligns the button bar to the end of the row
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
        SizedBox(width: 16),
        ElevatedButton(
          onPressed: () {
            // Implementation of next button logic
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
}
