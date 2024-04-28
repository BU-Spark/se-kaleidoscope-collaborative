import 'package:flutter/material.dart';
import 'package:kaleidoscope_collaborative/models/profile.dart';
import 'package:kaleidoscope_collaborative/screens/ProfileCustomization/profile_customize_1_5.dart';

class CustomizeProfilePage_1_4 extends StatefulWidget {
  final ProfileData profileData;

  const CustomizeProfilePage_1_4({Key? key, required this.profileData})
      : super(key: key);

  @override
  _CustomizeProfilePage_1_4State createState() =>
      _CustomizeProfilePage_1_4State();
}

class _CustomizeProfilePage_1_4State extends State<CustomizeProfilePage_1_4> {
  Map<String, bool> acommadation = {
    'Accessible Parking': false,
    'Elevator': false,
    'Braile': false,
    'Automated Doors': false,
    'Accessible Washroom': false,
    'Bright Lighting': false,
    'Customer Service': false,
    'Digital Menu': false,
    'Gender Neutral Washroom': false,
    'Alternative Entrance': false,
    'Other': false,
  };

  void _onAcommadationChanged(String key, bool value) {
    setState(() {
      acommadation[key] = value;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                SizedBox(height: halfSpacerHeight),
                SizedBox(
                  width: container,
                  child: const Text(
                    'Which accommodations do you frequently interact with?',
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
                ..._buildAcommadationCheckboxes(),
                SizedBox(height: spacerHeight),
                _buildActionButtons(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildAcommadationCheckboxes() {
    Color checkboxBackgroundColor = const Color.fromRGBO(250, 249, 253, 1);
    return acommadation.keys.map((String key) {
      return Container(
        color: checkboxBackgroundColor,
        child: CheckboxListTile(
          title: Text(
            key,
            style: const TextStyle(
              color: Color.fromRGBO(26, 27, 30, 1),
              fontSize: 16,
              letterSpacing: 0.5,
            ),
          ),
          value: acommadation[key],
          onChanged: (bool? value) {
            if (value != null) {
              _onAcommadationChanged(key, value);
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
            List<String> acommadations = acommadation.entries
                .where((entry) => entry.value)
                .map((entry) => entry.key)
                .toList();

            // Replace the existing accommodations list with the new list of selected disabilities
            widget.profileData.accommodations = acommadations;

            // Navigate to the next page, passing the updated profileData
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    CustomizeProfilePage_1_5(profileData: widget.profileData),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white, backgroundColor: const Color(0xFF275EA7),
            elevation: 0,
            shape: const StadiumBorder(),
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
