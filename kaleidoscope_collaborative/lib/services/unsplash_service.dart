import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// Service to fetch images from Unsplash API
class UnsplashService {
  static const String _accessKey = 'rzL_y7cu3K1m2GAaiyHdpF6929gskn5jJ97qA6kEOjo';
  static const String _baseUrl = 'https://api.unsplash.com';
  static const String _cacheKey = 'unsplash_category_images';
  
  // In-memory cache for fast access
  static final Map<String, String> _imageCache = {};
  static bool _cacheLoaded = false;
  
  /// Initialize and load cache from persistent storage
  static Future<void> _loadCache() async {
    if (_cacheLoaded) return;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheJson = prefs.getString(_cacheKey);
      
      if (cacheJson != null) {
        final Map<String, dynamic> cacheData = json.decode(cacheJson);
        _imageCache.clear();
        cacheData.forEach((key, value) {
          _imageCache[key] = value as String;
        });
        print('Loaded ${_imageCache.length} cached Unsplash images');
      }
    } catch (e) {
      // Silently fail - in-memory cache will still work
      // This can happen if SharedPreferences isn't available yet (e.g., during hot reload)
      // The app will continue to work, just without persistent caching
    }
    
    _cacheLoaded = true;
  }
  
  /// Save cache to persistent storage
  static Future<void> _saveCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheJson = json.encode(_imageCache);
      await prefs.setString(_cacheKey, cacheJson);
      // Only print on success to avoid log spam
    } catch (e) {
      // Silently fail - in-memory cache will still work
      // This can happen if SharedPreferences isn't available yet
    }
  }
  
  /// Get an image URL for a category
  /// Returns null if image cannot be fetched (use icon fallback)
  static Future<String?> getCategoryImageUrl(String categoryName) async {
    // Load cache from storage if not already loaded
    await _loadCache();
    
    // Check cache first (persistent across app restarts)
    if (_imageCache.containsKey(categoryName)) {
      return _imageCache[categoryName];
    }
    
    try {
      // Map category names to better search terms for Unsplash
      final searchTerm = _getSearchTerm(categoryName);
      
      final url = Uri.parse(
        '$_baseUrl/search/photos?query=$searchTerm&per_page=1&orientation=landscape&client_id=$_accessKey'
      );
      
      final response = await http.get(url).timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          throw Exception('Request timeout');
        },
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'] as List?;
        
        if (results != null && results.isNotEmpty) {
          final imageUrl = results[0]['urls']['regular'] as String?;
          
          if (imageUrl != null) {
            // Cache the result in memory
            _imageCache[categoryName] = imageUrl;
            // Save to persistent storage (don't await to avoid blocking)
            _saveCache();
            return imageUrl;
          }
        }
      }
      
      // If API call fails or no results, return null (will use icon fallback)
      return null;
    } catch (e) {
      print('Error fetching Unsplash image for $categoryName: $e');
      return null;
    }
  }
  
  /// Map category names to better search terms for Unsplash
  static String _getSearchTerm(String categoryName) {
    // Map common category names to better search terms
    final searchTermMap = {
      'Restaurant': 'restaurant food dining',
      'Fitness': 'gym fitness workout',
      'Healthcare': 'hospital medical healthcare',
      'Shopping': 'shopping mall retail',
      'Entertainment': 'entertainment cinema theater',
      'Library': 'library books reading',
      'Parks': 'park nature outdoor',
      'Services': 'bank office business',
      'Café': 'coffee shop cafe',
      'Bar & Nightlife': 'bar nightlife drinks',
      'Bakery': 'bakery bread pastries',
      'Hospital': 'hospital medical',
      'Dentist': 'dentist dental clinic',
      'Doctor': 'doctor medical clinic',
      'Pharmacy': 'pharmacy drugstore',
      'Gym': 'gym fitness workout',
      'Spa': 'spa wellness relaxation',
      'Swimming Pool': 'swimming pool aquatic',
      'Museum': 'museum art gallery',
      'Movie Theater': 'cinema movie theater',
      'Art Gallery': 'art gallery exhibition',
      'Zoo': 'zoo animals wildlife',
      'Aquarium': 'aquarium marine fish',
      'Amusement Park': 'amusement park rides',
      'Theater': 'theater stage performance',
      'Night Club': 'nightclub party music',
      'Casino': 'casino gambling',
      'Hotel': 'hotel accommodation',
      'Lodging': 'lodging accommodation',
      'Motel': 'motel accommodation',
      'Resort': 'resort vacation',
      'Park': 'park nature outdoor',
      'Campground': 'campground camping',
      'Hiking': 'hiking trail mountain',
      'National Park': 'national park nature',
      'Tourist Attraction': 'tourist attraction landmark',
      'Church': 'church religious building',
      'Mosque': 'mosque islamic',
      'Synagogue': 'synagogue jewish',
      'Hindu Temple': 'hindu temple',
      'Place of Worship': 'place of worship religious',
      'Airport': 'airport aviation',
      'Bus Station': 'bus station transportation',
      'Train Station': 'train station railway',
      'Subway Station': 'subway metro',
      'Taxi Stand': 'taxi transportation',
      'Bank': 'bank financial',
      'ATM': 'atm banking',
      'Post Office': 'post office mail',
      'Laundry': 'laundry washing',
      'Gas Station': 'gas station fuel',
      'Car Wash': 'car wash vehicle',
      'Parking': 'parking lot',
      'School': 'school education',
      'University': 'university college',
      'Community Center': 'community center',
      'Shopping Mall': 'shopping mall retail',
      'Clothing Store': 'clothing store fashion',
      'Grocery Store': 'grocery store supermarket',
      'Supermarket': 'supermarket grocery',
      'Electronics': 'electronics store technology',
      'Book Store': 'bookstore books',
      'Jewelry': 'jewelry store',
      'Shoe Store': 'shoe store footwear',
      'Furniture': 'furniture store',
      'Home Goods': 'home goods store',
      'Sporting Goods': 'sporting goods store',
    };
    
    // Return mapped term or use category name as-is
    return searchTermMap[categoryName] ?? categoryName.toLowerCase();
  }
  
  /// Clear the image cache (useful for testing or memory management)
  static Future<void> clearCache() async {
    _imageCache.clear();
    _cacheLoaded = false;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_cacheKey);
      print('Cleared Unsplash image cache');
    } catch (e) {
      print('Error clearing Unsplash cache: $e');
    }
  }
  
  /// Get cache statistics
  static Future<Map<String, dynamic>> getCacheStats() async {
    await _loadCache();
    return {
      'cached_images': _imageCache.length,
      'categories': _imageCache.keys.toList(),
    };
  }
}

