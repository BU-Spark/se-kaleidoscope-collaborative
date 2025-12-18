import 'package:cloud_firestore/cloud_firestore.dart';

class CloudFirestoreService {
  final FirebaseFirestore firestore;

  CloudFirestoreService(this.firestore);

  /*Firestore counts one document as one read, so make sure to limit results
  with queries and limit() as much as possible.
  https://stackoverflow.com/questions/50887442/cloud-firestore-how-is-read-calculated
  */

  Future<String> addUserData(Map<String, dynamic> data) async {
    // Add a new document with a generated ID
    final document = firestore.collection('User').add(data);
    return document.then((value) => value.id);
  }

  Future<String> addUserRating(Map<String, dynamic> data) async {
    // Add a new document with a generated ID
    final document = firestore.collection('UserRating').add(data);
    return document.then((value) => value.id);
  }

  Future<String> addUserReview(Map<String, dynamic> data) async {
    // Add a new document with a generated ID
    final document = firestore.collection('UserReview').add(data);
    return document.then((value) => value.id);
  }

  /// Get all reviews by a specific user, ordered by timestamp (most recent first)
  Future<List<QueryDocumentSnapshot>> getUserReviews(String userId) async {
    try {
      QuerySnapshot querySnapshot = await firestore
          .collection('UserReview')
          .where('userID', isEqualTo: userId)
          .orderBy('timestamp', descending: true)
          .limit(50)
          .get();
      return querySnapshot.docs;
    } catch (e) {
      print('Error getting user reviews: $e');
      // If orderBy fails (no index), try without ordering
      QuerySnapshot querySnapshot = await firestore
          .collection('UserReview')
          .where('userID', isEqualTo: userId)
          .limit(50)
          .get();
      return querySnapshot.docs;
    }
  }

  /// Get user's reviews grouped by category type
  Future<Map<String, List<QueryDocumentSnapshot>>> getUserReviewsByCategory(String userId) async {
    try {
      final reviews = await getUserReviews(userId);

      print('DEBUG: Found ${reviews.length} reviews for user: $userId');

      // Group reviews by category
      Map<String, List<QueryDocumentSnapshot>> grouped = {};
      for (var doc in reviews) {
        final data = doc.data() as Map<String, dynamic>;
        print('DEBUG: Review data: ${data.keys.toList()}');

        String category = data['placePrimaryType'] ?? 'Other';

        // If category is 'N/A' or empty, try to get it from other fields
        if (category == 'N/A' || category.isEmpty) {
          category = 'Other';
        }

        // Clean up the category (extract primary type if it's a comma-separated list)
        if (category.contains(',')) {
          category = category.split(',').first.trim();
        }

        if (!grouped.containsKey(category)) {
          grouped[category] = [];
        }
        grouped[category]!.add(doc);
      }

      print('DEBUG: Grouped into ${grouped.length} categories: ${grouped.keys.toList()}');

      return grouped;
    } catch (e) {
      print('Error grouping reviews by category: $e');
      return {};
    }
  }

  /// Get all reviewed places in a specific category
  /// Returns unique places (deduplicated by placeID) that have been reviewed
  Future<List<Map<String, dynamic>>> getReviewedPlacesByCategory(String category) async {
    try {
      QuerySnapshot querySnapshot = await firestore
          .collection('UserReview')
          .where('placePrimaryType', isEqualTo: category)
          .get();

      // Deduplicate by placeID and collect place information
      Map<String, Map<String, dynamic>> uniquePlaces = {};
      for (var doc in querySnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        String placeId = data['placeID'] ?? '';

        if (placeId.isNotEmpty && !uniquePlaces.containsKey(placeId)) {
          uniquePlaces[placeId] = {
            'placeID': placeId,
            'placeName': data['placeName'] ?? 'Unknown Place',
            'placePhoto': data['placePhoto'] ?? '',
            'placePrimaryType': data['placePrimaryType'] ?? category,
            'reviewCount': 1,
            'averageRating': (data['overallRating'] ?? 0).toDouble(),
          };
        } else if (placeId.isNotEmpty) {
          // Update average rating and review count
          uniquePlaces[placeId]!['reviewCount'] = (uniquePlaces[placeId]!['reviewCount'] as int) + 1;
          double currentAvg = uniquePlaces[placeId]!['averageRating'] as double;
          int count = uniquePlaces[placeId]!['reviewCount'] as int;
          double newRating = (data['overallRating'] ?? 0).toDouble();
          uniquePlaces[placeId]!['averageRating'] = ((currentAvg * (count - 1)) + newRating) / count;
        }
      }

      return uniquePlaces.values.toList();
    } catch (e) {
      print('Error getting reviewed places by category: $e');
      return [];
    }
  }

