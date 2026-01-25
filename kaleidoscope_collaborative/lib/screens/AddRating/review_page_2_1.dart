import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaleidoscope_collaborative/config/app_theme.dart';
import 'package:kaleidoscope_collaborative/widgets/glassmorphic_button.dart';
import 'package:kaleidoscope_collaborative/screens/AddRating/review_page_3_1_paramterRatingPage.dart';
import 'package:kaleidoscope_collaborative/screens/AddRating/text_review_4_1.dart';
import 'package:kaleidoscope_collaborative/screens/AddRating/Components/ReviewOrgDetails.dart';
import 'package:kaleidoscope_collaborative/models/accommodations_constants.dart';

// Implementing Add a Review 2.1 : Choosing Accommodations for Rating Page
//
class ChooseRatingParametersPage extends StatefulWidget {
  final String OrganizationName;
  final String OrganizationType;
  final String UserId;
  final String UserName;
  final String OrganizationId;
  final String OrgImgLink;
  final int overallRating;

  const ChooseRatingParametersPage(
      {Key? key,
      required this.overallRating,
      required this.OrganizationName,
      required this.OrganizationType,
      required this.UserId,
        required this.UserName,
      required this.OrganizationId,
      required this.OrgImgLink})
      : super(key: key);

  @override
  _ChooseRatingParametersPageState createState() =>
      _ChooseRatingParametersPageState();
}

class _ChooseRatingParametersPageState
    extends State<ChooseRatingParametersPage> {
  final Map<String, int> parameterRatings = {};

  // Use shared accommodation categories from constants
  // Create a deep copy so we can modify the lists when selecting/deselecting
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Map<String, List<String>> categoryItems;

  @override
  void initState() {
    super.initState();
    // Create a deep copy of kAccommodationCategories so we can modify the lists
    categoryItems = {};
    kAccommodationCategories.forEach((key, value) {
      categoryItems[key] = List<String>.from(value);
    });
    //Currently unneeded as there's no way to add in new accommodation options,
    //so the following function is commented out to save on Firestore reads
    //fetchAccommodations();
  }

  Future<void> fetchAccommodations() async {
    Map<String, List<String>> accommodationsMap = {};

    // Fetch the collection
    QuerySnapshot querySnapshot =
        await _firestore.collection('Accommodation').get();

    // Iterate through the documents and group by 'accommodation_category'
    for (var doc in querySnapshot.docs) {
      var data = doc.data() as Map<String, dynamic>;
      String category = data['accommodation_category'];
      String name = data['name'];

      // If the category is already in the map, add the name to the list
      if (accommodationsMap.containsKey(category)) {
        accommodationsMap[category]!.add(name);
      } else {
        // Otherwise, create a new list with the name
        accommodationsMap[category] = [name];
      }
    }

    // return accommodationsMap;
    setState(() {
      categoryItems = accommodationsMap;
    });
  }

  // List to keep track of selected items
  List<String> selectedItems = [];

  // Function to handle selection
  void selectItem(String category, String item) {
    setState(() {
      selectedItems.add(item);
      categoryItems[category]?.remove(item);
    });
  }

  // Function to handle deselection
  void deselectItem(String category, String item) {
    setState(() {
      selectedItems.remove(item);
      categoryItems[category]?.add(item);
    });
  }

  // Function to build the list of chips for current selection
  Widget buildCurrentSelection() {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: selectedItems.map((item) {
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
              Text(
                item,
                style: GoogleFonts.openSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryColorDark,
                ),
              ),
              const SizedBox(width: 6),
              GestureDetector(
                onTap: () {
                  String? category = categoryItems.keys.firstWhere(
                    (k) => categoryItems[k]?.contains(item) == false,
                    orElse: () => '',
                  );
                  if (category.isNotEmpty) {
                    deselectItem(category, item);
                  }
                },
                child: const Icon(
                  Icons.close,
                  color: AppTheme.primaryColorDark,
                  size: 18,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // Function to build the list of chips for category items
  Widget buildCategoryChips(String category) {
    List<String>? items = categoryItems[category];
    if (items == null || items.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: items.map((item) {
        return GestureDetector(
          onTap: () => selectItem(category, item),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              border: Border.all(
                color: Colors.grey.shade300,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              item,
              style: GoogleFonts.openSans(
                color: Colors.black87,
                fontWeight: FontWeight.normal,
                fontSize: 14,
              ),
            ),
          ),
        );
      }).toList(),
    );
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
          'Choose Accommodations',
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'What accommodation(s) have you observed here?',
                  style: GoogleFonts.openSans(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 24),
                if (selectedItems.isNotEmpty) ...[
                  Text(
                    'Current selection',
                    style: GoogleFonts.openSans(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  buildCurrentSelection(),
                  const SizedBox(height: 24),
                ],
                for (String category in categoryItems.keys) ...[
                  Text(
                    category,
                    style: GoogleFonts.openSans(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  buildCategoryChips(category),
                  const SizedBox(height: 20),
                ],
                const SizedBox(height: 28),
                Row(
                  children: [
                    Expanded(
                      child: _buildSkipButton(context),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: GlassmorphicButton(
                        text: 'Next',
                        onPressed: selectedItems.isNotEmpty
                            ? () async {
                                for (String parameter in selectedItems) {
                                  final int? rating = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ParameterRatingPage(
                                          parameterName: parameter,
                                          OrganizationName: widget.OrganizationName,
                                          OrganizationType: widget.OrganizationType,
                                          UserId: widget.UserId,
                                          UserName: widget.UserName,
                                          OrganizationId: widget.OrganizationId,
                                          OrgImgLink: widget.OrgImgLink),
                                    ),
                                  );

                                  if (rating != null) {
                                    parameterRatings[parameter.replaceAll(' ', '')] = rating;
                                  }
                                }
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => TextReviewPage(
                                          overallRating: widget.overallRating,
                                          parameterRatings: parameterRatings,
                                          OrganizationName: widget.OrganizationName,
                                          OrganizationType: widget.OrganizationType,
                                          UserId: widget.UserId,
                                          UserName: widget.UserName,
                                          OrganizationId: widget.OrganizationId,
                                          OrgImgLink: widget.OrgImgLink)),
                                );
                              }
                            : () {},
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
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
                  builder: (context) => TextReviewPage(
                      overallRating: widget.overallRating,
                      parameterRatings: parameterRatings,
                      OrganizationName: widget.OrganizationName,
                      OrganizationType: widget.OrganizationType,
                      UserId: widget.UserId,
                      UserName: widget.UserName,
                      OrganizationId: widget.OrganizationId,
                      OrgImgLink: widget.OrgImgLink)),
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
