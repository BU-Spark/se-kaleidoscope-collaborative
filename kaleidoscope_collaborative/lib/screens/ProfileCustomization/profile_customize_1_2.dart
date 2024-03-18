import 'package:flutter/material.dart';
import 'package:kaleidoscope_collaborative/screens/ProfileCustomization/customization.dart';
//this is passed data structure from

class CustomizeProfilePage_1_2 extends StatelessWidget {
  final ProfileData profileData;

  CustomizeProfilePage_1_2({Key? key, required this.profileData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use profileData here to display the data or further processing
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Summary'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Name: ${profileData.name}'),
            Text('Age: ${profileData.age}'),
            Text('Gender: ${profileData.gender}'),
            Text('Occupation: ${profileData.occupation}'),
            // Add more widgets to display the data as needed
          ],
        ),
      ),
    );
  }
}
