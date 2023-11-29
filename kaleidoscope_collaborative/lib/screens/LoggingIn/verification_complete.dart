import 'package:flutter/material.dart';
import 'create_password.dart'; // Make sure to create this new page in your project

class VerificationComplete extends StatefulWidget {
  @override
  _VerificationCompleteState createState() => _VerificationCompleteState();
}

class _VerificationCompleteState extends State<VerificationComplete> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CreatePassword()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('2.5 Verification Page'),
        centerTitle: true,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.check_circle_outline,
              size: 100.0,
              color: Colors.teal,
            ),
            SizedBox(height: 24.0),
            Text(
              'Identity Verified',
              style: TextStyle(
                fontSize: 24.0,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
