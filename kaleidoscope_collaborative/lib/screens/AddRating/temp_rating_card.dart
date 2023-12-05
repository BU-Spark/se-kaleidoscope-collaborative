import 'package:flutter/material.dart';
import 'package:kaleidoscope_collaborative/screens/AddRating/review_page_1_1_overallRatingPage.dart';
import 'package:kaleidoscope_collaborative/screens/constants.dart'; 

class TemporaryRatingCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rating Card',style: TextStyle(color:Colors.black)),

        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddReviewPage()),
                  );
                },
                style: kButtonStyle,
                child: Text(
                  'Add Review',
                  style: kButtonTextStyle,
                ),
              ),
            SizedBox(height: 24),
            // Text(
            //   'Identity Verified',
            //   style: TextStyle(
            //     color: Colors.black,
            //     fontSize: 24,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
            // You can add more widgets here as needed
          ],
        ),
      ),
    );
  }
}
