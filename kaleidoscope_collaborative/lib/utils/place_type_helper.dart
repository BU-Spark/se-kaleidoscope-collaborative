import 'package:flutter/material.dart';

/// Helper class for mapping Google Places API types to user-friendly categories
/// and providing icons/display names for place types
class PlaceTypeHelper {
  // Map Google Place types to friendly display names
  static const Map<String, String> categoryDisplayNames = {
    // Food & Drink
    'restaurant': 'Restaurant',
    'cafe': 'Café',
    'bar': 'Bar & Nightlife',
    'bakery': 'Bakery',
    'meal_takeaway': 'Takeout',
    'meal_delivery': 'Delivery',
    'pizza_restaurant': 'Pizza',
    'sandwich_shop': 'Sandwich Shop',
    'coffee_shop': 'Coffee Shop',
    'ice_cream_shop': 'Ice Cream',
    'fast_food_restaurant': 'Fast Food',

    // Healthcare
    'hospital': 'Hospital',
    'dentist': 'Dentist',
    'doctor': 'Doctor',
    'pharmacy': 'Pharmacy',
    'physiotherapist': 'Physiotherapy',
    'veterinary_care': 'Veterinary',
    'medical_lab': 'Medical Lab',

    // Shopping
    'shopping_mall': 'Shopping Mall',
    'clothing_store': 'Clothing Store',
    'grocery_store': 'Grocery Store',
    'supermarket': 'Supermarket',
    'convenience_store': 'Convenience Store',
    'electronics_store': 'Electronics',
    'book_store': 'Book Store',
    'jewelry_store': 'Jewelry',
    'shoe_store': 'Shoe Store',
    'furniture_store': 'Furniture',
    'home_goods_store': 'Home Goods',
    'sporting_goods_store': 'Sporting Goods',

    // Entertainment & Culture
    'movie_theater': 'Movie Theater',
    'museum': 'Museum',
    'art_gallery': 'Art Gallery',
    'amusement_park': 'Amusement Park',
    'aquarium': 'Aquarium',
    'zoo': 'Zoo',
    'performing_arts_theater': 'Theater',
    'night_club': 'Night Club',
    'casino': 'Casino',

    // Fitness & Wellness
    'gym': 'Gym',
    'spa': 'Spa',
    'beauty_salon': 'Beauty Salon',
    'hair_salon': 'Hair Salon',
    'nail_salon': 'Nail Salon',
    'sports_club': 'Sports Club',
    'sports_complex': 'Sports Complex',
    'swimming_pool': 'Swimming Pool',

    // Education & Services
    'library': 'Library',
    'school': 'School',
    'university': 'University',
    'community_center': 'Community Center',
    'post_office': 'Post Office',
    'bank': 'Bank',
    'atm': 'ATM',
    'laundry': 'Laundry',
    'gas_station': 'Gas Station',
    'car_wash': 'Car Wash',
    'parking': 'Parking',

    // Parks & Recreation
    'park': 'Park',
    'campground': 'Campground',
    'hiking_area': 'Hiking',
    'national_park': 'National Park',
    'tourist_attraction': 'Tourist Attraction',

    // Places of Worship
    'church': 'Church',
    'mosque': 'Mosque',
    'synagogue': 'Synagogue',
    'hindu_temple': 'Hindu Temple',
    'place_of_worship': 'Place of Worship',

    // Lodging
    'hotel': 'Hotel',
    'lodging': 'Lodging',
    'motel': 'Motel',
    'resort_hotel': 'Resort',

    // Transportation
    'airport': 'Airport',
    'bus_station': 'Bus Station',
    'train_station': 'Train Station',
    'subway_station': 'Subway Station',
    'taxi_stand': 'Taxi Stand',

    // Generic
    'establishment': 'Establishment',
    'point_of_interest': 'Point of Interest',
  };

