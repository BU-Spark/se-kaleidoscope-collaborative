import 'package:flutter/material.dart';
import 'package:kaleidoscope_collaborative/screens/constants.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';

// Implementing the Idenity Verification Page

class IdentityVerificationPage extends StatefulWidget{
  const IdentityVerificationPage({super.key});
  @override
  _IdentityVerificationPageState createState() => _IdentityVerificationPageState();
}

class _IdentityVerificationPageState extends State<IdentityVerificationPage> {
  final FocusNode _fnameFocus = FocusNode();
  // final TextEditingController _fnameTextController = TextEditingController();
  @override
  void dispose() {
    _fnameFocus.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    _fnameFocus.addListener(() { setState(() {}); });
    bool _onEditing = true;
    String? _code;
    return Scaffold(
      appBar: AppBar(
        title: Text('Identity Verification Page',style: TextStyle(color:Colors.black)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
        elevation: 0, // Removes the shadow under the app bar
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Image.asset(
              'images/logo.jpg',
              width: 117.0, // Set the width to match your design
              height: 99.0, // Set the height to match your design
            ),
            SizedBox(height: 100),

            Text(
              'Verification Code sent to ',
              textAlign: TextAlign.center,),
              SizedBox(height: 16),


            VerificationCode(
              textStyle: TextStyle(fontSize: 21.0, decoration: TextDecoration.underline, color: Color(0xff0074e0)),
              underlineColor: Color(0xff0074e0),
              keyboardType: TextInputType.number,
              length: 6,
              // clearAll is NOT required, you can delete it
              // takes any widget, so you can implement your design
              onCompleted: (String value) {
                setState(() {
                  _code = value;
                });
              },
              onEditing: (bool value) {
                setState(() {
                  _onEditing = value;
                });
              },
            ),

            // Row(
            //   children: 
              
            //   <Widget>[
            //     // First Name input
            //     TextField(
            //       focusNode: _fnameFocus,
            //       decoration: InputDecoration(
            //         border: OutlineInputBorder(),
            //         labelText: 'First Name',
            //         suffixIcon: IconButton(
            //               icon: const Icon(Icons.clear), onPressed: () {  },
            //               // onPressed: ()=> clearText(_fnameTextController),
            //         ),
            //       ),
            //       controller: _fnameTextController,
            //     ),
            //   //   // Expanded(child: Divider(thickness: 1)),
            //   //   Padding(
            //   //     padding: EdgeInsets.symmetric(horizontal: 8),
            //   //     child: Text('or'),
            //   //   ),
            //   //   // Expanded(child: Divider(thickness: 1)),
            //   ],
            // ),
            // SizedBox(height: 16),

            Text(
              'Did not receive the text?',
              textAlign: TextAlign.center,),
              SizedBox(height: 16),

            // Resend SMS
            ElevatedButton(
              onPressed: () {
              },
              child: Text('Resend SMS'),
              style: kButtonStyle
            ),
            SizedBox(height: 16),


            // Try another verification method
            ElevatedButton(
              onPressed: () {
              },
              child: Text('Try another verification method'),
              style: kButtonStyle
            ),
          ],
        ),
      ),
    );
  }
}