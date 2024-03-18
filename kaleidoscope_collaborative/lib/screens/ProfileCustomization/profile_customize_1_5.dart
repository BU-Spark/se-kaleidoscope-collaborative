import 'package:flutter/material.dart';
import 'package:kaleidoscope_collaborative/screens/ProfileCustomization/customization.dart';
import 'package:kaleidoscope_collaborative/screens/ProfileCustomization/profile_customize_1_6.dart';

class CustomizeProfilePage_1_5 extends StatefulWidget {
  final ProfileData profileData;

  CustomizeProfilePage_1_5({Key? key, required this.profileData})
      : super(key: key);

  @override
  _CustomizeProfilePage_1_5State createState() =>
      _CustomizeProfilePage_1_5State();
}

class _CustomizeProfilePage_1_5State extends State<CustomizeProfilePage_1_5> {
  Map<String, bool> locationPreference = {
    'Banks': false,
    'Concerts': false,
    'Gas Station': false,
    'Grocery Store': false,
    'Gym': false,
    'Library': false,
    'Mall': false,
    'Movie Theater': false,
    'Restaurants': false,
    'Sporting Events': false,
    'Other': false,
  };

  void _onLocationPreferenceChanged(String key, bool value) {
    setState(() {
      locationPreference[key] = value;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                    'Where do you like to travel to?',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ..._buildLocationPreferenceCheckboxes(),
                const SizedBox(height: 40), // Space before buttons
                _buildActionButtons(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildLocationPreferenceCheckboxes() {
    Color checkboxBackgroundColor = Color.fromRGBO(250, 249, 253, 1);
    return locationPreference.keys.map((String key) {
      return Container(
        color: checkboxBackgroundColor,
        child: CheckboxListTile(
          title: Text(
            key,
            style: TextStyle(
              color: Color.fromRGBO(26, 27, 30, 1),
              fontSize: 16,
              letterSpacing: 0.5,
            ),
          ),
          value: locationPreference[key],
          onChanged: (bool? value) {
            if (value != null) {
              _onLocationPreferenceChanged(key, value);
            }
          },
        ),
      );
    }).toList();
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        OutlinedButton(
          onPressed: () => Navigator.pop(context),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Color(0xFF74777F), width: 1),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100)),
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
        ElevatedButton(
          onPressed: () {
            // Create a new list from the selected disabilities
            List<String> locationPreferences = locationPreference.entries
                .where((entry) => entry.value)
                .map((entry) => entry.key)
                .toList();

            // Replace the existing accommodations list with the new list of selected disabilities
            widget.profileData.location_preference = locationPreferences;

            // Navigate to the next page, passing the updated profileData
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    CustomizeProfilePage_1_6(profileData: widget.profileData),
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
}
