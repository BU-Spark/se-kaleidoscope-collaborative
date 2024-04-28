import 'package:flutter/material.dart';
import 'package:kaleidoscope_collaborative/screens/HomeAndLanding/home_page.dart';
import 'package:kaleidoscope_collaborative/screens/LoggingIn/constants.dart';

// Implementing Add a Review 5 - 5.2 : Summary of the Ratings

// TODO: 
//Route the back to business page to the business card
class SummaryReviewPage extends StatefulWidget {
  final String OrganizationName;
  final String OrganizationType;
  final String UserId;
  final String OrganizationId;
  final String OrgImgLink;
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
    required this.OrganizationId, required this.OrgImgLink }) : super(key: key);

  @override
  _SummaryReviewPageState createState() => _SummaryReviewPageState();
}

class _SummaryReviewPageState extends State<SummaryReviewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Summary', style: TextStyle(color: Colors.black)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
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
                Image.asset(
                  widget.OrgImgLink,
                  fit: BoxFit.cover,
                  width: 117.0,
                  height: 99.0,
                ),
                const SizedBox(width: 16.0), 
                // Organization Title and Type
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.OrganizationName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.OrganizationType,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 48),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text('Your review has been submitted successfully!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const Text('Here\'s a summary of your review:', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            const Text('Overall Rating', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                        color: index < widget.overallRating ? const Color(0xFF6750A4) : Colors.grey,
                        size: 30, 
                      ),
                      // Star icon on top of the circle
                      const Align(
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
            const SizedBox(height: 10),
            const Text('Accommodation Rating', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            
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
                        color: index < entry.value ? const Color(0xFF6750A4) : Colors.grey,
                        size: 30, 
                      ),
                      // Star icon on top of the circle
                      const Align(
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
              const SizedBox(height: 20),
              const Text('Written Review', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
             TextField(
                controller: TextEditingController(text: widget.writtenReview),
                maxLines: 10,
                enabled: false, // This makes the TextField non-editable
                decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 20),


            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                   // todo: route back to business card
                   },
                  style: kSmallButtonStyle,
                  child: const Text('Back to Business'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DashboardScreen(),
                        ),
                      );
              },
                  style: kSmallButtonStyle,
                  child: const Text('Homepage'),
                ),

              ],

            ),
            const SizedBox(height: 16),

          ],
        ),
      ),
        ),
      ),
    );
  }
}
