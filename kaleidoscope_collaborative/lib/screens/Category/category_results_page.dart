import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kaleidoscope_collaborative/config/app_theme.dart';
import 'package:kaleidoscope_collaborative/screens/cloud_firestore_service.dart';
import 'package:kaleidoscope_collaborative/utils/place_type_helper.dart';
import 'package:kaleidoscope_collaborative/utils/photo_url_helper.dart';
import 'package:kaleidoscope_collaborative/widgets/favorite_button.dart';
import 'package:kaleidoscope_collaborative/finding_location_rating/search_page_1_3.dart';
import 'package:kaleidoscope_collaborative/models/profile.dart';
import 'package:kaleidoscope_collaborative/config/globals.dart' as globals;

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

class _CategoryResultsPageState extends State<CategoryResultsPage>
    with SingleTickerProviderStateMixin {
  late CloudFirestoreService _firestoreService;
  late TabController _tabController;
  
  ProfileData? _userProfile;
  bool _isLoadingProfile = true;
  bool _hasProfile = false;
  
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _firestoreService = CloudFirestoreService(FirebaseFirestore.instance);
    _tabController = TabController(length: 2, vsync: this);
    _loadUserProfile();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// Load user's profile to check if they have accessibility preferences
  Future<void> _loadUserProfile() async {
    try {
      final user = _auth.currentUser;
      
      if (user == null || user.email == null) {
        setState(() {
          _isLoadingProfile = false;
          _hasProfile = false;
        });
        return;
      }

      DocumentSnapshot profileSnapshot = await FirebaseFirestore.instance
          .collection('ProfileData')
          .doc(user.email)
          .get();

      if (profileSnapshot.exists) {
        ProfileData profileData = ProfileData.fromFirestore(
            profileSnapshot.data() as Map<String, dynamic>);
        
        setState(() {
          _userProfile = profileData;
          _hasProfile = profileData.accommodations.isNotEmpty;
          _isLoadingProfile = false;
        });
      } else {
        setState(() {
          _isLoadingProfile = false;
          _hasProfile = false;
        });
      }
    } catch (e) {
      print('Error loading user profile: $e');
      setState(() {
        _isLoadingProfile = false;
        _hasProfile = false;
      });
    }
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
        bottom: _isLoadingProfile
            ? null
            : (_hasProfile
                ? TabBar(
                    controller: _tabController,
                    labelColor: AppTheme.primaryColorDark,
                    unselectedLabelColor: Colors.grey,
                    labelStyle: GoogleFonts.openSans(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    unselectedLabelStyle: GoogleFonts.openSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    indicatorSize: TabBarIndicatorSize.label,
                    indicator: const UnderlineTabIndicator(
                      borderSide: BorderSide(
                        color: AppTheme.primaryColorDark,
                        width: 3.0,
                      ),
                      insets: EdgeInsets.symmetric(horizontal: 4.0),
                    ),
                    tabs: const [
                      Tab(text: 'Recommended'),
                      Tab(text: 'All Results'),
                    ],
                  )
                : null),
      ),
      body: _isLoadingProfile
          ? _buildLoadingState()
          : (_hasProfile
              ? TabBarView(
                  controller: _tabController,
                  children: [
                    _buildRecommendedTab(),
                    _buildAllResultsTab(),
                  ],
                )
              : _buildAllResultsTab()),
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
            'Loading...',
            style: GoogleFonts.openSans(
              fontSize: 16,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }

  /// Recommended tab - shows places filtered by user's profile and sorted by proximity
  Widget _buildRecommendedTab() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _getRecommendedPlaces(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingState();
        }

        if (snapshot.hasError) {
          return _buildErrorState(snapshot.error.toString());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return _buildEmptyRecommendedState();
        }

        return _buildResultsGrid(snapshot.data!);
      },
    );
  }

  /// All results tab - shows all reviews for the category
  Widget _buildAllResultsTab() {
    return FutureBuilder<List<Map<String, dynamic>>>(
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
    );
  }

  Future<List<Map<String, dynamic>>> _getRecommendedPlaces() async {
    if (_userProfile == null || _userProfile!.accommodations.isEmpty) {
      return [];
    }

    // Get all types that belong to this category
    final categoryGroup = PlaceTypeHelper.getCategoryGroup(widget.categoryType);
    List<String> types = [];

    if (categoryGroup != null) {
      types = PlaceTypeHelper.getTypesForCategory(categoryGroup);
    } else {
      types = [widget.categoryType];
    }

    // Get places filtered by user's accommodations
    List<Map<String, dynamic>> places = await _firestoreService
        .getReviewedPlacesByAccommodations(types, _userProfile!.accommodations);

    // Filter by 50-mile radius and sort by proximity if location is available
    if (globals.userLatitude != null && globals.userLongitude != null) {
      places = _firestoreService.sortPlacesByDistance(
        places,
        globals.userLatitude!,
        globals.userLongitude!,
      );
      
      // Filter to only include places within 50 miles (80.47 km)
      places = places.where((place) {
        double distance = place['distance'] ?? double.infinity;
        return distance <= 80.47; // 50 miles in kilometers
      }).toList();
    }

    return places;
  }

  Future<List<Map<String, dynamic>>> _getReviewedPlacesForCategory() async {
    // Get all types that belong to this category
    final categoryGroup = PlaceTypeHelper.getCategoryGroup(widget.categoryType);
    
    List<Map<String, dynamic>> places;

    if (categoryGroup != null) {
      // Get all types in this category group
      final types = PlaceTypeHelper.getTypesForCategory(categoryGroup);
      places = await _firestoreService.getReviewedPlacesByCategoryGroup(types);
    } else {
      // Single type search
      places = await _firestoreService.getReviewedPlacesByCategory(widget.categoryType);
    }
    
    // Filter by 50-mile radius if location is available
    if (globals.userLatitude != null && globals.userLongitude != null) {
      // Calculate distance for each place
      places = _firestoreService.sortPlacesByDistance(
        places,
        globals.userLatitude!,
        globals.userLongitude!,
      );
      
      // Filter to only include places within 50 miles (80.47 km)
      places = places.where((place) {
        double distance = place['distance'] ?? double.infinity;
        return distance <= 80.47; // 50 miles in kilometers
      }).toList();
    }
    
    return places;
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
              color: PlaceTypeHelper.getCategoryColor(widget.categoryType)
                  .withValues(alpha: 0.5),
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

  Widget _buildEmptyRecommendedState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.recommend_outlined,
              size: 80,
              color: AppTheme.primaryColor.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No Recommendations Yet',
              style: GoogleFonts.openSans(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColorDark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'We couldn\'t find any ${widget.categoryName.toLowerCase()} that match your accessibility preferences.',
              textAlign: TextAlign.center,
              style: GoogleFonts.openSans(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Try checking the "All Results" tab to see all available places.',
              textAlign: TextAlign.center,
              style: GoogleFonts.openSans(
                fontSize: 14,
                color: Colors.grey.shade500,
                fontStyle: FontStyle.italic,
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${places.length} ${places.length == 1 ? 'place' : 'places'} found',
                style: GoogleFonts.openSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700,
                ),
              ),
              if (_userProfile != null) ...[
                const SizedBox(height: 4),
                Text(
                  'Within 50 miles of your location',
                  style: GoogleFonts.openSans(
                    fontSize: 14,
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
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
        _navigateToPlaceDetails(placeData);
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Limit text scale factor to prevent overflow in cards
          final textScaleFactor =
              MediaQuery.of(context).textScaleFactor.clamp(1.0, 1.3);

          return Card(
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
                                      value: loadingProgress.expectedTotalBytes !=
                                              null
                                          ? loadingProgress
                                                  .cumulativeBytesLoaded /
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
                          placePrimaryType:
                              placeData['placePrimaryType'] ?? 'place',
                          size: 20,
                        ),
                      ),
                      // Review count badge with constrained text scaling
                      Positioned(
                        top: 8,
                        right: 8,
                        child: MediaQuery(
                          data: MediaQuery.of(context).copyWith(
                            textScaleFactor: textScaleFactor,
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
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
                      ),
                    ],
                  ),
                ),
                // Place info with constrained text scaling
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    color: Colors.white,
                    child: MediaQuery(
                      data: MediaQuery.of(context).copyWith(
                        textScaleFactor: textScaleFactor,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              placeName,
                              style: GoogleFonts.openSans(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
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
                ),
              ],
            ),
          );
        },
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
