import 'package:flutter/material.dart';
import 'package:kaleidoscope_collaborative/screens/ProfileCustomization/customization.dart';

// Make sure this import statement reflects the actual path to your customization.dart file

class Visualize extends StatelessWidget {
  final ProfileData profileData;

  const Visualize({Key? key, required this.profileData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Convert each field of ProfileData into a list of Text widgets
    List<Widget> profileInfo = [
      Text('Name: ${profileData.name}'),
      Text('Age: ${profileData.age}'),
      Text('Gender: ${profileData.gender}'),
      Text('Occupation: ${profileData.occupation}'),
      Text('Relationship: ${profileData.relationship}'),
      profileData.disability_familiarity.isNotEmpty
          ? Text(
              'Disabilities Familiarity: ${profileData.disability_familiarity.join(', ')}')
          : Text('Disabilities Familiarity: None'),
      profileData.accommodations.isNotEmpty
          ? Text('Accommodations: ${profileData.accommodations.join(', ')}')
          : Text('Accommodations: None'),
      profileData.location_preference.isNotEmpty
          ? Text(
              'Location Preference: ${profileData.location_preference.join(', ')}')
          : Text('Location Preference: None'),
      Text('Profile Picture Index: ${profileData.profile_picture_path}'),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Summary'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: profileInfo,
          ),
        ),
      ),
    );
  }
}
