import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaleidoscope_collaborative/config/app_theme.dart';
import "package:kaleidoscope_collaborative/finding_location_rating/search_page_1_0.dart";
import 'package:kaleidoscope_collaborative/screens/ProfileCustomization/profile_customize_1_0.dart';
import 'package:kaleidoscope_collaborative/screens/ProfileCustomization/finished_customization_page.dart';
import 'package:kaleidoscope_collaborative/models/profile.dart';
import 'package:kaleidoscope_collaborative/screens/HomeAndLanding/favorite_page.dart';
import 'package:kaleidoscope_collaborative/widgets/auth_gate.dart';
import 'package:kaleidoscope_collaborative/screens/Review/review_content_page.dart';
import 'package:kaleidoscope_collaborative/screens/Category/category_results_page.dart';
import 'package:kaleidoscope_collaborative/utils/place_type_helper.dart';
import 'package:kaleidoscope_collaborative/screens/cloud_firestore_service.dart';
import 'package:kaleidoscope_collaborative/services/unsplash_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  int _selectedIndex = 1; // 0: Favorite, 1: Explore, 2: Profile
  final _auth = FirebaseAuth.instance;
  User? loggedInUser;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? first_name;
  String? last_name;
  String? full_name;

  // Profile-related state
  bool _isLoadingProfile = false;
  ProfileData? _profileData;
  bool _showProfileCustomization = false;

  // Categories will be loaded dynamically from reviews
  late CloudFirestoreService _firestoreService;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    _tabController = TabController(length: 2, vsync: this);
    _firestoreService = CloudFirestoreService(_firestore);

    // Listen to auth state changes
    _auth.authStateChanges().listen((User? user) {
      setState(() {
        loggedInUser = user;
        // Reset profile data when user logs out
        if (user == null) {
          _profileData = null;
          _isLoadingProfile = false;
          _showProfileCustomization = false;
          _selectedIndex = 1; // Reset to Explore tab
        }
      });
    });
  }

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        setState(() {
          loggedInUser = user; // This will only be set if there is a current user
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<String?> getUserNameByEmail(String? email) async {
    if (loggedInUser?.email == null) {
      return null;
    }
    
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('User')
          .where('email', isEqualTo: loggedInUser!.email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var userData = querySnapshot.docs.first.data() as Map<String, dynamic>; // Cast to Map<String, dynamic>
        first_name = userData['first_name']; // Now you can use the '[]' operator
        last_name = userData['last_name'];
        full_name = '$first_name $last_name';
      }
    } catch (e) {
      print(e.toString());
    }

    return first_name;
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_tabController == null) {
      return Container();
    }

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: _selectedIndex == 1 ? _buildExploreAppBar() : null,
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorite',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppTheme.primaryColor,
        onTap: _handleNavigation,
      ),
    );
  }

  PreferredSizeWidget _buildExploreAppBar() {
    return AppBar(
      backgroundColor: AppTheme.backgroundColor,
      automaticallyImplyLeading: false,
      elevation: 0,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: TabBar(
          controller: _tabController,
          labelColor: AppTheme.primaryColorDark,
          unselectedLabelColor: Colors.grey,
          labelStyle: GoogleFonts.openSans(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: GoogleFonts.openSans(
            fontSize: 18,
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
            Tab(text: 'Explore'),
            Tab(text: 'Review'),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0: // Favorite
        return _buildFavoriteContent();
      case 1: // Explore
        return _buildExploreContent();
      case 2: // Profile
        return _buildProfileContent();
      default:
        return _buildExploreContent();
    }
  }

  Widget _buildFavoriteContent() {
    if (loggedInUser == null) {
      return const AuthGate(
        icon: Icons.favorite_outline,
        title: 'Your Favorites',
        subtitle: 'Please log in or sign up to view your favorite places',
      );
    }
    return const FavoritePage();
  }

  Widget _buildExploreContent() {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildExploreTab(),
        _buildReviewTab(),
      ],
    );
  }

  Widget _buildExploreTab() {
    // Limit text scale factor for the entire explore tab
    final textScaleFactor = MediaQuery.of(context).textScaleFactor.clamp(1.0, 1.3);
    
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaleFactor: textScaleFactor,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchPage(name: loggedInUser?.email ?? 'User')),
                );
              },
              readOnly: true,
              decoration: InputDecoration(
                hintText: 'Search for places...',
                hintStyle: GoogleFonts.openSans(
                  color: Colors.grey.shade600,
                  fontSize: 16,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: AppTheme.primaryColor,
                  size: 24,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: AppTheme.primaryColor, width: 2),
                ),
                fillColor: Colors.white,
                filled: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<Map<String, int>>(
              future: _firestoreService.getAvailableCategoryGroups(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(
                          color: AppTheme.primaryColor,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Loading categories...',
                          style: GoogleFonts.openSans(
                            fontSize: 16,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.explore_outlined,
                            size: 64,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No categories yet',
                            style: GoogleFonts.openSans(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Start reviewing places to see categories here!',
                            textAlign: TextAlign.center,
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

                // Group types by category groups
                final categoryGroups = _groupTypesByCategoryGroup(snapshot.data!);
                
                return GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 1 / 1.15,
                  ),
                  itemCount: categoryGroups.length,
                  itemBuilder: (context, index) {
                  final entry = categoryGroups[index];
                  final categoryGroupName = entry.key;
                  final reviewCount = entry.value;
                  
                  // Get the best type for this category group to use for display
                  final bestType = _getBestTypeForCategoryGroup(categoryGroupName, snapshot.data!);
                  final displayName = PlaceTypeHelper.getFriendlyName(bestType);
                  final icon = PlaceTypeHelper.getIcon(bestType);
                  final color = PlaceTypeHelper.getCategoryColor(bestType);

                  return GestureDetector(
                    onTap: () {
                      // Get all types in this category group
                      final types = PlaceTypeHelper.getTypesForCategory(categoryGroupName);
                      final categoryType = types.isNotEmpty ? types.first : bestType;

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CategoryResultsPage(
                            categoryType: categoryType,
                            categoryName: displayName,
                            userName: loggedInUser?.email ?? 'User',
                          ),
                        ),
                      );
                    },
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        // Limit text scale factor to prevent overflow in cards
                        final textScaleFactor = MediaQuery.of(context).textScaleFactor.clamp(1.0, 1.3);
                        
                        return Card(
                          clipBehavior: Clip.antiAlias,
                          elevation: 3,
                          shadowColor: AppTheme.primaryColor.withValues(alpha: 0.2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                flex: 3,
                                child: _CategoryImageWidget(
                                  categoryName: displayName,
                                  icon: icon,
                                  color: color,
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  color: Colors.white,
                                  child: MediaQuery(
                                    data: MediaQuery.of(context).copyWith(
                                      textScaleFactor: textScaleFactor,
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            displayName,
                                            style: GoogleFonts.openSans(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black87,
                                            ),
                                            textAlign: TextAlign.center,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          '$reviewCount ${reviewCount == 1 ? 'review' : 'reviews'}',
                                          style: GoogleFonts.openSans(
                                            fontSize: 11,
                                            color: Colors.grey.shade600,
                                          ),
                                          textAlign: TextAlign.center,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
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
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Group types by their category groups and sum review counts
  List<MapEntry<String, int>> _groupTypesByCategoryGroup(Map<String, int> typeCounts) {
    Map<String, int> groupedCounts = {};
    
    for (var entry in typeCounts.entries) {
      final type = entry.key;
      final count = entry.value;
      
      // Get category group for this type
      final categoryGroup = PlaceTypeHelper.getCategoryGroup(type);
      
      if (categoryGroup != null) {
        // Group by category group
        groupedCounts[categoryGroup] = (groupedCounts[categoryGroup] ?? 0) + count;
      } else {
        // If no category group, use the type itself as the group
        groupedCounts[type] = (groupedCounts[type] ?? 0) + count;
      }
    }
    
    // Sort by review count (descending) and return as list
    final sorted = groupedCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    return sorted;
  }

  /// Get the best type for a category group (the one with most reviews)
  String _getBestTypeForCategoryGroup(String categoryGroup, Map<String, int> typeCounts) {
    final types = PlaceTypeHelper.getTypesForCategory(categoryGroup);
    
    if (types.isEmpty) {
      return categoryGroup;
    }
    
    // Find the type in this category group with the most reviews
    String? bestType;
    int maxCount = 0;
    
    for (var type in types) {
      final count = typeCounts[type] ?? 0;
      if (count > maxCount) {
        maxCount = count;
        bestType = type;
      }
    }
    
    // If no type found with reviews, return the first type in the group
    return bestType ?? types.first;
  }

  Widget _buildReviewTab() {
    if (loggedInUser == null) {
      return const AuthGate(
        icon: Icons.rate_review_outlined,
        title: 'Review Content',
        subtitle: 'Please log in or sign up to review places',
      );
    }

    return ReviewContentPage(
      userId: loggedInUser!.email ?? '',
      userName: loggedInUser!.email ?? 'User',
    );
  }

  Widget _buildProfileContent() {
    if (loggedInUser == null) {
      return const AuthGate(
        icon: Icons.person_outline,
        title: 'Profile',
        subtitle: 'Please log in or sign up to view your profile',
      );
    }

    // Show loading indicator while checking profile
    if (_isLoadingProfile) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppTheme.primaryColor,
        ),
      );
    }

    // If profile data is loaded, show it
    if (_profileData != null) {
      return finished_customization_page(profileData: _profileData!);
    }

    // If we need to show customization, show it
    if (_showProfileCustomization) {
      return const CustomizeProfilePage();
    }

    // Default: show a placeholder
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_outline,
              size: 80,
              color: AppTheme.primaryColor.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'Profile',
              style: GoogleFonts.openSans(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColorDark,
              ),
            ),
            const SizedBox(height: 8),
            const CircularProgressIndicator(
              color: AppTheme.primaryColor,
            ),
          ],
        ),
      ),
    );
  }

  void _handleNavigation(int index) async {
    if (index == 2 && loggedInUser != null) {
      // Special handling for Profile tab when logged in
      // Load profile data before showing the profile screen
      setState(() {
        _selectedIndex = index;
        _isLoadingProfile = true;
      });

      try {
        // Check if profile exists using email directly
        DocumentSnapshot profileSnapshot = await FirebaseFirestore.instance
            .collection('ProfileData')
            .doc(loggedInUser!.email)
            .get();

        if (profileSnapshot.exists) {
          ProfileData profileData = ProfileData.fromFirestore(
              profileSnapshot.data() as Map<String, dynamic>);
          setState(() {
            _profileData = profileData;
            _isLoadingProfile = false;
            _showProfileCustomization = false;
          });
        } else {
          // Profile doesn't exist, show customization
          setState(() {
            _profileData = null;
            _isLoadingProfile = false;
            _showProfileCustomization = true;
          });
        }
      } catch (e) {
        print("Error loading profile: $e");
        setState(() {
          _isLoadingProfile = false;
          _showProfileCustomization = true;
        });
      }
    } else {
      // For Favorite and Explore tabs, just switch
      setState(() {
        _selectedIndex = index;
      });
    }
  }
}

