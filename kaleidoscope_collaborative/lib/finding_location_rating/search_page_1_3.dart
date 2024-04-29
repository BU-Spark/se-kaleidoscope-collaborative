import 'package:flutter/material.dart';
import 'package:kaleidoscope_collaborative/screens/LoggingIn/constants.dart';
import 'package:kaleidoscope_collaborative/screens/AddRating/review_page_1_1_overallRatingPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//TO DO: Add profile photos to review cards
//Hi next semester's team if there is one

class SearchPage1_3 extends StatelessWidget {
  final Map<String, dynamic> result;
  final Map<String, dynamic> placeDetails;
  final String name;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  SearchPage1_3({required this.result, required this.placeDetails, required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(result['name'] ?? '', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FadeInImage.assetNetwork(
              // Pull the image FROM DB here, or BY default, our dummy picture
              placeholder: 'images/dental1.jpg',
              image: result['photo'],
              height: 150,
              width: double.infinity,
              fit: BoxFit.fill,
            ),

            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    result['name'] ?? '',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  if (placeDetails.isNotEmpty) ...[
                    if (placeDetails['current_opening_hours'] != null &&
                        placeDetails['current_opening_hours']['weekday_text'] !=
                            null)
                      Text(
                          "Business Hours:\n ${placeDetails['current_opening_hours']['weekday_text'].join(', ').split(',').join('\n')}"),
                    Text(
                        "Address: ${placeDetails['formatted_address'] ?? 'N/A'}"),
                    Text("Rating: ${result['rating'] ?? ''}"),
                    Text(
                        "Phone Number: ${placeDetails['formatted_phone_number'] ?? 'N/A'}"),
                  ],
                ],
              ),
            ),
            // "Add a Review" button

            Container(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: ElevatedButton(
                onPressed: () {
                  // Implement the action when the button is pressed
                  // Implement notification functionality
                  // Navigate to the temp rating card page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddReviewPage(
                            OrganizationName: placeDetails['name'],
                            OrganizationId: placeDetails['place_id'],
                            OrganizationType: placeDetails['types'].join(', '),
                            UserId: name,
                            UserName: name,
                            OrgImgLink: placeDetails['photo'])),
                  );
                },

                //MainAxisAlignment.center
                child: Text("Add a Review"),
                style: kSmallButtonStyle,
              ),
            ),

            // Display the content of RatingPage directly
            Container(
              child: Text("Community Reviews",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            ),

            FutureBuilder<dynamic>(
                future: getReviewsFor(placeDetails["place_id"]),
                // Future that returns the name
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return Text("Loading reviews...",
                        style: TextStyle(fontSize: 15));
                  }
                  if (snapshot.hasError) {
                    return Text("Error loading reviews",
                        style: TextStyle(fontSize: 15));
                  }
                  List<dynamic> reviews = snapshot.data ?? [];

                  if (reviews.isEmpty) {
                    return Container(
                      child: Text("No reviews currently",
                          style: TextStyle(fontSize: 15)),
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    );
                  } else {
                    return ListView.builder(
                        itemCount: reviews.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          var review = reviews[index].data();
                          return RatingPageContent(
                            review["overallRating"],
                            review["accommodations"],
                            review["userName"],
                            review["textReview"],
                          );
                        });
                  }
                })
          ],
        ),
      ),
    );
  }

  getReviewsFor(String? placeID) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('UserReview')
          .where('placeID', isEqualTo: placeID)
          .limit(8)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs;
      }
    } catch (e) {
      print(e.toString());
    }
  }

}

// Extracted widget for RatingPage content
class RatingPageContent extends StatelessWidget {
  final int overallRating;
  final Map accommodations;
  final String userName;
  final String textReview;

  RatingPageContent(
      this.overallRating, this.accommodations, this.userName, this.textReview);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: RatingBar(overallRating),
            ),

            SizedBox(height: 5),
            Text(
              userName,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),

            Padding(
              padding: EdgeInsets.only(left: 0, right: 50),
              // Adjust the horizontal padding as needed
              child: ExpandableText(
                initialText: textReview,
                expandedText: textReview,
              ),
            ),

            ListView.builder(
              shrinkWrap: true,
              itemCount: accommodations.length,
              physics: NeverScrollableScrollPhysics(),

              itemBuilder: (context, index) {
                final key = accommodations.keys.elementAt(index);
                final values = accommodations.values.elementAt(index);

                return Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      //or choose another Alignment
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          // Image border
                          child: Container(
                              height: 30,
                              color: Colors.deepPurple[100],
                              child: Row(children: [
                              const Padding(
                                padding: EdgeInsets.all(4.0),
                                child:
                                  Icon(
                                    Icons.directions_car,
                                    color: Colors.blue,
                                    size: 20.0,
                                  ),
                              ),
                                Text(
                                  key,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ])),
                        ),
                      ),
                    ));
              },
            ),
          ],
        ));
  }
}

// Expanding text
class ExpandableText extends StatefulWidget {
  final String initialText;
  final String expandedText;

  const ExpandableText({super.key, required this.initialText, required this.expandedText});

  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isExpanded ? widget.expandedText : widget.initialText,
          style: const TextStyle(fontSize: 12), // Adjusted font size
        ),
        TextButton(
          onPressed: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          child: Text(isExpanded ? 'Read Less' : 'Read More'),
        ),
      ],
    );
  }
}

// Rating bar
class RatingBar extends StatefulWidget {
  final rating;

  RatingBar(this.rating, {super.key});

  @override
  _RatingBarState createState() => _RatingBarState(rating);
}

class _RatingBarState extends State<RatingBar> {
  final rating;

  _RatingBarState(this.rating);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (int i = 1; i <= 5; i++)
          Container(
            width: 30,
            // Adjusted width
            height: 30,
            // Adjusted height
            margin: const EdgeInsets.symmetric(horizontal: 2),
            // Adjusted spacing
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: rating >= i ?  const Color(0xFF6750A4) : Colors.grey
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.star,
                  size: 20, color:Colors.white),
              onPressed: () {},
            ),
          ),
        const SizedBox(height: 10),
      ],
    );
  }
}

