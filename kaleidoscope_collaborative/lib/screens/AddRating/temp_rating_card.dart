import 'package:flutter/material.dart';
import 'package:kaleidoscope_collaborative/screens/AddRating/review_page_1_1_overallRatingPage.dart';
import 'package:kaleidoscope_collaborative/screens/LoggingIn/constants.dart';


class TemporaryRatingCard extends StatelessWidget {
  final String OrganizationName;
  final String OrganizationType;
  final String UserId;
  final String OrganizationId;
  final String OrgImgLink;
  const TemporaryRatingCard({Key? key, 
  required this.OrganizationName,
  required this.OrganizationType,
  required this.UserId,
  required this.OrganizationId,
  required this.OrgImgLink,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Temporary Rating Card',style: TextStyle(color:Colors.black)),

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
                    MaterialPageRoute(builder: (context) => AddReviewPage(OrganizationName: this.OrganizationName, 
                    OrganizationType: this.OrganizationType, UserId: this.UserId, OrganizationId: this.OrganizationId, OrgImgLink: this.OrgImgLink,)),
                  );
                },
                style: kButtonStyle,
                child: Text(
                  'Add Review',
                  style: kButtonTextStyle,
                ),
              ),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