/// Widget that displays category image from Unsplash with icon fallback
class _CategoryImageWidget extends StatelessWidget {
  final String categoryName;
  final IconData icon;
  final Color color;

  const _CategoryImageWidget({
    required this.categoryName,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: UnsplashService.getCategoryImageUrl(categoryName),
      builder: (context, snapshot) {
        // If image is loading or not available, show icon fallback
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  color.withValues(alpha: 0.2),
                  color.withValues(alpha: 0.4),
                ],
              ),
            ),
            child: Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              ),
            ),
          );
        }

        final imageUrl = snapshot.data;

        // If we have an image URL, display it
        if (imageUrl != null) {
          return Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  // If image fails to load, show icon fallback
                  return _buildIconFallback();
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.15),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          color.withValues(alpha: 0.2),
                          color.withValues(alpha: 0.4),
                        ],
                      ),
                    ),
                    child: Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(color),
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      ),
                    ),
                  );
                },
              ),
              // Add a subtle gradient overlay for better text readability
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.2),
                    ],
                  ),
                ),
              ),
            ],
          );
        }

        // Fallback to icon if no image available
        return _buildIconFallback();
      },
    );
  }

  Widget _buildIconFallback() {
    return Container(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            color.withValues(alpha: 0.2),
            color.withValues(alpha: 0.4),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          icon,
          size: 48,
          color: color,
        ),
      ),
    );
  }
}
