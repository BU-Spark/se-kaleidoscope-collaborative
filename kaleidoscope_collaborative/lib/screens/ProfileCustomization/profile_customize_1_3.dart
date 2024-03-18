import 'package:flutter/material.dart';
import 'package:kaleidoscope_collaborative/screens/ProfileCustomization/customization.dart';

class CustomizeProfilePage_1_3 extends StatelessWidget {
  final ProfileData profileData;

  const CustomizeProfilePage_1_3({Key? key, required this.profileData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use profileData to display or process data as needed
    return Scaffold(
      appBar: AppBar(title: Text("Profile Summary")),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Name: ${profileData.name}"),
          Text("Age: ${profileData.age}"),
          Text("Gender: ${profileData.gender}"),
          Text("Occupation: ${profileData.occupation}"),
          Text("Relationship: ${profileData.relationship}"),
          // Add more widgets as needed to display the data
        ],
      ),
    );
  }
}
