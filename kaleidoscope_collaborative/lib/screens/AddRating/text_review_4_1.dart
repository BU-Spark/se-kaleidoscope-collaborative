import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kaleidoscope_collaborative/screens/AddRating/summaryReview_5_1.dart';
import 'package:kaleidoscope_collaborative/screens/cloud_firestore_service.dart';
import 'package:kaleidoscope_collaborative/screens/LoggingIn/constants.dart';

class TextReviewPage extends StatefulWidget {
  final int overallRating;
  final String OrganizationName;
  final String OrganizationType;
  final String UserId;
  final String OrganizationId;
  final String OrgImgLink;
  final Map<String, int> parameterRatings;
  const TextReviewPage({Key? key,required this.overallRating,required this.parameterRatings, required this.OrganizationName, required this.OrganizationType, 
  required this.UserId, required this.OrganizationId, required this.OrgImgLink}) : super(key: key);

  @override
  _TextReviewPageState createState() => _TextReviewPageState();
}

class _TextReviewPageState extends State<TextReviewPage> {
  final TextEditingController _controller = TextEditingController();
  bool _hasWrittenReview = false;
   CloudFirestoreService? service;


  @override
  void initState() {
    // Initialize an instance of Cloud Firestore
    service = CloudFirestoreService(FirebaseFirestore.instance);
    super.initState();
  }

 List<Map<String, dynamic>> prepareUserRatingData({
  required String userId,
  required String orgId,
  required Map<String, int> ratings, // Assuming ratings will always be provided
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
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Write a Review Page', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[

            Row(
              children: <Widget>[
                // Small Image on the top left corner
                Image.asset(
                  '${widget.OrgImgLink}',
                  fit: BoxFit.cover,
                  width: 117.0, // Set the width to match your design
                  height: 99.0, // Set the height to match your design
                ),
                SizedBox(width: 16.0), // Add some spacing between the image and text
                // Organization Title and Type
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '${widget.OrganizationName}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '${widget.OrganizationType}',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 48),
                    ],
                  ),
                ),
              ],
            ),
                SizedBox(height: 20),
            
            Text('Write your review', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            TextField(
              controller: _controller,
              maxLines: 10,
              decoration: InputDecoration(
                hintText: 'What did you like or dislike about your experience at this business?',
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
                  child: Text('Skip and Submit'),
                  style: kSmallButtonStyle,
                ),
                ElevatedButton(
                  // onPressed: () {
                  onPressed: ()  async {
                      Map<String, dynamic> userOverallRatingData = {
                          'user_id': widget.UserId,
                          'org_id': widget.OrganizationId,
                          'accommodation': "Overall Rating", 
                          'rating': widget.overallRating,
                        };

                      // Your existing text review data map
                      Map<String, dynamic> userTextReviewData = {
                        'user_id': widget.UserId,
                        'org_id': widget.OrganizationId,
                        'accommodation': "TextReview", 
                        'review': _controller.text, // Changed 'rating' to 'review' for clarity
                      };

                      // List of all user data maps to add to the database
                      List<Map<String, dynamic>> allUserData = [];

                      // Add the overall rating and text review to the list
                      allUserData.add(userOverallRatingData);
                      allUserData.add(userTextReviewData);

                      // Prepare the accommodation ratings and add them to the list
                      List<Map<String, dynamic>> accommodationRatings = prepareUserRatingData(
                        userId: widget.UserId, 
                        orgId: widget.OrganizationId, 
                        ratings: widget.parameterRatings
                      );

                      allUserData.addAll(accommodationRatings);
                  
                  // Add the user rating to the database
                  try {
                    for (var userData in allUserData) {
                      await service?.addUserRating(userData);
                    }
                  } catch (e) {
                    // Handle errors here, possibly show an error message to the user
                  print(e); // Use a proper way to log errors or show a dialog to the user
                  }
                

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
                  child: Text('Submit'),
                  style: kSmallButtonStyle,
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
