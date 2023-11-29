import 'package:flutter/material.dart';
import 'package:kaleidoscope_collaborative/screens/constants.dart';

class ParameterRatingPage extends StatefulWidget {
  final String parameterName;

  const ParameterRatingPage({Key? key, required this.parameterName}) : super(key: key);

  @override
  _ParameterRatingPageState createState() => _ParameterRatingPageState();
}

class _ParameterRatingPageState extends State<ParameterRatingPage> {
  int parameterRating = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Life Ki Do Martial Arts', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'How would you rate ${widget.parameterName} at this business?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            // Star rating widget, similar to the OverallRatingPage
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              // mainAxisSize: MainAxisSize.max,
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
            // ... (Reuse the star rating widget code here)
            // Next button and back to business page
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    // Implement skip logic
                  },
                  child: Text('Skip'),
                  style: kSmallButtonStyle,
                ),
                ElevatedButton(
                  onPressed: () {
                    // Implement next logic
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
      ),
    );
  }
}