  // Map place types to Material Design icons
  static const Map<String, IconData> categoryIcons = {
    // Food & Drink
    'restaurant': Icons.restaurant,
    'cafe': Icons.local_cafe,
    'bar': Icons.local_bar,
    'bakery': Icons.bakery_dining,
    'meal_takeaway': Icons.takeout_dining,
    'meal_delivery': Icons.delivery_dining,
    'pizza_restaurant': Icons.local_pizza,
    'sandwich_shop': Icons.lunch_dining,
    'coffee_shop': Icons.coffee,
    'ice_cream_shop': Icons.icecream,
    'fast_food_restaurant': Icons.fastfood,

    // Healthcare
    'hospital': Icons.local_hospital,
    'dentist': Icons.medical_services,
    'doctor': Icons.medical_services,
    'pharmacy': Icons.local_pharmacy,
    'physiotherapist': Icons.healing,
    'veterinary_care': Icons.pets,
    'medical_lab': Icons.science,

    // Shopping
    'shopping_mall': Icons.shopping_bag,
    'clothing_store': Icons.checkroom,
    'grocery_store': Icons.shopping_cart,
    'supermarket': Icons.store,
    'convenience_store': Icons.store,
    'electronics_store': Icons.devices,
    'book_store': Icons.menu_book,
    'jewelry_store': Icons.diamond,
    'shoe_store': Icons.shopping_bag,
    'furniture_store': Icons.chair,
    'home_goods_store': Icons.home,
    'sporting_goods_store': Icons.sports_basketball,

    // Entertainment & Culture
    'movie_theater': Icons.movie,
    'museum': Icons.museum,
    'art_gallery': Icons.palette,
    'amusement_park': Icons.attractions,
    'aquarium': Icons.water,
    'zoo': Icons.pets,
    'performing_arts_theater': Icons.theater_comedy,
    'night_club': Icons.nightlife,
    'casino': Icons.casino,

    // Fitness & Wellness
    'gym': Icons.fitness_center,
    'spa': Icons.spa,
    'beauty_salon': Icons.face,
    'hair_salon': Icons.content_cut,
    'nail_salon': Icons.cleaning_services,
    'sports_club': Icons.sports,
    'sports_complex': Icons.sports_tennis,
    'swimming_pool': Icons.pool,

    // Education & Services
    'library': Icons.local_library,
    'school': Icons.school,
    'university': Icons.account_balance,
    'community_center': Icons.people,
    'post_office': Icons.mail,
    'bank': Icons.account_balance,
    'atm': Icons.atm,
    'laundry': Icons.local_laundry_service,
    'gas_station': Icons.local_gas_station,
    'car_wash': Icons.local_car_wash,
    'parking': Icons.local_parking,

    // Parks & Recreation
    'park': Icons.park,
    'campground': Icons.forest,
    'hiking_area': Icons.hiking,
    'national_park': Icons.landscape,
    'tourist_attraction': Icons.tour,

    // Places of Worship
    'church': Icons.church,
    'mosque': Icons.mosque,
    'synagogue': Icons.synagogue,
    'hindu_temple': Icons.temple_hindu,
    'place_of_worship': Icons.place,

    // Lodging
    'hotel': Icons.hotel,
    'lodging': Icons.bed,
    'motel': Icons.hotel,
    'resort_hotel': Icons.beach_access,

    // Transportation
    'airport': Icons.flight,
    'bus_station': Icons.directions_bus,
    'train_station': Icons.train,
    'subway_station': Icons.subway,
    'taxi_stand': Icons.local_taxi,

    // Generic
    'establishment': Icons.business,
    'point_of_interest': Icons.place,
  };

  // Group types into major categories for the home page
  static const Map<String, List<String>> categoryGroups = {
    'Restaurant': [
      'restaurant',
      'cafe',
      'bar',
      'bakery',
      'meal_takeaway',
      'pizza_restaurant',
      'sandwich_shop',
      'coffee_shop',
      'fast_food_restaurant',
    ],
    'Healthcare': [
      'hospital',
      'doctor',
      'dentist',
      'pharmacy',
      'physiotherapist',
      'medical_lab',
    ],
    'Shopping': [
      'shopping_mall',
      'clothing_store',
      'grocery_store',
      'supermarket',
      'electronics_store',
      'book_store',
    ],
    'Entertainment': [
      'movie_theater',
      'museum',
      'art_gallery',
      'amusement_park',
      'zoo',
      'aquarium',
      'performing_arts_theater',
    ],
    'Fitness': [
      'gym',
      'spa',
      'sports_club',
      'sports_complex',
      'swimming_pool',
    ],
    'Library': ['library'],
    'Services': [
      'bank',
      'post_office',
      'laundry',
      'gas_station',
      'car_wash',
    ],
    'Parks': [
      'park',
      'campground',
      'hiking_area',
      'national_park',
    ],
  };

