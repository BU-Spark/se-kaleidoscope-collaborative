import 'package:flutter/material.dart';


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

  final List<Category> categories = [
    Category(imagePath: 'images/restaurant.jpg', name: 'Restaurants'),
    Category(imagePath: 'images/dojo.jpg', name: 'Dojo'),
    Category(imagePath: 'images/library.jpg', name: 'Library'),
    Category(imagePath: 'images/museum.jpg', name: 'Museum'),
    Category(imagePath: 'images/dentist.jpg', name: 'Dentist'),
    Category(imagePath: 'images/swimming.jpg', name: 'Swimming Pool'),
  ];

  @override
  void initState() {
    super.initState();
    // Initialize the TabController in initState
    _tabController = TabController(length: 2, vsync: this);
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
        leading: Icon(Icons.menu, color: Colors.black),
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.search, color: Colors.black),
        //     onPressed: () {
        //       // Implement search functionality
        //     },
        //   ),
        //   IconButton(
        //     icon: Icon(Icons.notifications, color: Colors.black),
        //     onPressed: () {
        //       // Implement notification functionality
        //     },
        //   ),
        // ],
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
                    // Replace with your actual data
                    var category =  categories[index];
                    return Card(
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0), // Adjust the radius as needed
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
      // Rest of your code...
    );
  }
}

