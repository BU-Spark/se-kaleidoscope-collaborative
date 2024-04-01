import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kaleidoscope_collaborative/screens/ProfileCustomization/customization.dart';
import 'package:kaleidoscope_collaborative/screens/HomeAndLanding/home_page.dart';
import 'package:kaleidoscope_collaborative/screens/cloud_firestore_service.dart';
import 'dart:typed_data';
import 'dart:convert';

// Make sure this import statement reflects the actual path to your customization.dart file

class CustomizeProfilePage_1_7 extends StatelessWidget {
  final ProfileData profileData;

  const CustomizeProfilePage_1_7({Key? key, required this.profileData})
      : super(key: key);
  //THIS METHOD IS USED TO DECODE THE ENCODE IMAGE
  Uint8List decodeImage(String base64String) {
    return base64Decode(base64String);
  }

  @override
  Widget build(BuildContext context) {
    final CloudFirestoreService service =
        CloudFirestoreService(FirebaseFirestore.instance);
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment
                  .start, // Align text to the start (left side)
              children: <Widget>[
                const SizedBox(height: 80),
                const Text(
                  'CONGRATULATIONS!',
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
                  "Good job finishing your profile",
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: Colors.black,
                    letterSpacing: 0.15,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Your Profile So Far:",
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: Colors.black,
                    letterSpacing: 0.15,
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Container(
                    width: 100, // Set the width as needed
                    height: 100, // Set the height as needed
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                          5), // Adjust the radius as needed
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                          5), // Match the outer Container's borderRadius
                      child: profileData.uploaded_profile_picture_status == 1 &&
                              profileData.uploaded_profile_picture != null
                          ? Image.memory(
                              decodeImage(
                                  profileData.uploaded_profile_picture!),
                              fit: BoxFit.cover,
                            )
                          : profileData.profile_picture_path.isNotEmpty
                              ? Image.asset(
                                  profileData.profile_picture_path,
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  color: Colors.grey, // Placeholder color
                                  child: Icon(Icons.person,
                                      size: 50), // Placeholder icon
                                ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _displayText("Relationship:", 12.0, FontWeight.bold),
                const SizedBox(height: 7),
                profileData.relationship != ""
                    ? _displayText(
                        '${profileData.relationship}', 11.0, FontWeight.w400)
                    : _displayText('None', 11.0, FontWeight.w400),
                const SizedBox(height: 7),
                _displayText(
                    "Familiar with these disabilities:", 12.0, FontWeight.bold),
                const SizedBox(height: 7),
                profileData.disability_familiarity.isNotEmpty
                    ? _displayText(
                        '${profileData.disability_familiarity.join(', ')}',
                        11.0,
                        FontWeight.w400)
                    : _displayText('None', 11.0, FontWeight.w400),
                const SizedBox(height: 7),
                _displayText("Accommodations:", 12.0, FontWeight.bold),
                const SizedBox(height: 7),
                profileData.accommodations.isNotEmpty
                    ? _displayText('${profileData.accommodations.join(', ')}',
                        11.0, FontWeight.w400)
                    : _displayText('None', 11.0, FontWeight.w400),
                const SizedBox(height: 7),
                _displayText(
                    "Frequently Visited Locations:", 12.0, FontWeight.bold),
                const SizedBox(height: 7),
                profileData.location_preference.isNotEmpty
                    ? _displayText(
                        '${profileData.location_preference.join(', ')}',
                        11.0,
                        FontWeight.w400)
                    : _displayText('None', 11.0, FontWeight.w400),
                const SizedBox(height: 20),
                _buildActionButtons(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _displayText(text, size, fw) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'Roboto',
        fontWeight: fw,
        fontSize: size,
        color: Colors.black,
        letterSpacing: 0.5,
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
          onPressed: () async {
            // Convert profileData to Map
            Map<String, dynamic> profileDataMap = profileData.toMap();
            print("Attempting to add profile data: $profileDataMap");

            // Use CloudFirestoreService to add or update the profile data in Firestore
            try {
              String documentId =
                  await CloudFirestoreService(FirebaseFirestore.instance)
                      .addProfileData(
                          profileDataMap); // Adjust method name as necessary
              print(
                  "Profile Data added or updated with document ID: $documentId");

              // Navigate to the DashboardScreen or home screen after successful submission
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        DashboardScreen()), // Ensure DashboardScreen is defined
                (Route<dynamic> route) => false,
              );
            } catch (e) {
              // Handle errors here, possibly show an error message to the user
              print(
                  e); // Consider using a more user-friendly way to handle errors
            }
          },
          style: ElevatedButton.styleFrom(
            primary: Color(0xFF275EA7),
            onPrimary: Colors.white,
            elevation: 0,
            shape: StadiumBorder(),
            minimumSize: const Size(84, 40),
          ),
          child: const Text(
            'home',
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
