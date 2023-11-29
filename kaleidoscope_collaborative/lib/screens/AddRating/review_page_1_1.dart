import 'package:flutter/material.dart';
import 'package:kaleidoscope_collaborative/screens/constants.dart';
import 'package:kaleidoscope_collaborative/screens/AddRating/review_page_2_1.dart';

class AddReviewPage extends StatefulWidget {
  const AddReviewPage({Key? key}) : super(key: key);

  @override
  _AddReviewPageState createState() => _AddReviewPageState();
}

class _AddReviewPageState extends State<AddReviewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Review Page', style: TextStyle(color: Colors.black)),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                // Small Image on the top left corner
                Image.asset(
                  'images/dummy.jpg',
                  width: 117.0, // Set the width to match your design
                  height: 99.0, // Set the height to match your design
                ),
                SizedBox(width: 16.0), // Add some spacing between the image and text
                // Organization Title and Type
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Organization Name',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Organization Type',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 48),
                  ],
                ),
              ],
            ),
            Column( 
              // crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 20),
            Text(
              'How would you rate this business?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 48),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChooseRatingParametersPage(),
                  ),
                );
              },
              child: Text('Next'),
              style: kSmallButtonStyle,
            ),
            SizedBox(height: 16),
            // TextButton(
            //   onPressed: () => Navigator.of(context).pop(),
            //   child: Text(
            //     'Back to business page',
            //     style: TextStyle(
            //       decoration: TextDecoration.underline,
            //       color: Color(0xFF6750A4),
            //     ),
            //   ),
            // ),
            Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      'Back to business page',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Color(0xFF6750A4),
                      ),
                    ),
                  ),
                ),
          ],
        ),
      ],
      ),
      ),
    );
  }
}
