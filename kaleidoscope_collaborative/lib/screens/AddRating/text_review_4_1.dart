import 'package:flutter/material.dart';
import 'package:kaleidoscope_collaborative/screens/AddRating/summaryReview_5_1.dart';
import 'package:kaleidoscope_collaborative/screens/LoggingIn/constants.dart';
import 'package:kaleidoscope_collaborative/screens/AddRating/Components/ReviewOrgDetails.dart';
import 'package:kaleidoscope_collaborative/components/AppBar.dart';

class TextReviewPage extends StatefulWidget {
  final int overallRating;
  final String OrganizationName;
  final String OrganizationType;
  final String UserId;
  final String UserName;
  final String OrganizationId;
  final String OrgImgLink;
  final Map<String, int> parameterRatings;
  const TextReviewPage(
      {Key? key,
      required this.overallRating,
      required this.parameterRatings,
      required this.OrganizationName,
      required this.OrganizationType,
      required this.UserId,
        required this.UserName,
      required this.OrganizationId,
      required this.OrgImgLink})
      : super(key: key);

  @override
  _TextReviewPageState createState() => _TextReviewPageState();
}

class _TextReviewPageState extends State<TextReviewPage> {
  final TextEditingController _controller = TextEditingController();
  bool _hasWrittenReview = false;


  List<Map<String, dynamic>> prepareUserRatingData({
    required String userId,
    required String orgId,
    required Map<String, int>
        ratings, // Assuming ratings will always be provided
  }) {
    List<Map<String, dynamic>> data = [];

    // Iterate through the ratings and create a map for each
    ratings.forEach((accommodation, rating) {
      Map<String, dynamic> entry = {
        'user_id': userId,
        'org_id': orgId,
        'accommodation': accommodation,
        'rating': rating,
      };
      data.add(entry);
    });

    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset : false,
      appBar: CustomAppBar(AppBarText: 'Write a review'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ReviewOrgDetails(
                OrgImgLink: widget.OrgImgLink,
                OrganizationName: widget.OrganizationName,
                OrganizationType: widget.OrganizationType
            ),
            Text('Write your review',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            TextField(
              controller: _controller,
              maxLines: 10,
              decoration: InputDecoration(
                hintText:
                    'What did you like or dislike about your experience at this business?',
                // Border when the TextField is not in focus
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 1.0),
                ),
                // Border when the TextField is in focus
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF6750A4), width: 2.0),
                ),
              ),
              onChanged: (text) {
                setState(() {
                  _hasWrittenReview = text.isNotEmpty;
                });
              },
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SummaryReviewPage(
                          overallRating: widget.overallRating,
                          parameterRatings: widget.parameterRatings,
                          writtenReview: "[Skipped]",
                          OrganizationName: widget.OrganizationName,
                          OrganizationType: widget.OrganizationType,
                          UserId: widget.UserId,
                          OrganizationId: widget.OrganizationId,
                          OrgImgLink: widget.OrgImgLink,
                        ),
                      ),
                    );
                  },
                  style: kSmallButtonStyle,
                  child: const Text('Skip and Submit'),
                ),
                ElevatedButton(
                  // onPressed: () {
                  onPressed: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SummaryReviewPage(
                          overallRating: widget.overallRating,
                          parameterRatings: widget.parameterRatings,
                          writtenReview: _controller.text,
                          OrganizationName: widget.OrganizationName,
                          OrganizationType: widget.OrganizationType,
                          UserId: widget.UserId,
                          OrganizationId: widget.OrganizationId,
                          OrgImgLink: widget.OrgImgLink,
                        ),
                      ),
                    );
                  },
                  style: kSmallButtonStyle,
                  child: const Text('Submit'),
                ),
              ],
            ),
            SizedBox(height: 16),
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
      ),
    );
  }
}
