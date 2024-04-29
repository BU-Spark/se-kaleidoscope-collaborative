import 'package:flutter/material.dart';
import 'package:kaleidoscope_collaborative/screens/LoggingIn/constants.dart';
import 'package:kaleidoscope_collaborative/screens/AddRating/Components/ReviewOrgDetails.dart';
import 'package:kaleidoscope_collaborative/screens/AddRating/Components/BackButton.dart';
import 'package:kaleidoscope_collaborative/components/AppBar.dart';

// Implementing Add a Review 3.1.1 - 3.5.2 : Rating Page - for each accommodation

class ParameterRatingPage extends StatefulWidget {
  final String parameterName;
  final String OrganizationName;
  final String OrganizationType;
  final String UserId;
  final String UserName;
  final String OrganizationId;
  final String OrgImgLink;

  const ParameterRatingPage(
      {Key? key,
      required this.parameterName,
      required this.OrganizationName,
      required this.OrganizationType,
      required this.UserId, required this.UserName,
      required this.OrganizationId,
      required this.OrgImgLink})
      : super(key: key);

  @override
  _ParameterRatingPageState createState() => _ParameterRatingPageState();
}

class _ParameterRatingPageState extends State<ParameterRatingPage> {
  int parameterRating = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(AppBarText: 'Accommodation Rating Page',),
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
            Column(
              // crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 20),
                Text(
                  'How would you rate ${widget.parameterName} at this business?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 48),
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
                            color: i - 1 < parameterRating
                                ? const Color(0xFF6750A4)
                                : Colors.grey),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: Icon(Icons.star, size: 45, color: Colors.white),
                          onPressed: () {
                            setState(() {
                              parameterRating = i;
                            });
                          },
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 48),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        // Implement skip logic
                        Navigator.pop(
                            context, null); // Return null to indicate skipping
                      },
                      child: Text('Skip'),
                      style: kSmallButtonStyle,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Implement next logic
                        Navigator.pop(
                            context, parameterRating); // Return the rating
                      },
                      child: Text('Next'),
                      style: kSmallButtonStyle,
                    ),
                  ],
                ),
                SizedBox(height: 16),
                BackButton2()
              ],
            ),
          ],
        ),
      ),
    );
  }
}
