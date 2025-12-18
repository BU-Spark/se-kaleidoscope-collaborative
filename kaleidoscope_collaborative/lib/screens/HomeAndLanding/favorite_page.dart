import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kaleidoscope_collaborative/config/app_theme.dart';
import 'package:kaleidoscope_collaborative/services/favorites_service.dart';
import 'package:kaleidoscope_collaborative/utils/photo_url_helper.dart';
import 'package:kaleidoscope_collaborative/widgets/favorite_button.dart';
import 'package:kaleidoscope_collaborative/finding_location_rating/search_page_1_3.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  late FavoritesService _favoritesService;

  @override
  void initState() {
    super.initState();
    _favoritesService = FavoritesService(FirebaseFirestore.instance);
  }

  @override
  Widget build(BuildContext context) {
    // Check if user is logged in using Firebase Auth
    final currentUser = FirebaseAuth.instance.currentUser;
    
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(
          'Favorite',
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
      body: currentUser == null || currentUser.email == null
          ? _buildNotLoggedInState()
          : StreamBuilder<List<Map<String, dynamic>>>(
              stream: _favoritesService.getFavoritesStream(currentUser.email!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return _buildLoadingState();
                }

                if (snapshot.hasError) {
                  return _buildErrorState();
                }

                final favorites = snapshot.data ?? [];

                if (favorites.isEmpty) {
                  return _buildEmptyState();
                }

                return _buildFavoritesList(favorites);
              },
            ),
    );
  }

  Widget _buildNotLoggedInState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              size: 80,
              color: AppTheme.primaryColor.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'Login Required',
              style: GoogleFonts.openSans(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColorDark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please login to view your favorites',
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
            'Loading favorites...',
            style: GoogleFonts.openSans(
              fontSize: 16,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'Error loading favorites',
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
              Icons.favorite_outline,
              size: 80,
              color: AppTheme.primaryColor.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No Favorites Yet',
              style: GoogleFonts.openSans(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColorDark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Start adding places to your favorites!',
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

  Widget _buildFavoritesList(List<Map<String, dynamic>> favorites) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: favorites.length,
      itemBuilder: (context, index) {
        return _buildFavoriteCard(favorites[index]);
      },
    );
  }

  Widget _buildFavoriteCard(Map<String, dynamic> favorite) {
    final placeName = favorite['placeName'] ?? 'Unknown Place';
    final placePhoto = favorite['placePhoto'] ?? '';
    final placeId = favorite['placeId'] ?? '';
    final placePrimaryType = favorite['placePrimaryType'] ?? 'place';
    final photoUrl = PhotoUrlHelper.getPhotoUrl(placePhoto);

    return GestureDetector(
      onTap: () {
        // Navigate to place details
        final result = {
          'name': placeName,
          'place_id': placeId,
          'photo': placePhoto,
        };

        final placeDetails = {
          'name': placeName,
          'place_id': placeId,
          'photo': placePhoto,
          'primary_type': placePrimaryType,
        };

        final currentUser = FirebaseAuth.instance.currentUser;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SearchPage1_3(
              result: result,
              placeDetails: placeDetails,
              name: currentUser?.email ?? '',
            ),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            // Photo
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
              child: PhotoUrlHelper.isValidPhotoReference(placePhoto)
                  ? Image.network(
                      photoUrl,
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 120,
                          height: 120,
                          color: Colors.grey.shade300,
                          child: Icon(
                            Icons.image_not_supported,
                            size: 40,
                            color: Colors.grey.shade500,
                          ),
                        );
                      },
                    )
                  : Container(
                      width: 120,
                      height: 120,
                      color: Colors.grey.shade300,
                      child: Icon(
                        Icons.place,
                        size: 40,
                        color: Colors.grey.shade500,
                      ),
                    ),
            ),
            // Details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
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
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      placePrimaryType,
                      style: GoogleFonts.openSans(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Favorite button
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: FavoriteButton(
                placeId: placeId,
                placeName: placeName,
                placePhoto: placePhoto,
                placePrimaryType: placePrimaryType,
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
