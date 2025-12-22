import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kaleidoscope_collaborative/config/app_theme.dart';
import 'package:kaleidoscope_collaborative/screens/cloud_firestore_service.dart';
import 'package:kaleidoscope_collaborative/utils/place_type_helper.dart';
import 'package:kaleidoscope_collaborative/utils/photo_url_helper.dart';
import 'package:kaleidoscope_collaborative/finding_location_rating/search_page_1_0.dart';
import 'package:kaleidoscope_collaborative/services/unsplash_service.dart';

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
  int _refreshKey = 0;

  @override
  void initState() {
    super.initState();
    _firestoreService = CloudFirestoreService(FirebaseFirestore.instance);
  }

  void _refreshReviews() {
    setState(() {
      _refreshKey++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSearchBar(),
        Expanded(
          child: FutureBuilder<Map<String, List<QueryDocumentSnapshot>>>(
            key: ValueKey(_refreshKey),
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
          leading: SizedBox(
            width: 50,
            height: 50,
            child: _CategoryImageWidget(
              categoryName: categoryName,
              icon: categoryIcon,
              color: categoryColor,
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
            return _buildReviewCard(data, review.id);
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildReviewCard(Map<String, dynamic> reviewData, String reviewId) {
    final placeName = reviewData['placeName'] ?? 'Unknown Place';
    final placePhotoReference = reviewData['placePhoto'] ?? '';
    final overallRating = reviewData['overallRating'] ?? 0;
    final textReview = reviewData['textReview'] ?? '';
    
    // Construct the photo URL using the helper
    final photoUrl = PhotoUrlHelper.getPhotoUrl(placePhotoReference);

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
            _showReviewDetails(reviewData, reviewId);
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
                  child: PhotoUrlHelper.isValidPhotoReference(placePhotoReference)
                      ? Image.network(
                          photoUrl,
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

  void _showReviewDetails(Map<String, dynamic> reviewData, String reviewId) {
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
                const SizedBox(height: 20),
              ],
              // Edit and Delete buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _showEditReviewDialog(reviewData, reviewId);
                      },
                      icon: const Icon(Icons.edit, size: 20),
                      label: Text(
                        'Edit',
                        style: GoogleFonts.openSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.primaryColor,
                        side: const BorderSide(color: AppTheme.primaryColor, width: 2),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _showDeleteConfirmationDialog(reviewId);
                      },
                      icon: const Icon(Icons.delete, size: 20),
                      label: Text(
                        'Delete',
                        style: GoogleFonts.openSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade600,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).padding.bottom),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditReviewDialog(Map<String, dynamic> reviewData, String reviewId) {
    int overallRating = reviewData['overallRating'] ?? 0;
    String textReview = reviewData['textReview'] ?? '';
    Map<String, int> accommodations = reviewData['accommodations'] != null
        ? Map<String, int>.from(reviewData['accommodations'])
        : {};

    showDialog(
      context: context,
      builder: (context) => _EditReviewDialog(
        reviewId: reviewId,
        initialOverallRating: overallRating,
        initialTextReview: textReview,
        initialAccommodations: accommodations,
        placeName: reviewData['placeName'] ?? 'Unknown Place',
        onSave: () {
          _refreshReviews();
        },
        firestoreService: _firestoreService,
      ),
    );
  }

  void _showDeleteConfirmationDialog(String reviewId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Delete Review',
          style: GoogleFonts.openSans(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        content: Text(
          'Are you sure you want to delete this review? This action cannot be undone.',
          style: GoogleFonts.openSans(
            fontSize: 14,
            color: Colors.grey.shade700,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.openSans(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await _firestoreService.deleteUserReview(reviewId);
                _refreshReviews();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Review deleted successfully',
                        style: GoogleFonts.openSans(),
                      ),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Error deleting review: ${e.toString()}',
                        style: GoogleFonts.openSans(),
                      ),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Delete',
              style: GoogleFonts.openSans(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EditReviewDialog extends StatefulWidget {
  final String reviewId;
  final int initialOverallRating;
  final String initialTextReview;
  final Map<String, int> initialAccommodations;
  final String placeName;
  final VoidCallback onSave;
  final CloudFirestoreService firestoreService;

  const _EditReviewDialog({
    required this.reviewId,
    required this.initialOverallRating,
    required this.initialTextReview,
    required this.initialAccommodations,
    required this.placeName,
    required this.onSave,
    required this.firestoreService,
  });

  @override
  _EditReviewDialogState createState() => _EditReviewDialogState();
}

class _EditReviewDialogState extends State<_EditReviewDialog> {
  late int _overallRating;
  late TextEditingController _textReviewController;
  late Map<String, int> _accommodations;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _overallRating = widget.initialOverallRating;
    _textReviewController = TextEditingController(text: widget.initialTextReview);
    _accommodations = Map<String, int>.from(widget.initialAccommodations);
  }

  @override
  void dispose() {
    _textReviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 700),
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Edit Review',
                      style: GoogleFonts.openSans(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                    color: Colors.grey.shade600,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                widget.placeName,
                style: GoogleFonts.openSans(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Overall Rating',
                style: GoogleFonts.openSans(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: List.generate(5, (index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _overallRating = index + 1;
                      });
                    },
                    child: Icon(
                      index < _overallRating ? Icons.star : Icons.star_border,
                      size: 40,
                      color: index < _overallRating
                          ? AppTheme.primaryColor
                          : Colors.grey.shade400,
                    ),
                  );
                }),
              ),
              const SizedBox(height: 24),
              Text(
                'Text Review',
                style: GoogleFonts.openSans(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _textReviewController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Write your review...',
                  hintStyle: GoogleFonts.openSans(
                    color: Colors.grey.shade400,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppTheme.primaryColor, width: 2),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                ),
                style: GoogleFonts.openSans(),
              ),
              if (_accommodations.isNotEmpty) ...[
                const SizedBox(height: 24),
                Text(
                  'Accommodations',
                  style: GoogleFonts.openSans(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                ..._accommodations.keys.map((key) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          key,
                          style: GoogleFonts.openSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: List.generate(5, (index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _accommodations[key] = index + 1;
                                });
                              },
                              child: Icon(
                                index < _accommodations[key]!
                                    ? Icons.star
                                    : Icons.star_border,
                                size: 32,
                                color: index < _accommodations[key]!
                                    ? AppTheme.primaryColor
                                    : Colors.grey.shade400,
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isSaving ? null : () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.grey.shade700,
                        side: BorderSide(color: Colors.grey.shade300),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.openSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _saveReview,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isSaving
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text(
                              'Save',
                              style: GoogleFonts.openSans(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveReview() async {
    setState(() {
      _isSaving = true;
    });

    try {
      Map<String, dynamic> updateData = {
        'overallRating': _overallRating,
        'textReview': _textReviewController.text.trim().isEmpty
            ? '[Skipped]'
            : _textReviewController.text.trim(),
      };

      if (_accommodations.isNotEmpty) {
        updateData['accommodations'] = _accommodations;
      }

      await widget.firestoreService.updateUserReview(widget.reviewId, updateData);

      if (mounted) {
        Navigator.pop(context);
        widget.onSave();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Review updated successfully',
              style: GoogleFonts.openSans(),
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error updating review: ${e.toString()}',
              style: GoogleFonts.openSans(),
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    }
  }
}

/// Widget that displays category image from Unsplash with icon fallback
/// Similar to the one in home_page.dart but sized for ExpansionTile
class _CategoryImageWidget extends StatelessWidget {
  final String categoryName;
  final IconData icon;
  final Color color;

  const _CategoryImageWidget({
    required this.categoryName,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: UnsplashService.getCategoryImageUrl(categoryName),
      builder: (context, snapshot) {
        // If image is loading or not available, show icon fallback
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              ),
            ),
          );
        }

        final imageUrl = snapshot.data;

        // If we have an image URL, display it
        if (imageUrl != null) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    // If image fails to load, show icon fallback
                    return _buildIconFallback();
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(color),
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                // Add a subtle gradient overlay
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.1),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        // Fallback to icon if no image available
        return _buildIconFallback();
      },
    );
  }

  Widget _buildIconFallback() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        icon,
        color: color,
        size: 24,
      ),
    );
  }
}
