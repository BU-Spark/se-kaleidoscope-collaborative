import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kaleidoscope_collaborative/services/favorites_service.dart';

/// Provider for managing favorites state
class FavoritesProvider with ChangeNotifier {
  final FavoritesService _favoritesService;
  final Set<String> _favoriteIds = {};
  bool _isLoading = false;

  FavoritesProvider(this._favoritesService);

  Set<String> get favoriteIds => _favoriteIds;
  bool get isLoading => _isLoading;

  /// Check if a place is favorited
  bool isFavorite(String placeId) {
    return _favoriteIds.contains(placeId);
  }

  /// Load user's favorites
  Future<void> loadFavorites(String userId) async {
    if (userId.isEmpty) {
      _favoriteIds.clear();
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final favorites = await _favoritesService.getUserFavorites(userId);
      _favoriteIds.clear();
      for (var fav in favorites) {
        _favoriteIds.add(fav['placeId'] as String);
      }
    } catch (e) {
      print('Error loading favorites: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Toggle favorite status
  Future<void> toggleFavorite({
    required String userId,
    required String placeId,
    required String placeName,
    required String placePhoto,
    required String placePrimaryType,
  }) async {
    if (userId.isEmpty) {
      throw Exception('User not logged in');
    }

    final wasFavorite = _favoriteIds.contains(placeId);

    // Optimistic update
    if (wasFavorite) {
      _favoriteIds.remove(placeId);
    } else {
      _favoriteIds.add(placeId);
    }
    notifyListeners();

    try {
      if (wasFavorite) {
        await _favoritesService.removeFavorite(
          userId: userId,
          placeId: placeId,
        );
      } else {
        await _favoritesService.addFavorite(
          userId: userId,
          placeId: placeId,
          placeName: placeName,
          placePhoto: placePhoto,
          placePrimaryType: placePrimaryType,
        );
      }
    } catch (e) {
      // Revert on error
      if (wasFavorite) {
        _favoriteIds.add(placeId);
      } else {
        _favoriteIds.remove(placeId);
      }
      notifyListeners();
      rethrow;
    }
  }

  /// Clear all favorites (for logout)
  void clear() {
    _favoriteIds.clear();
    notifyListeners();
  }
}

