import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaleidoscope_collaborative/config/app_theme.dart';
import 'package:kaleidoscope_collaborative/widgets/glassmorphic_button.dart';
import 'package:kaleidoscope_collaborative/screens/AddRating/Components/ReviewOrgDetails.dart';

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
          'Accommodation Rating',
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
                  'How would you rate ${widget.parameterName} at this business?',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.openSans(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (int i = 1; i <= 5; i++)
                      Container(
                        width: 50,
                        height: 50,
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: i - 1 < parameterRating
                              ? AppTheme.primaryColor
                              : Colors.grey.shade300,
                          boxShadow: i - 1 < parameterRating
                              ? [
                                  BoxShadow(
                                    color: AppTheme.primaryColor.withValues(alpha: 0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ]
                              : null,
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                parameterRating = i;
                              });
                            },
                            customBorder: const CircleBorder(),
                            child: Center(
                              child: Icon(
                                Icons.star,
                                size: 36,
                                color: i - 1 < parameterRating
                                    ? Colors.white
                                    : Colors.grey.shade500,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                if (parameterRating > 0)
                  Text(
                    '$parameterRating out of 5 stars',
                    style: GoogleFonts.openSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryColorDark,
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
                        text: 'Next',
                        onPressed: () {
                          // Implement next logic
                          Navigator.pop(
                              context, parameterRating); // Return the rating
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
            // Implement skip logic
            Navigator.pop(
                context, null); // Return null to indicate skipping
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
