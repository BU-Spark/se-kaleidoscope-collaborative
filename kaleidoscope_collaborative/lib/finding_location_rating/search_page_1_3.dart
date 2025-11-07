import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaleidoscope_collaborative/config/app_theme.dart';
import 'package:kaleidoscope_collaborative/widgets/glassmorphic_button.dart';
import 'package:kaleidoscope_collaborative/screens/AddRating/review_page_1_1_overallRatingPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kaleidoscope_collaborative/utils/place_type_helper.dart';

//TO DO: Add profile photos to review cards
//Hi next semester's team if there is one

class SearchPage1_3 extends StatefulWidget {
  final Map<String, dynamic> result;
  final Map<String, dynamic> placeDetails;
  final String name;

  SearchPage1_3({required this.result, required this.placeDetails, required this.name});

  @override
  _SearchPage1_3State createState() => _SearchPage1_3State();
}

class _SearchPage1_3State extends State<SearchPage1_3> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        leading: Center(
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            constraints: const BoxConstraints(),
          ),
        ),
        title: Text(
          widget.result['name'] ?? 'Place Details',
          style: GoogleFonts.openSans(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
        toolbarHeight: 48,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.result['photo'] != null)
              Image.network(
                widget.result['photo'],
                height: 240,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 240,
                    color: Colors.grey.shade300,
                    child: Center(
                      child: Icon(
                        Icons.image_not_supported,
                        size: 64,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    height: 240,
                    color: Colors.grey.shade200,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppTheme.primaryColor,
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    ),
                  );
                },
              ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.result['name'] ?? 'Unknown Place',
                    style: GoogleFonts.openSans(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (widget.placeDetails.isNotEmpty) ...[
                    if (widget.result['rating'] != null) ...[
                      _buildDetailRow(
                        Icons.star,
                        'Rating: ${widget.result['rating']}',
                      ),
                      const SizedBox(height: 12),
                    ],
                    if (widget.placeDetails['formatted_address'] != null) ...[
                      _buildDetailRow(
                        Icons.location_on_outlined,
                        widget.placeDetails['formatted_address'],
                      ),
                      const SizedBox(height: 12),
                    ],
                    if (widget.placeDetails['formatted_phone_number'] != null) ...[
                      _buildDetailRow(
                        Icons.phone_outlined,
                        widget.placeDetails['formatted_phone_number'],
                      ),
                      const SizedBox(height: 12),
                    ],
                    if (widget.placeDetails['current_opening_hours'] != null &&
                        widget.placeDetails['current_opening_hours']['weekday_text'] !=
                            null) ...[
                      _buildBusinessHours(
                        widget.placeDetails['current_opening_hours']['weekday_text'],
                      ),
                    ],
                  ],
                ],
              ),
            ),
            // "Add a Review" button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: GlassmorphicButton(
                text: "Add a Review",
                onPressed: () {
                  // Get the primary type from the place details
                  String primaryType = 'N/A';
                  if (widget.placeDetails['primary_type'] != null &&
                      widget.placeDetails['primary_type'].toString().isNotEmpty) {
                    primaryType = widget.placeDetails['primary_type'];
                  } else if (widget.placeDetails['types'] != null) {
                    // Fallback: get primary type from types array
                    final types = widget.placeDetails['types'] as List<dynamic>?;
                    if (types != null && types.isNotEmpty) {
                      primaryType = PlaceTypeHelper.getPrimaryType(types);
                    }
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddReviewPage(
                            OrganizationName: widget.placeDetails['name'] ?? 'Unknown',
                            OrganizationId: widget.placeDetails['place_id'] ?? '',
                            OrganizationType: primaryType,
                            UserId: widget.name,
                            UserName: widget.name,
                            OrgImgLink: widget.placeDetails['photo'] ?? '')),
                  );
                },
              ),
            ),

            // Display the content of RatingPage directly
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: Text(
                "Community Reviews",
                style: GoogleFonts.openSans(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),

            FutureBuilder<dynamic>(
                future: getReviewsFor(widget.placeDetails["place_id"]),
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                        child: Column(
                          children: [
                            const CircularProgressIndicator(
                              color: AppTheme.primaryColor,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "Loading reviews...",
                              style: GoogleFonts.openSans(
                                fontSize: 16,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  if (snapshot.hasError) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "Error loading reviews",
                        style: GoogleFonts.openSans(
                          fontSize: 16,
                          color: Colors.red.shade700,
                        ),
                      ),
                    );
                  }
                  List<dynamic> reviews = snapshot.data ?? [];

                  if (reviews.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.rate_review_outlined,
                              size: 64,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "No reviews yet",
                              style: GoogleFonts.openSans(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Be the first to review this place!",
                              style: GoogleFonts.openSans(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return ListView.builder(
                        itemCount: reviews.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
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

  Widget _buildDetailRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: AppTheme.primaryColor,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.openSans(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBusinessHours(List<dynamic> weekdayText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.access_time,
              size: 20,
              color: AppTheme.primaryColor,
            ),
            const SizedBox(width: 12),
            Text(
              "Business Hours",
              style: GoogleFonts.openSans(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(left: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: weekdayText.map((day) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Text(
                  day.toString(),
                  style: GoogleFonts.openSans(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
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
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: const BorderRadius.all(Radius.circular(16)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: RatingBar(overallRating),
            ),

            const SizedBox(height: 8),
            Text(
              userName,
              style: GoogleFonts.openSans(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),

            Padding(
              padding: const EdgeInsets.only(left: 0, right: 50),
              child: ExpandableText(
                initialText: textReview,
                expandedText: textReview,
              ),
            ),

            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: accommodations.keys.map<Widget>((key) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withValues(alpha: 0.15),
                    border: Border.all(
                      color: AppTheme.primaryColor,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: AppTheme.primaryColorDark,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        key,
                        style: GoogleFonts.openSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryColorDark,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
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
          style: GoogleFonts.openSans(
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: const Size(0, 30),
          ),
          child: Text(
            isExpanded ? 'Read Less' : 'Read More',
            style: GoogleFonts.openSans(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryColorDark,
            ),
          ),
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

