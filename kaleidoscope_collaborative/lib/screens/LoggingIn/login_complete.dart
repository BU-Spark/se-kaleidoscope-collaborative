import 'package:flutter/material.dart';
import 'dart:async';
import 'package:kaleidoscope_collaborative/screens/HomeAndLanding/onboarding_page.dart';
import 'package:firebase_auth/firebase_auth.dart';


class LoginCompletePage extends StatefulWidget {

  LoginCompletePage({Key? key,}) : super(key: key);

  @override
  _LoginCompletePageState createState() => _LoginCompletePageState();
}

class _LoginCompletePageState extends State<LoginCompletePage> {

  final _auth = FirebaseAuth.instance;
  late User loggedInUser;


  @override
  void initState() {
    super.initState();
    getCurrentUser();

  }

  void getCurrentUser() async{
    try{
      final user = _auth.currentUser;
      if(user!=null){
        loggedInUser = user;
        print(loggedInUser.email);
        Timer(Duration(seconds: 3), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => OnboardingScreen()),
          );
        });
      }
    }
    catch(e){
      print(e);
    }
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'images/logo.jpg',
              width: 117.0,
              height: 99.0,
            ),
            SizedBox(height: 20),
            Text(
              'Welcome ${loggedInUser.email}!',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


