import 'package:kaleidoscope_collaborative/config/globals.dart' as globals;

/// Helper class to construct photo URLs from Google Places photo references
class PhotoUrlHelper {
  /// Constructs a photo URL from a photo reference or existing URL
  /// 
  /// This handles both:
  /// 1. New format: photo reference names (e.g., "places/ChIJ.../photos/...")
  /// 2. Old format: full URLs that were previously stored
  /// 
  /// For new photo references, it uses the backend proxy endpoint which
  /// handles authentication with Google Places API properly.
  static String getPhotoUrl(String? photoReference) {
    if (photoReference == null || photoReference.isEmpty) {
      // Return a default placeholder image
      return "https://maps.gstatic.com/mapfiles/place_api/icons/v1/png_71/generic_business-71.png";
    }
    
    // Check if it's already a full URL (old format from existing Firestore data)
    if (photoReference.startsWith('http://') || photoReference.startsWith('https://')) {
      // If it's an old Google Places API URL with the key parameter, convert it to use our proxy
      if (photoReference.contains('places.googleapis.com/v1/') && 
          photoReference.contains('/media?')) {
        // Extract the photo reference path (everything between v1/ and /media)
        final match = RegExp(r'places\.googleapis\.com/v1/(places/[^/]+/photos/[^/]+)/media').firstMatch(photoReference);
        if (match != null) {
          final photoRef = match.group(1);
          return '${globals.apiBaseUrl}/api/photo/$photoRef';
        }
      }
      // Return as-is for other URLs (like the generic icon)
      return photoReference;
    }
    
    // New format: photo reference name (e.g., "places/ChIJ.../photos/...")
    // Use our backend proxy endpoint
    return '${globals.apiBaseUrl}/api/photo/$photoReference';
  }
  
  /// Check if a photo reference is valid (not empty and not a placeholder)
  static bool isValidPhotoReference(String? photoReference) {
    if (photoReference == null || photoReference.isEmpty) {
      return false;
    }
    
    // Check if it's the generic placeholder
    if (photoReference.contains('generic_business')) {
      return false;
    }
    
    return true;
  }
}

