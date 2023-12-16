import 'package:flutter/material.dart';
import 'package:kaleidoscope_collaborative/screens/LoggingIn/verification_complete.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:kaleidoscope_collaborative/screens/LoggingIn/constants.dart';


class VerificationCodeScreen extends StatefulWidget {
  final String unique_id;
  final String verification_type;


  const VerificationCodeScreen({Key? key, required this.unique_id, required this.verification_type}) : super(key: key);


  @override
  _VerificationCodeScreenState createState() => _VerificationCodeScreenState();
}

class _VerificationCodeScreenState extends State<VerificationCodeScreen> {
  final TextEditingController _pinController = TextEditingController();

  @override
  void dispose() {
    _pinController.dispose();
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
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Image.asset(
                'images/logo.jpg', // Ensure you have an image at this path
                height: 99.0,
              ),
              SizedBox(height: 48),
              const Text(
                'Enter Verification Code',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Password reset verification sent to\n${widget.unique_id}',
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 24),
              PinCodeTextField(
                appContext: context,
                length: 4,
                controller: _pinController,
                onChanged: (String value) {
                  if (value.length == 4) {
                    Future.delayed(Duration(milliseconds: 100), () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => VerificationComplete()));
                    });
                  }
                },

                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(5),
                  fieldHeight: 50,
                  fieldWidth: 50,
                  activeFillColor: Colors.white,
                  inactiveColor: Colors.blue,
                  selectedColor: Colors.blue,
                  activeColor: Colors.blue,
                ),
                keyboardType: TextInputType.number,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
              ),
              SizedBox(height: 24),
              Text(
                'Did not receive the ${widget.verification_type}?',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                child: Text('Resend Email'),
                onPressed: () {
                  // Implement resend logic
                },
                style: kButtonStyle,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                child: Text('Try another email address'),
                onPressed: () {
                  // Implement change email logic
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