  /// Get friendly display name for a Google Place type
  static String getFriendlyName(String googleType) {
    // Clean the type string (remove whitespace, convert to lowercase)
    final cleanType = googleType.trim().toLowerCase();
    return categoryDisplayNames[cleanType] ?? _formatTypeName(cleanType);
  }

  /// Get Material Design icon for a Google Place type
  static IconData getIcon(String googleType) {
    final cleanType = googleType.trim().toLowerCase();
    return categoryIcons[cleanType] ?? Icons.place;
  }

  /// Get the primary type from a list of types (prioritize more specific types)
  static String getPrimaryType(List<dynamic> types) {
    if (types.isEmpty) return 'establishment';

    // Filter out generic types
    final genericTypes = ['establishment', 'point_of_interest', 'store'];
    final specificTypes = types
        .map((t) => t.toString().toLowerCase())
        .where((t) => !genericTypes.contains(t))
        .toList();

    // Return first specific type, or first type if all are generic
    return specificTypes.isNotEmpty ? specificTypes.first : types.first.toString().toLowerCase();
  }

  /// Get category group name for a specific type
  /// Returns the major category (e.g., "Restaurant") for a specific type (e.g., "cafe")
  static String? getCategoryGroup(String googleType) {
    final cleanType = googleType.trim().toLowerCase();

    for (final entry in categoryGroups.entries) {
      if (entry.value.contains(cleanType)) {
        return entry.key;
      }
    }
    return null;
  }

  /// Get all types that belong to a category group
  static List<String> getTypesForCategory(String categoryName) {
    return categoryGroups[categoryName] ?? [];
  }

  /// Map home page category display names to Google types
  static String mapDisplayNameToType(String displayName) {
    const mapping = {
      'Restaurant': 'restaurant',
      'Dojo': 'gym',
      'Library': 'library',
      'Museum': 'museum',
      'Dentist': 'dentist',
      'Swimming Pool': 'swimming_pool',
    };
    return mapping[displayName] ?? displayName.toLowerCase().replaceAll(' ', '_');
  }

  /// Format a raw type name into a readable string
  static String _formatTypeName(String type) {
    return type
        .replaceAll('_', ' ')
        .split(' ')
        .map((word) => word.isEmpty ? '' : word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  /// Check if a type is in a specific category group
  static bool isInCategory(String googleType, String categoryName) {
    final types = getTypesForCategory(categoryName);
    return types.contains(googleType.trim().toLowerCase());
  }

  /// Get a color for a category (for visual grouping)
  static Color getCategoryColor(String googleType) {
    final cleanType = googleType.trim().toLowerCase();

    // Define color schemes for different categories
    if (categoryGroups['Restaurant']?.contains(cleanType) ?? false) {
      return const Color(0xFFFF6B6B); // Red for food
    } else if (categoryGroups['Healthcare']?.contains(cleanType) ?? false) {
      return const Color(0xFF4ECDC4); // Teal for healthcare
    } else if (categoryGroups['Shopping']?.contains(cleanType) ?? false) {
      return const Color(0xFFFFBE0B); // Yellow for shopping
    } else if (categoryGroups['Entertainment']?.contains(cleanType) ?? false) {
      return const Color(0xFF9B59B6); // Purple for entertainment
    } else if (categoryGroups['Fitness']?.contains(cleanType) ?? false) {
      return const Color(0xFF3498DB); // Blue for fitness
    } else if (categoryGroups['Library']?.contains(cleanType) ?? false) {
      return const Color(0xFF95A99C); // Green for library
    } else if (categoryGroups['Parks']?.contains(cleanType) ?? false) {
      return const Color(0xFF27AE60); // Green for parks
    }

    return const Color(0xFF95A5A6); // Gray for others
  }
}
