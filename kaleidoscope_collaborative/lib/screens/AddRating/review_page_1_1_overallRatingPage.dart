import 'package:flutter/material.dart';
import 'package:kaleidoscope_collaborative/screens/LoggingIn/constants.dart';
import 'package:kaleidoscope_collaborative/screens/AddRating/review_page_2_1.dart';
import 'package:kaleidoscope_collaborative/screens/AddRating/Components/ReviewOrgDetails.dart';
import 'package:kaleidoscope_collaborative/screens/AddRating/Components/BackButton.dart';
import 'package:kaleidoscope_collaborative/components/AppBar.dart';

// Implementing Add a Review 1.1 : Overall Rating Page

class AddReviewPage extends StatefulWidget {
  final String OrganizationName;
  final String OrganizationType;
  final String OrganizationId;
  final String OrgImgLink;
  final String UserId;
  final String UserName;

  const AddReviewPage({
    Key? key,
    required this.OrganizationName,
    required this.OrganizationType,
    required this.OrganizationId,
    required this.OrgImgLink,
    required this.UserId,
    required this.UserName,
  }) : super(key: key);

  @override
  _AddReviewPageState createState() => _AddReviewPageState();
}

class _AddReviewPageState extends State<AddReviewPage> {
  int overallRating = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(AppBarText: 'Review Page'),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ReviewOrgDetails(
                OrgImgLink: widget.OrgImgLink,
                OrganizationName: widget.OrganizationName,
                OrganizationType: widget.OrganizationType
            ),
            Column(
              // crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'How would you rate this business?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 33),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (int i = 1; i <= 5; i++)
                      Container(
                        width: 55,
                        // Adjusted width
                        height: 55,
                        // Adjusted height
                        margin: const EdgeInsets.symmetric(horizontal: 7),
                        // Adjusted spacing
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: i - 1 < overallRating
                                ? const Color(0xFF6750A4)
                                : Colors.grey),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: Icon(Icons.star, size: 45, color: Colors.white),
                          onPressed: () {
                            setState(() {
                              overallRating = i;
                            });
                          },
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 48),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChooseRatingParametersPage(
                            overallRating: overallRating,
                            OrganizationName: widget.OrganizationName,
                            OrganizationType: widget.OrganizationType,
                            UserId: widget.UserId,
                            UserName: widget.UserName,
                            OrganizationId: widget.OrganizationId,
                            OrgImgLink: widget.OrgImgLink),
                      ),
                    );
                  },
                  child: Text('Next'),
                  style: kSmallButtonStyle,
                ),
                SizedBox(height: 16),
                BackButton2(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
