import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kaleidoscope_collaborative/providers/favorites_provider.dart';
import 'package:kaleidoscope_collaborative/config/app_theme.dart';

/// Reusable favorite button widget
class FavoriteButton extends StatelessWidget {
  final String placeId;
  final String placeName;
  final String placePhoto;
  final String placePrimaryType;
  final double size;
  final Color? activeColor;
  final Color? inactiveColor;

  const FavoriteButton({
    Key? key,
    required this.placeId,
    required this.placeName,
    required this.placePhoto,
    required this.placePrimaryType,
    this.size = 24,
    this.activeColor,
    this.inactiveColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoritesProvider>(
      builder: (context, favoritesProvider, child) {
        final isFavorite = favoritesProvider.isFavorite(placeId);

        return Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withValues(alpha: 0.9),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _handleFavoriteToggle(context, favoritesProvider),
              customBorder: const CircleBorder(),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  size: size,
                  color: isFavorite
                      ? (activeColor ?? Colors.red)
                      : (inactiveColor ?? Colors.grey.shade600),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _handleFavoriteToggle(
    BuildContext context,
    FavoritesProvider favoritesProvider,
  ) async {
    // Check if user is logged in using Firebase Auth
    final currentUser = FirebaseAuth.instance.currentUser;
    
    print('=== FAVORITE BUTTON DEBUG ===');
    print('Firebase User: ${currentUser?.email ?? "null"}');
    print('Is Logged In: ${currentUser != null}');
    print('============================');
    
    if (currentUser == null || currentUser.email == null) {
      print('User not logged in - showing login dialog');
      _showLoginDialog(context);
      return;
    }
    
    print('User is logged in - proceeding with favorite toggle');

    try {
      await favoritesProvider.toggleFavorite(
        userId: currentUser.email!,
        placeId: placeId,
        placeName: placeName,
        placePhoto: placePhoto,
        placePrimaryType: placePrimaryType,
      );

      // Show feedback
      if (context.mounted) {
        final isFavorite = favoritesProvider.isFavorite(placeId);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isFavorite
                  ? 'Added to favorites!'
                  : 'Removed from favorites',
            ),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            backgroundColor: isFavorite ? AppTheme.primaryColor : Colors.grey.shade700,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  void _showLoginDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(
                Icons.favorite,
                color: AppTheme.primaryColor,
                size: 28,
              ),
              const SizedBox(width: 12),
              const Text(
                'Login Required',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: const Text(
            'Please login or sign up to add places to your favorites.',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 16,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Navigate to login page
                // TODO: Implement navigation to login page
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Login page navigation not yet implemented'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text(
                'Login / Sign Up',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

