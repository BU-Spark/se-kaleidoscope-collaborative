import 'package:flutter/material.dart';
import 'package:kaleidoscope_collaborative/screens/ProfileCustomization/profile_customize_1_2.dart';
import 'package:kaleidoscope_collaborative/screens/ProfileCustomization/customization.dart';

class CustomizeProfilePage_1_1 extends StatefulWidget {
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
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
                    height: 40 / 32,
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
                    height: 24 / 16,
                    letterSpacing: 0.5,
                    color: Colors.black,
                  ),
                  softWrap: true,
                ),
                const SizedBox(height: 20),
                _buildTextField(context, 'Name', _nameController),
                _buildAgeField(),
                _buildGenderDropdown(),
                _buildTextField(context, 'Occupation', _occupationController),
                const SizedBox(height: 40), // Increased space before buttons
                _buildActionButtons(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      BuildContext context, String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        width: 210, // Fixed width for the text field
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () => controller.clear(),
            ),
            border: const OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter $label';
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget _buildAgeField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        width: 210, // Fixed width for the age field
        child: TextFormField(
          controller: _ageController,
          decoration: InputDecoration(
            labelText: 'Age',
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () => _ageController.clear(),
            ),
            border: const OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null ||
                value.isEmpty ||
                int.tryParse(value) == null ||
                int.parse(value) <= 0) {
              return 'Please enter a valid age';
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget _buildGenderDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        width: 210, // Fixed width for the dropdown
        child: DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: 'Gender',
            border: OutlineInputBorder(),
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
          value: selectedGender,
          onChanged: (String? newValue) {
            setState(() {
              selectedGender = newValue;
            });
          },
          items: <String>['Male', 'Female', 'Non-Binary', 'Others']
              .map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
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
            if (_formKey.currentState!.validate()) {
              final profileData = ProfileData(
                name: _nameController.text,
                age: int.parse(_ageController.text),
                gender: selectedGender ??
                    'Not specified', // Default or validated selection
                occupation: _occupationController.text,
              );

              // Navigate to the next page and pass the profileData
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      CustomizeProfilePage_1_2(profileData: profileData),
                ),
              );
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
