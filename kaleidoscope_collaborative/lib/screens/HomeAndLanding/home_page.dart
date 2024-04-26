import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kaleidoscope_collaborative/screens/first_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kaleidoscope_collaborative/screens/HomeAndLanding/category_selection.dart';
import 'package:kaleidoscope_collaborative/services/cloud_firestore_service.dart';
import "package:kaleidoscope_collaborative/finding_location_rating/search_page_1_0.dart";
import 'package:kaleidoscope_collaborative/screens/ProfileCustomization/profile_customize_1_0.dart';
import 'package:kaleidoscope_collaborative/screens/ProfileCustomization/finished_customization_page.dart';
import 'package:kaleidoscope_collaborative/models/profile.dart';

class Category {
  final String imagePath;
  final String name;

  Category({required this.imagePath, required this.name});
}

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  int _selectedIndex = 1;
  final _auth = FirebaseAuth.instance;
  late User loggedInUser;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late String first_name;

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

  Future<String> getUserNameByEmail(String? email) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('User')
          .where('email', isEqualTo: loggedInUser.email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var userData = querySnapshot.docs.first.data() as Map<String, dynamic>;
        first_name = userData['first_name'];
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
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: 'kaleidoscope\n',
                        style: TextStyle(
                          color: Color(0xFF174177),
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      TextSpan(
                        text: 'collaborative',
                        style: TextStyle(
                          color: Color(0xFF174177),
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.person, color: Colors.black),
              onPressed: () {
                handleProfile();
              },
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: Color(0xFFFFFBFE),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu, color: Colors.black),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.black),
            onPressed: () {
              // Implement notification functionality
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: Align(
            alignment: Alignment.centerLeft,
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              labelStyle:
                  TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
              unselectedLabelStyle:
                  TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal),
              indicatorSize: TabBarIndicatorSize.label,
              indicator: const UnderlineTabIndicator(
                borderSide: BorderSide(
                  color: Colors.deepPurple,
                  width: 2.0,
                ),
                insets: EdgeInsets.symmetric(horizontal: 8.0),
              ),
              tabs: const [
                Tab(text: 'Explore'),
                Tab(text: 'Review'),
              ],
            ),
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            FutureBuilder<String>(
              future: getUserNameByEmail(loggedInUser.email),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    return DrawerHeader(
                      decoration: const BoxDecoration(
                        color: Color(0xFF6750A4),
                      ),
                      child: Text(
                        'Hi ${snapshot.data}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    );
                  } else {
                    return const DrawerHeader(
                      decoration: BoxDecoration(
                        color: Color(0xFF6750A4),
                      ),
                      child: Text(
                        'Hi there!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    );
                  }
                } else {
                  return const DrawerHeader(
                    decoration: BoxDecoration(
                      color: Color(0xFF6750A4),
                    ),
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Sign Out'),
              onTap: () {
                _auth.signOut().then((_) {
                  Navigator.of(context).pop();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => FirstScreen()),
                  );
                });
              },
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Column(
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: TextField(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SearchPage()),
                    );
                  },
                  decoration: InputDecoration(
                    hintText: 'Search',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    fillColor: Color(0xFFEEEEEE),
                    filled: true,
                  ),
                ),
              ),
              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.all(16.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1 / 1,
                  ),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    var category = categories[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                SearchPage(initialSearch: category.name),
                          ),
                        );
                      },
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: Image.asset(
                                category.imagePath,
                                fit: BoxFit.cover,
                              ),
                            ),
                            ListTile(
                              title: Text(category.name),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          Center(child: Text('Review Content')),
        ],
      ),
      // Bottom navigation bar to navigate between different sections like 'Favorite', 'Explore', and 'Profile'.
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
          selectedItemColor: Colors.amber[800],
          onTap: handleNavigationBasedOnProfile),
    );
  }

  void handleNavigationBasedOnProfile(int index) async {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 2) {
      // When "Profile" tab is selected
      try {
        CloudFirestoreService firestoreService =
            CloudFirestoreService(FirebaseFirestore.instance);
        bool profileExists = await firestoreService.profileDataExists();

        if (profileExists) {
          // Fetch the profile data from Firestore
          DocumentSnapshot profileSnapshot = await FirebaseFirestore.instance
              .collection('ProfileData')
              .doc(loggedInUser.email)
              .get();

          if (profileSnapshot.exists) {
            ProfileData profileData = ProfileData.fromFirestore(
                profileSnapshot.data() as Map<String, dynamic>);
            // Navigate to FinishedCustomizationPage with the fetched profile data
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        finished_customization_page(profileData: profileData)));
          } else {
            print("Profile data found, but unable to load.");
          }
        } else {
          // Navigate to CustomizeProfilePage if profile does not exist
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => CustomizeProfilePage()));
        }
      } catch (e) {
        print("Error checking profile existence: $e");
        // Optionally handle or log this error more gracefully
      }
    }
  }

  void handleProfile() async {
    // When "Profile" tab is selected
    try {
      CloudFirestoreService firestoreService =
          CloudFirestoreService(FirebaseFirestore.instance);
      bool profileExists = await firestoreService.profileDataExists();

      if (profileExists) {
        // Fetch the profile data from Firestore
        DocumentSnapshot profileSnapshot = await FirebaseFirestore.instance
            .collection('ProfileData')
            .doc(loggedInUser.email)
            .get();

        if (profileSnapshot.exists) {
          ProfileData profileData = ProfileData.fromFirestore(
              profileSnapshot.data() as Map<String, dynamic>);
          // Navigate to FinishedCustomizationPage with the fetched profile data
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      finished_customization_page(profileData: profileData)));
        } else {
          print("Profile data found, but unable to load.");
          // Optionally handle the condition when data exists but couldn't be loaded
        }
      } else {
        // Navigate to CustomizeProfilePage if profile does not exist
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => CustomizeProfilePage()));
      }
    } catch (e) {
      print("Error checking profile existence: $e");
    }
  }
}
