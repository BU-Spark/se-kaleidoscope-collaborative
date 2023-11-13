import 'package:flutter/material.dart';
import 'package:kaleidoscope_collaborative/screens/constants.dart';


class SignupScreen extends StatefulWidget{
  const SignupScreen({super.key});
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final FocusNode _fnameFocus = FocusNode();
  final FocusNode _lnameFocus = FocusNode();
  final FocusNode _usernameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  @override
  void dispose() {
    _fnameFocus.dispose();
    _lnameFocus.dispose();
    _usernameFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    _fnameFocus.addListener(() { setState(() {}); });
    _lnameFocus.addListener(() { setState(() {}); });
    _usernameFocus.addListener(() { setState(() {}); });
    _emailFocus.addListener(() { setState(() {}); });
    _passwordFocus.addListener(() { setState(() {}); });

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
      body: SingleChildScrollView(
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
                  labelText: 'First Name',
                  suffixIcon: Icon(Icons.close),
                ),
              ),
              SizedBox(height: 16),

              // Last Name input
              TextField(
                focusNode: _lnameFocus,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Last Name',
                  suffixIcon: Icon(Icons.close),
                ),
              ),
              SizedBox(height: 16),

               // UserName input
              TextField(
                focusNode: _usernameFocus,
                decoration: InputDecoration(
                  labelText: 'Username',
                  suffixIcon: Icon(Icons.close),
                ),
              ),
              SizedBox(height: 16),

              // // Password input
              // TextField(
              //   focusNode: _passwordFocus,
              //   obscureText: true,
              //   decoration: const InputDecoration(
              //     labelText: 'Password',
              //     suffixIcon: Icon(Icons.close),
              //   ),
              // ),
              // SizedBox(height: 32),

              

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
              SizedBox(height: 16),

            ],
          ),
        ),
      ),
    );
  }
}



