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

class Category {
  final String imagePath;
  final String name;

  Category({required this.imagePath, required this.name});
}

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

  final List<Category> categories = [
    Category(imagePath: 'images/restaurant.jpg', name: 'Restaurant'),
    Category(imagePath: 'images/dojo.jpg', name: 'Dojo'),
    Category(imagePath: 'images/library.jpg', name: 'Library'),
    Category(imagePath: 'images/museum.jpg', name: 'Museum'),
    Category(imagePath: 'images/dentist.jpg', name: 'Dentist'),
    Category(imagePath: 'images/swimming.jpg', name: 'Swimming Pool'),
  ];

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    _tabController = TabController(length: 2, vsync: this);

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
    return Column(
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
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1 / 1.05,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              var category = categories[index];
              return GestureDetector(
                onTap: () {
                  // Map display name to Google type
                  String categoryType = PlaceTypeHelper.mapDisplayNameToType(category.name);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CategoryResultsPage(
                        categoryType: categoryType,
                        categoryName: category.name,
                        userName: loggedInUser?.email ?? 'User',
                      ),
                    ),
                  );
                },
                child: Card(
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
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.asset(
                              category.imagePath,
                              fit: BoxFit.cover,
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
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          color: Colors.white,
                          child: Center(
                            child: Text(
                              category.name,
                              style: GoogleFonts.openSans(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
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
