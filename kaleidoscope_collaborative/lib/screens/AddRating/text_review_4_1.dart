import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaleidoscope_collaborative/config/app_theme.dart';
import 'package:kaleidoscope_collaborative/widgets/glassmorphic_button.dart';
import 'package:kaleidoscope_collaborative/screens/AddRating/summaryReview_5_1.dart';
import 'package:kaleidoscope_collaborative/screens/AddRating/Components/ReviewOrgDetails.dart';

class TextReviewPage extends StatefulWidget {
  final int overallRating;
  final String OrganizationName;
  final String OrganizationType;
  final String UserId;
  final String UserName;
  final String OrganizationId;
  final String OrgImgLink;
  final Map<String, int> parameterRatings;
  const TextReviewPage(
      {Key? key,
      required this.overallRating,
      required this.parameterRatings,
      required this.OrganizationName,
      required this.OrganizationType,
      required this.UserId,
        required this.UserName,
      required this.OrganizationId,
      required this.OrgImgLink})
      : super(key: key);

  @override
  _TextReviewPageState createState() => _TextReviewPageState();
}

class _TextReviewPageState extends State<TextReviewPage> {
  final TextEditingController _controller = TextEditingController();


  List<Map<String, dynamic>> prepareUserRatingData({
    required String userId,
    required String orgId,
    required Map<String, int>
        ratings, // Assuming ratings will always be provided
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
      backgroundColor: AppTheme.backgroundColor,
      resizeToAvoidBottomInset: false,
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
          'Write a Review',
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
      body: Padding(
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
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Write your review',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.openSans(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 24),
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
                    controller: _controller,
                    maxLines: 6,
                    textInputAction: TextInputAction.done,
                    style: GoogleFonts.openSans(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                    decoration: InputDecoration(
                      hintText:
                          'What did you like or dislike about your experience at this business?',
                      hintStyle: GoogleFonts.openSans(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.all(20),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: Colors.grey.shade300, width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: AppTheme.primaryColor, width: 2.0),
                      ),
                    ),
                    onChanged: (text) {
                      // Text change handling can be added here if needed
                    },
                    onSubmitted: (text) {
                      // Dismiss keyboard when Done is pressed
                      FocusScope.of(context).unfocus();
                    },
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: _buildSkipButton(context),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: GlassmorphicButton(
                        text: 'Submit',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SummaryReviewPage(
                                overallRating: widget.overallRating,
                                parameterRatings: widget.parameterRatings,
                                writtenReview: _controller.text.isEmpty ? "[Skipped]" : _controller.text,
                                OrganizationName: widget.OrganizationName,
                                OrganizationType: widget.OrganizationType,
                                UserId: widget.UserId,
                                OrganizationId: widget.OrganizationId,
                                OrgImgLink: widget.OrgImgLink,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                // Add safe area spacing at bottom
                SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkipButton(BuildContext context) {
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
          borderRadius: BorderRadius.circular(30),
          splashColor: AppTheme.primaryColor.withValues(alpha: 0.1),
          highlightColor: AppTheme.primaryColor.withValues(alpha: 0.05),
          child: Center(
            child: Text(
              'Skip',
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
