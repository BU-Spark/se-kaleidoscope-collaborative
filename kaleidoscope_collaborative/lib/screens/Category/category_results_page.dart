import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kaleidoscope_collaborative/config/app_theme.dart';
import 'package:kaleidoscope_collaborative/screens/cloud_firestore_service.dart';
import 'package:kaleidoscope_collaborative/utils/place_type_helper.dart';
import 'package:kaleidoscope_collaborative/utils/photo_url_helper.dart';
import 'package:kaleidoscope_collaborative/widgets/favorite_button.dart';
import 'package:kaleidoscope_collaborative/finding_location_rating/search_page_1_3.dart';

class CategoryResultsPage extends StatefulWidget {
  final String categoryType;
  final String categoryName;
  final String userName;

  const CategoryResultsPage({
    Key? key,
    required this.categoryType,
    required this.categoryName,
    required this.userName,
  }) : super(key: key);

  @override
  _CategoryResultsPageState createState() => _CategoryResultsPageState();
}

class _CategoryResultsPageState extends State<CategoryResultsPage> {
  late CloudFirestoreService _firestoreService;

  @override
  void initState() {
    super.initState();
    _firestoreService = CloudFirestoreService(FirebaseFirestore.instance);
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
          widget.categoryName,
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
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _getReviewedPlacesForCategory(),
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

          return _buildResultsGrid(snapshot.data!);
        },
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _getReviewedPlacesForCategory() async {
    // Get all types that belong to this category
    final categoryGroup = PlaceTypeHelper.getCategoryGroup(widget.categoryType);

    if (categoryGroup != null) {
      // Get all types in this category group
      final types = PlaceTypeHelper.getTypesForCategory(categoryGroup);
      return await _firestoreService.getReviewedPlacesByCategoryGroup(types);
    } else {
      // Single type search
      return await _firestoreService.getReviewedPlacesByCategory(widget.categoryType);
    }
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
            'Loading places...',
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
              'Error loading places',
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
              PlaceTypeHelper.getIcon(widget.categoryType),
              size: 80,
              color: PlaceTypeHelper.getCategoryColor(widget.categoryType).withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No ${widget.categoryName} Reviews',
              style: GoogleFonts.openSans(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColorDark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Be the first to review a ${widget.categoryName.toLowerCase()}!',
              textAlign: TextAlign.center,
              style: GoogleFonts.openSans(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsGrid(List<Map<String, dynamic>> places) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            '${places.length} ${places.length == 1 ? 'place' : 'places'} reviewed',
            style: GoogleFonts.openSans(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.75,
            ),
            itemCount: places.length,
            itemBuilder: (context, index) {
              return _buildPlaceCard(places[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceCard(Map<String, dynamic> placeData) {
    final placeName = placeData['placeName'] ?? 'Unknown Place';
    final placePhotoReference = placeData['placePhoto'] ?? '';
    final reviewCount = placeData['reviewCount'] ?? 0;
    final averageRating = (placeData['averageRating'] ?? 0.0).toDouble();
    
    // Construct the photo URL using the helper (handles both old and new formats)
    final photoUrl = PhotoUrlHelper.getPhotoUrl(placePhotoReference);

    return GestureDetector(
      onTap: () {
        // Navigate to place details
        // Note: We need to construct the full place details from the cached data
        _navigateToPlaceDetails(placeData);
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 3,
        shadowColor: AppTheme.primaryColor.withValues(alpha: 0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Place photo
            Expanded(
              flex: 3,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  PhotoUrlHelper.isValidPhotoReference(placePhotoReference)
                      ? Image.network(
                          photoUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey.shade300,
                              child: Icon(
                                Icons.image_not_supported,
                                size: 40,
                                color: Colors.grey.shade500,
                              ),
                            );
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
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
                        )
                      : Container(
                          color: Colors.grey.shade300,
                          child: Icon(
                            Icons.place,
                            size: 40,
                            color: Colors.grey.shade500,
                          ),
                        ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.3),
                        ],
                      ),
                    ),
                  ),
                  // Favorite button
                  Positioned(
                    top: 8,
                    left: 8,
                    child: FavoriteButton(
                      placeId: placeData['placeID'] ?? '',
                      placeName: placeName,
                      placePhoto: placePhotoReference,
                      placePrimaryType: placeData['placePrimaryType'] ?? 'place',
                      size: 20,
                    ),
                  ),
                  // Review count badge
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.rate_review,
                            size: 12,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '$reviewCount',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Place info
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.all(12),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      placeName,
                      style: GoogleFonts.openSans(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          size: 16,
                          color: AppTheme.primaryColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          averageRating.toStringAsFixed(1),
                          style: GoogleFonts.openSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToPlaceDetails(Map<String, dynamic> placeData) {
    // Construct result and placeDetails objects from cached data
    final result = {
      'name': placeData['placeName'],
      'place_id': placeData['placeID'],
      'photo': placeData['placePhoto'],
      'rating': placeData['averageRating'],
    };

    final placeDetails = {
      'name': placeData['placeName'],
      'place_id': placeData['placeID'],
      'photo': placeData['placePhoto'],
      'types': [placeData['placePrimaryType']],
      // Note: We don't have full details (address, phone, hours) from cached data
      // You might want to fetch these from Google Places API or store them in reviews
    };

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchPage1_3(
          result: result,
          placeDetails: placeDetails,
          name: widget.userName,
        ),
      ),
    );
  }
}
