import 'package:flutter/material.dart';
import 'package:kaleidoscope_collaborative/screens/LoggingIn/constants.dart';


class SummaryReviewPage extends StatefulWidget {
  final String OrganizationName;
  final String OrganizationType;
  final String UserId;
  final String OrganizationId;
  final int overallRating;
  final Map<String, int> parameterRatings;
  final String? writtenReview;
  const SummaryReviewPage({Key? key,
    required this.overallRating,
    required this.parameterRatings,
    required this.writtenReview,
    required this.OrganizationName,
    required this.OrganizationType,
    required this.UserId,
    required this.OrganizationId, }) : super(key: key);

  @override
  _SummaryReviewPageState createState() => _SummaryReviewPageState();
}

class _SummaryReviewPageState extends State<SummaryReviewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Review Summary', style: TextStyle(color: Colors.black)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Scrollbar(
        thumbVisibility: true,
        child: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                // Small Image on the top left corner
                Image.asset(
                  'images/dummy.jpg',
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
            SizedBox(height: 20),
            Text('Your review has been submitted successfully!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text('Here\'s a summary of your review:', style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            Text('Overall Rating', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            // Display stars for overall rating
            Row(
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      // Circle icon as the background
                      Icon(

                        index < widget.overallRating ? Icons.circle : Icons.circle,
                        color: index < widget.overallRating ? Color(0xFF6750A4) : Colors.grey,
                        size: 30, 
                      ),
                      // Star icon on top of the circle
                      Align(
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.star,
                          color: Colors.white, // The color for the circle
                          size: 28, // The size of the circle
                        ),
                      ),
                    ],
                  ),
                  onPressed: null,);
              }),
            ),
            SizedBox(height: 10),
            Text('Accommodation Rating', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            
            // Display parameter ratings
            Column(
              children: widget.parameterRatings.entries.map((entry) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(entry.key),
                    Row(
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      // Circle icon as the background
                      Icon(

                        index < entry.value ? Icons.circle : Icons.circle,
                        color: index < entry.value ? Color(0xFF6750A4) : Colors.grey,
                        size: 30, 
                      ),
                      // Star icon on top of the circle
                      Align(
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.star,
                          color: Colors.white, // The color for the circle
                          size: 28, // The size of the circle
                        ),
                      ),
                    ],
                  ),
                  onPressed: null,);
              }),
            ),
                    ],
                );
              }).toList(),
            ),
            if (widget.writtenReview != null) ...[
              SizedBox(height: 20),
              Text('Written Review', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
             TextField(
                controller: TextEditingController(text: widget.writtenReview),
                maxLines: 10,
                enabled: false, // This makes the TextField non-editable
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  ),
                ),
              ),
            ],
            SizedBox(height: 20),


            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                   
                   },
                  child: Text('Back to Business'),
                  style: kSmallButtonStyle,
                ),
                ElevatedButton(
                  onPressed: () {
              },
                  child: Text('Homepage'),
                  style: kSmallButtonStyle,
                ),

              ],

            ),
            SizedBox(height: 16),

          ],
        ),
      ),
        ),
      ),
    );
  }
}
