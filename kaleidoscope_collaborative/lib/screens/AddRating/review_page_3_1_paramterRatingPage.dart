import 'package:flutter/material.dart';
import 'package:kaleidoscope_collaborative/screens/LoggingIn/constants.dart';
import 'package:kaleidoscope_collaborative/screens/AddRating/review_page_2_1.dart';

class ParameterRatingPage extends StatefulWidget {
  final String parameterName;
  final String OrganizationName;
  final String OrganizationType;
  final String UserId;
  final String OrganizationId;
  final String OrgImgLink;
  const ParameterRatingPage({Key? key, required this.parameterName,required this.OrganizationName, required this.OrganizationType, 
  required this.UserId, required this.OrganizationId , required this.OrgImgLink}) : super(key: key);

  @override
  _ParameterRatingPageState createState() => _ParameterRatingPageState();
}

class _ParameterRatingPageState extends State<ParameterRatingPage> {
  int parameterRating = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Accomodation Rating Page', style: TextStyle(color: Colors.black)),
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
                  width: 117.0, // Set the width to match your design
                  height: 99.0, // Set the height to match your design
                ),
                SizedBox(width: 16.0), // Add some spacing between the image and text
                // Organization Title and Type
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '${widget.OrganizationName}',
                      style: TextStyle(
                        fontSize: 24,
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
              'How would you rate ${widget.parameterName} at this business?',
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

                        index < parameterRating ? Icons.circle : Icons.circle,
                        color: index < parameterRating ? Color(0xFF6750A4) : Colors.grey,
                        size: 60, 
                      ),
                      // Star icon on top of the circle
                      Align(
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.star,
                          color: Colors.white, // The color for the circle
                          size: 58, // The size of the circle
                        ),
                      ),
                    ],
                  ),
                  onPressed: () {
                    setState(() {
                      parameterRating = index + 1;
                    });
                  },
                );
              }),
            ),
            SizedBox(height: 48),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    // Implement skip logic
                     Navigator.pop(context, null); // Return null to indicate skipping
                  },
                  child: Text('Skip'),
                  style: kSmallButtonStyle,
                ),
                ElevatedButton(
                  onPressed: () {
                    // Implement next logic
                    Navigator.pop(context, parameterRating); // Return the rating
                  },
                  child: Text('Next'),
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
      ],
      ),
      ),
    );
  }
}
