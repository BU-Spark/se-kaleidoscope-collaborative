import 'package:flutter/material.dart';
import 'package:kaleidoscope_collaborative/screens/LoggingIn/constants.dart';


class SignupScreen extends StatefulWidget{
  const SignupScreen({super.key});
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final FocusNode _fnameFocus = FocusNode();
  final FocusNode _lnameFocus = FocusNode();
  final FocusNode _usernameFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _confirmEmailFocus = FocusNode();
  final FocusNode _phoneNumberFocus = FocusNode();
  final FocusNode _confirmPhoneNumberFocus = FocusNode();

  final _fnameTextController = TextEditingController();
  final _lnameTextController = TextEditingController();
  final _usernameTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _confirmPasswordTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _confirmEmailTextController = TextEditingController();
  final _phoneNumberTextController = TextEditingController();
  final _confirmPhoneNumberTextController = TextEditingController();


  void clearText(TextEditingController controller) {
    controller.clear();
  }


  @override
  void dispose() {
    _fnameFocus.dispose();
    _lnameFocus.dispose();
    _usernameFocus.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
    _emailFocus.dispose();
    _confirmEmailFocus.dispose();
    _phoneNumberFocus.dispose();
    _confirmPhoneNumberFocus.dispose();
    _fnameTextController.dispose();
    _lnameTextController.dispose();
    _usernameTextController.dispose();
    _passwordTextController.dispose();
    _confirmPasswordTextController.dispose();
    _emailTextController.dispose();
    _confirmEmailTextController.dispose();
    _phoneNumberTextController.dispose();
    _confirmPhoneNumberTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    _fnameFocus.addListener(() { setState(() {}); });
    _lnameFocus.addListener(() { setState(() {}); });
    _usernameFocus.addListener(() { setState(() {}); });
    _passwordFocus.addListener(() { setState(() {}); });
    _confirmPasswordFocus.addListener(() { setState(() {}); });
    _emailFocus.addListener(() { setState(() {}); });
    _confirmEmailFocus.addListener(() { setState(() {}); });
    _phoneNumberFocus.addListener(() { setState(() {}); });
    _confirmPhoneNumberFocus.addListener(() { setState(() {}); });


    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('1.1 Sign Up', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Scrollbar(
        thumbVisibility: true,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Image.asset(
                  'images/logo.jpg',
                  width: 117.0, // Set the width to match your design
                  height: 99.0, // Set the height to match your design
                ),
                SizedBox(height: _fnameFocus.hasFocus || _lnameFocus.hasFocus || _usernameFocus.hasFocus ? 20 : 48),

                // First Name input
                TextField(
                  focusNode: _fnameFocus,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'First Name',
                    suffixIcon: IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: ()=> clearText(_fnameTextController),
                    ),
                  ),
                  controller: _fnameTextController,
                ),
                SizedBox(height: 16),

                // Last Name input
                TextField(
                  focusNode: _lnameFocus,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Last Name',
                    suffixIcon: IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: ()=> clearText(_lnameTextController),
                    ),
                  ),
                  controller: _lnameTextController,
                ),
                SizedBox(height: 16),

                // UserName input
                TextField(
                  focusNode: _usernameFocus,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Username',
                    suffixIcon: IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: ()=> clearText(_usernameTextController),
                    ),
                  ),
                  controller: _usernameTextController,
                ),
                SizedBox(height: 32),

                // Password input
                TextField(
                  focusNode: _passwordFocus,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    suffixIcon: IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: ()=> clearText(_passwordTextController),
                    ),
                  ),
                  controller: _passwordTextController,
                ),
                SizedBox(height: 16),

                // Confirm Password input
                TextField(
                  focusNode: _confirmPasswordFocus,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: ' Confirm Password',
                    suffixIcon: IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: ()=> clearText(_confirmPasswordTextController),
                    ),
                  ),
                  controller: _confirmPasswordTextController,
                ),
                SizedBox(height: 32),

                // Email input
                TextField(
                  focusNode: _emailFocus,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    suffixIcon: IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: ()=> clearText(_emailTextController),
                    ),
                  ),
                  controller: _emailTextController,
                ),
                SizedBox(height: 16),

                // Confirm Email input
                TextField(
                  focusNode: _confirmEmailFocus,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: ' Confirm Email',
                    suffixIcon: IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: ()=> clearText(_confirmEmailTextController),
                    ),
                  ),
                  controller: _confirmEmailTextController,
                ),
                SizedBox(height: 32),

                

                // Divider with 'or'
                const Row(
                  children: <Widget>[
                    Expanded(child: Divider(
                      color: Colors.black,
                      thickness: 1,
                    )),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text('or'),
                    ),
                    Expanded(child: Divider(
                      color: Colors.black,
                      thickness: 1,
                    )),
                  ],
                ),
                SizedBox(height: 32),

                // Phone Number input
                TextField(
                  focusNode: _phoneNumberFocus,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Phone Number',
                    suffixIcon: IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: ()=> clearText(_phoneNumberTextController),
                    ),
                  ),
                  controller: _phoneNumberTextController,
                ),
                SizedBox(height: 16),

                // Confirm Phone Number input
                TextField(
                  focusNode: _confirmPhoneNumberFocus,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: ' Confirm Phone Number',
                    suffixIcon: IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: ()=> clearText(_confirmPhoneNumberTextController),
                    ),
                  ),
                  controller: _confirmPhoneNumberTextController,
                ),
                SizedBox(height: 32),

                ElevatedButton(
                child: Text('Submit'),
                onPressed: () {
                  // Submit the details filled
                },
                style: kButtonStyle,
              ),
              SizedBox(height: 32),


                ],
              ),
          ),
        ),
      ),
    );
  }
}



