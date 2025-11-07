import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kaleidoscope_collaborative/config/app_theme.dart';
import 'package:kaleidoscope_collaborative/screens/cloud_firestore_service.dart';
import 'package:kaleidoscope_collaborative/utils/place_type_helper.dart';
import 'package:kaleidoscope_collaborative/finding_location_rating/search_page_1_0.dart';

class ReviewContentPage extends StatefulWidget {
  final String userId;
  final String userName;

  const ReviewContentPage({
    Key? key,
    required this.userId,
    required this.userName,
  }) : super(key: key);

  @override
  _ReviewContentPageState createState() => _ReviewContentPageState();
}

class _ReviewContentPageState extends State<ReviewContentPage> {
  late CloudFirestoreService _firestoreService;

  @override
  void initState() {
    super.initState();
    _firestoreService = CloudFirestoreService(FirebaseFirestore.instance);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSearchBar(),
        Expanded(
          child: FutureBuilder<Map<String, List<QueryDocumentSnapshot>>>(
            future: _firestoreService.getUserReviewsByCategory(widget.userId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return _buildLoadingState();
              }

              if (snapshot.hasError) {
                return _buildErrorState(snapshot.error.toString());
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return _buildEmptyState();
              }

              return _buildCategorizedReviews(snapshot.data!);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SearchPage(
                name: widget.userName,
                skipFilters: true,
              ),
            ),
          );
        },
        readOnly: true,
        decoration: InputDecoration(
          hintText: 'Search places to review...',
          hintStyle: GoogleFonts.openSans(
            color: Colors.grey.shade600,
            fontSize: 16,
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: AppTheme.primaryColor,
            size: 24,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: AppTheme.primaryColor, width: 2),
          ),
          fillColor: Colors.white,
          filled: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            color: AppTheme.primaryColor,
          ),
          const SizedBox(height: 16),
          Text(
            'Loading your reviews...',
            style: GoogleFonts.openSans(
              fontSize: 16,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              'Error loading reviews',
              style: GoogleFonts.openSans(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please try again later',
              style: GoogleFonts.openSans(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.rate_review_outlined,
              size: 80,
              color: AppTheme.primaryColor.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No Reviews Yet',
              style: GoogleFonts.openSans(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColorDark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Start reviewing places to see them here!',
              textAlign: TextAlign.center,
              style: GoogleFonts.openSans(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchPage(
                      name: widget.userName,
                      skipFilters: true,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.search),
              label: Text(
                'Search Places',
                style: GoogleFonts.openSans(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorizedReviews(Map<String, List<QueryDocumentSnapshot>> reviews) {
    final sortedCategories = reviews.keys.toList()
      ..sort((a, b) => reviews[b]!.length.compareTo(reviews[a]!.length));

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            'My Reviews',
            style: GoogleFonts.openSans(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        const SizedBox(height: 8),
        ...sortedCategories.map((category) {
          return _buildCategorySection(category, reviews[category]!);
        }).toList(),
      ],
    );
  }

  Widget _buildCategorySection(String category, List<QueryDocumentSnapshot> reviews) {
    // Clean up category (extract primary type)
    String cleanCategory = category;
    if (category.contains(',')) {
      cleanCategory = category.split(',').first.trim();
    }

    final categoryIcon = PlaceTypeHelper.getIcon(cleanCategory);
    final categoryName = PlaceTypeHelper.getFriendlyName(cleanCategory);
    final categoryColor = PlaceTypeHelper.getCategoryColor(cleanCategory);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          childrenPadding: const EdgeInsets.only(bottom: 8),
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: categoryColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              categoryIcon,
              color: categoryColor,
              size: 24,
            ),
          ),
          title: Text(
            categoryName,
            style: GoogleFonts.openSans(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          subtitle: Text(
            '${reviews.length} ${reviews.length == 1 ? 'review' : 'reviews'}',
            style: GoogleFonts.openSans(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          children: reviews.map((review) {
            final data = review.data() as Map<String, dynamic>;
            return _buildReviewCard(data);
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildReviewCard(Map<String, dynamic> reviewData) {
    final placeName = reviewData['placeName'] ?? 'Unknown Place';
    final placePhoto = reviewData['placePhoto'] ?? '';
    final overallRating = reviewData['overallRating'] ?? 0;
    final textReview = reviewData['textReview'] ?? '';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey.shade200),
        ),
        child: InkWell(
          onTap: () {
            // Navigate to place details
            // You can implement navigation to the place details page here
            _showReviewDetails(reviewData);
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Place photo
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: placePhoto.isNotEmpty
                      ? Image.network(
                          placePhoto,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 60,
                              height: 60,
                              color: Colors.grey.shade300,
                              child: Icon(
                                Icons.image_not_supported,
                                color: Colors.grey.shade500,
                                size: 30,
                              ),
                            );
                          },
                        )
                      : Container(
                          width: 60,
                          height: 60,
                          color: Colors.grey.shade300,
                          child: Icon(
                            Icons.place,
                            color: Colors.grey.shade500,
                            size: 30,
                          ),
                        ),
                ),
                const SizedBox(width: 12),
                // Place info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        placeName,
                        style: GoogleFonts.openSans(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          ...List.generate(5, (index) {
                            return Icon(
                              index < overallRating ? Icons.star : Icons.star_border,
                              size: 16,
                              color: index < overallRating
                                  ? AppTheme.primaryColor
                                  : Colors.grey.shade400,
                            );
                          }),
                          const SizedBox(width: 4),
                          Text(
                            '$overallRating/5',
                            style: GoogleFonts.openSans(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                      if (textReview.isNotEmpty && textReview != '[Skipped]') ...[
                        const SizedBox(height: 4),
                        Text(
                          textReview,
                          style: GoogleFonts.openSans(
                            fontSize: 13,
                            color: Colors.grey.shade700,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showReviewDetails(Map<String, dynamic> reviewData) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.all(24),
          child: ListView(
            controller: scrollController,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                reviewData['placeName'] ?? 'Unknown Place',
                style: GoogleFonts.openSans(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  ...List.generate(5, (index) {
                    return Icon(
                      index < (reviewData['overallRating'] ?? 0)
                          ? Icons.star
                          : Icons.star_border,
                      size: 28,
                      color: index < (reviewData['overallRating'] ?? 0)
                          ? AppTheme.primaryColor
                          : Colors.grey.shade400,
                    );
                  }),
                ],
              ),
              const SizedBox(height: 20),
              if (reviewData['textReview'] != null &&
                  reviewData['textReview'] != '[Skipped]') ...[
                Text(
                  'Review',
                  style: GoogleFonts.openSans(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  reviewData['textReview'],
                  style: GoogleFonts.openSans(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 20),
              ],
              if (reviewData['accommodations'] != null) ...[
                Text(
                  'Accommodations Rated',
                  style: GoogleFonts.openSans(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: (reviewData['accommodations'] as Map).entries.map((entry) {
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
                            entry.key,
                            style: GoogleFonts.openSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.primaryColorDark,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${entry.value}/5',
                            style: GoogleFonts.openSans(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryColorDark,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
