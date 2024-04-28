import 'package:flutter/material.dart';
import 'package:kaleidoscope_collaborative/screens/AddRating/review_page_1_1_overallRatingPage.dart';
import 'package:kaleidoscope_collaborative/screens/LoggingIn/constants.dart';

// Implementing Temporary Rating Card

// TODO: 
// Replace this page with the rating card implemented Find Location/Rating Wireframe 2.0
// link the add the review button
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
        title: const Text('Temporary Rating Card',style: TextStyle(color:Colors.black)),

        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddReviewPage(OrganizationName: OrganizationName, 
                    OrganizationType: OrganizationType, UserId: UserId, OrganizationId: OrganizationId, OrgImgLink: OrgImgLink,)),
                  );
                },
                style: kButtonStyle,
                child: const Text(
                  'Add Review',
                  style: kButtonTextStyle,
                ),
              ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
