import 'package:flutter/material.dart';
import 'package:kaleidoscope_collaborative/screens/LoggingIn/constants.dart';
import 'package:kaleidoscope_collaborative/screens/LoggingIn/reset_complete.dart';

class CreatePassword extends StatefulWidget {
  const CreatePassword({Key? key}) : super(key: key);

  @override
  _CreatePasswordState createState() => _CreatePasswordState();
}

class _CreatePasswordState extends State<CreatePassword> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  void clearText(TextEditingController controller) {
    controller.clear();
  }

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        // title: Text('Create new password', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Image.asset(
                'images/logo.jpg',
                width: 117.0,
                height: 99.0,
              ),
              SizedBox(height: 48),
              const Text(
                'Create New Password',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 48),
              const Text(
                'Your new password must be different from previous used passwords.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                'Password should be: 7-10 Characters in length; 1 capital letter; 1 number; 1 special character',
                style: TextStyle(color: Colors.grey[700]),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 32),
              TextField(
                controller: _newPasswordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () => clearText(_newPasswordController),
                  ),
                ),
                obscureText: true,
              ),
              SizedBox(height: 16),
              TextField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () => clearText(_confirmPasswordController),
                  ),
                ),
                obscureText: true,
              ),
              SizedBox(height: 24),
              ElevatedButton(
                child: Text('Reset Password'),
                onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PasswordConfirmedScreen()));
                },
                style: kButtonStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
