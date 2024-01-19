import 'package:flutter/material.dart';
import 'package:kaleidoscope_collaborative/screens/LoggingIn/constants.dart';
import 'package:kaleidoscope_collaborative/screens/AddRating/review_page_2_1.dart';

// Implementing Add a Review 1.1 : Overall Rating Page

class AddReviewPage extends StatefulWidget {
  final String OrganizationName;
  final String OrganizationType;
  final String UserId;
  final String OrganizationId;
  final String OrgImgLink;
  const AddReviewPage({Key? key, required this.OrganizationName, required this.OrganizationType, 
  required this.UserId, required this.OrganizationId, required this.OrgImgLink}) : super(key: key);

  @override
  _AddReviewPageState createState() => _AddReviewPageState();
}

class _AddReviewPageState extends State<AddReviewPage> {
  int overallRating = 0;
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
                  '${widget.OrgImgLink}',
                  fit: BoxFit.cover,
                  width: 117.0, 
                  height: 99.0, 
                ),
                SizedBox(width: 16.0), 
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
            Column( 
              // crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 20),
            Text(
              'How would you rate this business?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 48),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: 
              List.generate(5, (index) {
                
                return IconButton(
                  icon: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      // Circle icon as the background
                      Icon(

                        index < overallRating ? Icons.circle : Icons.circle,
                        color: index < overallRating ? Color(0xFF6750A4) : Colors.grey,
                        size: 60, 
                      ),
                      // Star icon on top of the circle
                      Align(
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.star,
                          color: Colors.white, 
                          size: 58, 
                        ),
                      ),
                    ],
                  ),
                  onPressed: () {
                    setState(() {
                      overallRating = index + 1;
                    });
                  },
                );
              }),
            ),
            SizedBox(height: 48),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChooseRatingParametersPage(overallRating: overallRating,
                    OrganizationName: widget.OrganizationName, OrganizationType: widget.OrganizationType, 
                    UserId: widget.UserId, OrganizationId: widget.OrganizationId,
                    OrgImgLink: widget.OrgImgLink),
                  ),
                );
              },
              child: Text('Next'),
              style: kSmallButtonStyle,
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
      ],
      ),
      ),
    );
  }
}
