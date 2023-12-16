import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kaleidoscope_collaborative/screens/first_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kaleidoscope_collaborative/screens/HomeAndLanding/category_selection.dart';


// import search_page_1_0.dart; 
import "package:kaleidoscope_collaborative/finding_location_rating/search_page_1_0.dart";




class Category {
  final String imagePath;
  final String name;

  Category({required this.imagePath, required this.name});
}


class DashboardScreen extends StatefulWidget {

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with SingleTickerProviderStateMixin {
  // Initialize the TabController here without late
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
    // getCurrentUser();
    // Initialize the TabController in initState
    _tabController = TabController(length: 2, vsync: this);
  }

  void getCurrentUser() async{
    try{
      final user = _auth.currentUser;
      if(user!=null){
        loggedInUser = user;
        print(loggedInUser.email);
      }
    }
    catch(e){
      print(e);
    }
  }

  Future<String> getUserNameByEmail(String? email) async {
    try {
      // Assume 'User' is your collection where user data is stored
      QuerySnapshot querySnapshot = await _firestore
          .collection('User')
          .where('email', isEqualTo: loggedInUser.email) // Filter by email
          .limit(1) // Limit to only one result
          .get();

      // Check if the query returned any documents
      if (querySnapshot.docs.isNotEmpty) {
        var userData = querySnapshot.docs.first.data() as Map<String, dynamic>; // Cast to Map<String, dynamic>
        first_name = userData['first_name']; // Now you can use the '[]' operator
      }
    } catch (e) {
      print(e.toString());
    }

    return first_name;
  }


  @override
  void dispose() {
    // Dispose the TabController when the widget is disposed
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    if (_tabController == null) {
      return Container(); // or some loading indicator
    }
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min, // Use min size of the Row
          children: [

            Expanded( // Expanded for the text to take all available space on the left
              child: Align(
                alignment: Alignment.center, // Align text to center
                child: RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: 'kaleidoscope\n', // The '\n' creates a new line
                        style: TextStyle(
                          color: Color(0xFF174177),
                          fontWeight: FontWeight.bold,
                          fontSize: 20, // Adjust the font size as needed
                        ),
                      ),
                      TextSpan(
                        text: 'collaborative',
                        style: TextStyle(
                          color: Color(0xFF174177),
                          fontWeight: FontWeight.bold,
                          fontSize: 20, // Adjust the font size as needed
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Image.asset(
              'images/logo.jpg', // Replace with your image asset path
              height: 40, // Set your height
              width: 40, // Set your width
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
            icon: Icon(Icons.search, color: Colors.black),
            onPressed: () {
              // Implement search functionality
              // Navigate to the SearchPage when the search icon is clicked
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchPage()),
              );

            },
          ),
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
              labelStyle: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
              unselectedLabelStyle: TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal),
              indicatorSize: TabBarIndicatorSize.label, // This aligns the indicator to the width of the label
              indicator: const UnderlineTabIndicator( // UnderlineTabIndicator is used for a line indicator
                borderSide: BorderSide(
                  color: Colors.deepPurple, // The color of the line
                  width: 2.0, // The thickness of the line
                ),
                insets: EdgeInsets.symmetric(horizontal: 8.0), // This will control the width of the line, adjust as needed for your layout
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
              future: getUserNameByEmail(loggedInUser.email), // Future that returns the name
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  // Check if the future is complete and has data
                  if (snapshot.hasData) {
                    return DrawerHeader(
                      decoration: const BoxDecoration(
                        color: Color(0xFF6750A4),
                      ),
                      child: Text(
                        'Hi ${snapshot.data}', // Display the name from the snapshot
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
                  // While waiting for the future to complete, show a placeholder
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
                  // Close the drawer
                  Navigator.of(context).pop();
                  // Navigate to the sign-in screen, replacing all routes
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
        controller: _tabController, // Provide the TabController to the TabBarView
        children: [
          // Your grid view or other widgets for the Explore tab
          // Center(
          //     child: Text('Explore Content')),
          Column(
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: TextField(
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
                  itemCount: categories.length, // Number of items in your grid
                    itemBuilder: (context, index) {
                      var category = categories[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                              MaterialPageRoute(builder: (context) => CategorySelection(category: category.name,),),
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
          // Your widgets for the Review tab
          Center(child: Text('Review Content')),
        ],
      ),
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
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      // Rest of your code...
    );
  }
}

