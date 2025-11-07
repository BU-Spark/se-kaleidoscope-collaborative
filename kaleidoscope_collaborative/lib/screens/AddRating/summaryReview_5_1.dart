import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaleidoscope_collaborative/config/app_theme.dart';
import 'package:kaleidoscope_collaborative/widgets/glassmorphic_button.dart';
import 'package:kaleidoscope_collaborative/screens/HomeAndLanding/home_page.dart';
import 'package:kaleidoscope_collaborative/screens/cloud_firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kaleidoscope_collaborative/screens/AddRating/Components/ReviewOrgDetails.dart';

//TODO: ADD PROPER ERROR HANDLING ON LINE 197

class SummaryReviewPage extends StatefulWidget {
  final String OrganizationName;
  final String OrganizationType;
  final String UserId;
  final String OrganizationId;
  final String OrgImgLink;
  final int overallRating;
  final Map<String, int> parameterRatings;
  final String? writtenReview;

  const SummaryReviewPage(
      {Key? key,
      required this.overallRating,
      required this.parameterRatings,
      required this.writtenReview,
      required this.OrganizationName,
      required this.OrganizationType,
      required this.UserId,
      required this.OrganizationId,
      required this.OrgImgLink})
      : super(key: key);

  @override
  _SummaryReviewPageState createState() => _SummaryReviewPageState();
}

class _SummaryReviewPageState extends State<SummaryReviewPage> {
  CloudFirestoreService? service;

  @override
  void initState() {
    service = CloudFirestoreService(FirebaseFirestore.instance);
    super.initState();
  }

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
          'Review Summary',
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
      body: Scrollbar(
        thumbVisibility: true,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 8),
                ReviewOrgDetails(
                    OrgImgLink: widget.OrgImgLink,
                    OrganizationName: widget.OrganizationName,
                    OrganizationType: widget.OrganizationType
                ),
                const SizedBox(height: 32),
                Text(
                  'Here\'s a summary of your review!',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.openSans(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  'Overall Rating',
                  style: GoogleFonts.openSans(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                // Display stars for overall rating
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (int i = 1; i <= 5; i++)
                      Container(
                        width: 40,
                        height: 40,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: i - 1 < widget.overallRating
                              ? AppTheme.primaryColor
                              : Colors.grey.shade300,
                          boxShadow: i - 1 < widget.overallRating
                              ? [
                                  BoxShadow(
                                    color: AppTheme.primaryColor.withValues(alpha: 0.3),
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
                                  ),
                                ]
                              : null,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.star,
                            size: 28,
                            color: i - 1 < widget.overallRating
                                ? Colors.white
                                : Colors.grey.shade500,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                if (widget.overallRating > 0)
                  Center(
                    child: Text(
                      '${widget.overallRating} out of 5 stars',
                      style: GoogleFonts.openSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryColorDark,
                      ),
                    ),
                  ),
                const SizedBox(height: 24),
                if (widget.parameterRatings.isNotEmpty) ...[
                  Text(
                    'Accommodation Ratings',
                    style: GoogleFonts.openSans(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Display parameter ratings
                  Column(
                    children: widget.parameterRatings.entries.map((entry) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              entry.key,
                              style: GoogleFonts.openSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                for (int i = 1; i <= 5; i++)
                                  Container(
                                    width: 32,
                                    height: 32,
                                    margin: const EdgeInsets.symmetric(horizontal: 3),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: i - 1 < entry.value
                                          ? AppTheme.primaryColor
                                          : Colors.grey.shade300,
                                      boxShadow: i - 1 < entry.value
                                          ? [
                                              BoxShadow(
                                                color: AppTheme.primaryColor.withValues(alpha: 0.3),
                                                blurRadius: 4,
                                                offset: const Offset(0, 2),
                                              ),
                                            ]
                                          : null,
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.star,
                                        size: 22,
                                        color: i - 1 < entry.value
                                            ? Colors.white
                                            : Colors.grey.shade500,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Center(
                              child: Text(
                                '${entry.value} out of 5 stars',
                                style: GoogleFonts.openSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: AppTheme.primaryColorDark,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                ],
                if (widget.writtenReview != null && widget.writtenReview != "[Skipped]") ...[
                  Text(
                    'Written Review',
                    style: GoogleFonts.openSans(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withValues(alpha: 0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller:
                          TextEditingController(text: widget.writtenReview),
                      maxLines: 6,
                      enabled: false,
                      style: GoogleFonts.openSans(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        contentPadding: const EdgeInsets.all(20),
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: Colors.grey.shade300, width: 1.0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ] else ...[
                  const SizedBox(height: 16),
                ],

                Row(
                  children: [
                    Expanded(
                      child: _buildCancelButton(context),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: GlassmorphicButton(
                        text: 'Submit',
                        onPressed: () async {
                          try {
                            Map<String, dynamic> userData = {
                              'accommodations': widget.parameterRatings,
                              'overallRating': widget.overallRating,
                              'placeID': widget.OrganizationId,
                              'placeName': widget.OrganizationName,
                              'placePhoto': widget.OrgImgLink,
                              'placePrimaryType': widget.OrganizationType,
                              'textReview': widget.writtenReview,
                              'userID': widget.UserId,
                              'userName': widget.UserId,
                              'timestamp': FieldValue.serverTimestamp(),
                            };
                            await service?.addUserReview(userData);
                          } catch (e) {
                            // Handle errors here, possibly show an error message to the user
                            print(
                                e); // Use a proper way to log errors or show a dialog to the user
                          }
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DashboardScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                // const SizedBox(height: 32),
                // Add safe area spacing at bottom
                SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCancelButton(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: const Color(0xFFE6DDF3),
        border: Border.all(
          color: AppTheme.primaryColor,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Route back to business card or previous screen
            Navigator.of(context).pop();
          },
          borderRadius: BorderRadius.circular(30),
          splashColor: AppTheme.primaryColor.withValues(alpha: 0.1),
          highlightColor: AppTheme.primaryColor.withValues(alpha: 0.05),
          child: Center(
            child: Text(
              'Cancel',
              style: GoogleFonts.openSans(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColorDark,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