  /// Get all reviewed places that match any of the given category types
  /// Useful for category groups (e.g., all types of restaurants)
  Future<List<Map<String, dynamic>>> getReviewedPlacesByCategoryGroup(List<String> categoryTypes) async {
    try {
      // Collect all reviews for the category types
      List<Map<String, dynamic>> allPlaces = [];

      for (String category in categoryTypes) {
        final places = await getReviewedPlacesByCategory(category);
        allPlaces.addAll(places);
      }

      // Deduplicate across all categories
      Map<String, Map<String, dynamic>> uniquePlaces = {};
      for (var place in allPlaces) {
        String placeId = place['placeID'] ?? '';
        if (placeId.isNotEmpty && !uniquePlaces.containsKey(placeId)) {
          uniquePlaces[placeId] = place;
        } else if (placeId.isNotEmpty) {
          // Combine review counts and ratings
          int existingCount = uniquePlaces[placeId]!['reviewCount'] as int;
          int newCount = place['reviewCount'] as int;
          double existingAvg = uniquePlaces[placeId]!['averageRating'] as double;
          double newAvg = place['averageRating'] as double;

          uniquePlaces[placeId]!['reviewCount'] = existingCount + newCount;
          uniquePlaces[placeId]!['averageRating'] =
              ((existingAvg * existingCount) + (newAvg * newCount)) / (existingCount + newCount);
        }
      }

      return uniquePlaces.values.toList();
    } catch (e) {
      print('Error getting reviewed places by category group: $e');
      return [];
    }
  }

  /// Get review count for a specific category
  Future<int> getCategoryReviewCount(String userId, String category) async {
    try {
      QuerySnapshot querySnapshot = await firestore
          .collection('UserReview')
          .where('userID', isEqualTo: userId)
          .where('placePrimaryType', isEqualTo: category)
          .get();

      return querySnapshot.docs.length;
    } catch (e) {
      print('Error getting category review count: $e');
      return 0;
    }
  }

  /// Update an existing review by document ID
  Future<void> updateUserReview(String reviewId, Map<String, dynamic> data) async {
    try {
      await firestore.collection('UserReview').doc(reviewId).update({
        ...data,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error updating review: $e');
      rethrow;
    }
  }

  /// Delete a review by document ID
  Future<void> deleteUserReview(String reviewId) async {
    try {
      await firestore.collection('UserReview').doc(reviewId).delete();
    } catch (e) {
      print('Error deleting review: $e');
      rethrow;
    }
  }

  /// Get all unique category groups from reviews
  /// Returns a map of category group name to review count
  /// Groups Google Places API types into category groups (e.g., Restaurant, Fitness, etc.)
  Future<Map<String, int>> getAvailableCategoryGroups() async {
    try {
      // Get all reviews (limit to reasonable number for performance)
      QuerySnapshot querySnapshot = await firestore
          .collection('UserReview')
          .limit(1000) // Adjust based on your needs
          .get();

      // Count reviews by category group
      Map<String, int> categoryCounts = {};
      
      for (var doc in querySnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        String placeType = data['placePrimaryType'] ?? '';
        
        // Clean up the type
        if (placeType.isEmpty || placeType == 'N/A') {
          continue;
        }
        
        // Extract primary type if it's comma-separated
        if (placeType.contains(',')) {
          placeType = placeType.split(',').first.trim();
        }
        
        placeType = placeType.toLowerCase().trim();
        
        // Map to category group using PlaceTypeHelper logic
        // We'll do this in the calling code to avoid circular dependency
        // For now, use the type as-is and group in the UI layer
        if (!categoryCounts.containsKey(placeType)) {
          categoryCounts[placeType] = 0;
        }
        categoryCounts[placeType] = categoryCounts[placeType]! + 1;
      }

      return categoryCounts;
    } catch (e) {
      print('Error getting available category groups: $e');
      return {};
    }
  }
}
