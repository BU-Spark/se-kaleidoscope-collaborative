import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kaleidoscope Collaborative',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Spacer(),
              Image.asset('assets/kaleidoscope_logo.png'), // Your logo asset
              SizedBox(height: 30),
              Text(
                'THE',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                'KALEIDOSCOPE\nCOLLABORATIVE',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Discover Disability Inclusive\nServices Around You!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 50),
              ElevatedButton(
                child: Text('Sign Up'),
                onPressed: () {
                  // Handle Sign Up
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.deepPurple,
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                child: Text('Log In'),
                onPressed: () {
                  // Handle Log In
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.deepPurple,
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
              ),
              TextButton(
                child: Text('Skip for now'),
                onPressed: () {
                  // Handle Skip
                },
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
