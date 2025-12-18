import 'package:cloud_firestore/cloud_firestore.dart';

/// Service to manage user favorites in Firestore
class FavoritesService {
  final FirebaseFirestore _firestore;

  FavoritesService(this._firestore);

  /// Add a place to user's favorites
  Future<void> addFavorite({
    required String userId,
    required String placeId,
    required String placeName,
    required String placePhoto,
    required String placePrimaryType,
  }) async {
    try {
      await _firestore.collection('Favorites').add({
        'userId': userId,
        'placeId': placeId,
        'placeName': placeName,
        'placePhoto': placePhoto,
        'placePrimaryType': placePrimaryType,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error adding favorite: $e');
      rethrow;
    }
  }

  /// Remove a place from user's favorites
  Future<void> removeFavorite({
    required String userId,
    required String placeId,
  }) async {
    try {
      final querySnapshot = await _firestore
          .collection('Favorites')
          .where('userId', isEqualTo: userId)
          .where('placeId', isEqualTo: placeId)
          .get();

      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      print('Error removing favorite: $e');
      rethrow;
    }
  }

  /// Check if a place is in user's favorites
  Future<bool> isFavorite({
    required String userId,
    required String placeId,
  }) async {
    try {
      final querySnapshot = await _firestore
          .collection('Favorites')
          .where('userId', isEqualTo: userId)
          .where('placeId', isEqualTo: placeId)
          .limit(1)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking favorite: $e');
      return false;
    }
  }

  /// Get all favorites for a user
  Future<List<Map<String, dynamic>>> getUserFavorites(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection('Favorites')
          .where('userId', isEqualTo: userId)
          .orderBy('timestamp', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => {
                'id': doc.id,
                ...doc.data(),
              })
          .toList();
    } catch (e) {
      // Check if it's an index error
      final errorString = e.toString();
      if (errorString.contains('index') || errorString.contains('failed-precondition')) {
        // Silently fallback - index will be created automatically by Firebase
        // or user can create it using the link in the error message
      } else {
        print('Error getting favorites: $e');
      }
      
      // If orderBy fails (no index), try without ordering
      try {
        final querySnapshot = await _firestore
            .collection('Favorites')
            .where('userId', isEqualTo: userId)
            .get();

        // Sort manually in memory
        final favorites = querySnapshot.docs
            .map((doc) => {
                  'id': doc.id,
                  ...doc.data(),
                })
            .toList();
        
        // Sort by timestamp descending if available
        favorites.sort((a, b) {
          final aTime = a['timestamp'] as Timestamp?;
          final bTime = b['timestamp'] as Timestamp?;
          if (aTime == null && bTime == null) return 0;
          if (aTime == null) return 1;
          if (bTime == null) return -1;
          return bTime.compareTo(aTime);
        });
        
        return favorites;
      } catch (e2) {
        print('Error getting favorites (fallback): $e2');
        return [];
      }
    }
  }

  /// Get stream of user's favorites for real-time updates
  Stream<List<Map<String, dynamic>>> getFavoritesStream(String userId) {
    return _firestore
        .collection('Favorites')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => {
                  'id': doc.id,
                  ...doc.data(),
                })
            .toList());
  }
}

