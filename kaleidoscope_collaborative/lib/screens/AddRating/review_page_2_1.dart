import 'package:flutter/material.dart';
import 'package:kaleidoscope_collaborative/screens/constants.dart';

// Implementing the 1.1 Review Page

class ChooseRatingParametersPage extends StatefulWidget{
  const ChooseRatingParametersPage({super.key});
  @override
  _ChooseRatingParametersPageState createState() => _ChooseRatingParametersPageState();
}

class _ChooseRatingParametersPageState extends State<ChooseRatingParametersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose Rating Parameters Page',style: TextStyle(color:Colors.black)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
        elevation: 0, // Removes the shadow under the app bar
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Small Image on the top left corner
              Image.asset(
                'images/dummy.jpg',
                width: 117.0,
                height: 99.0,
              ),
            SizedBox(width: 16.0), // Add some spacing between the image and text
            // Title and Subtitle on the right, left-aligned
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Title',
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.0),
                Text(
                  'Subtitle',
                  style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}