// The OnboardingScreen provides a multi-step introduction to the app's features and purpose, guiding new users through key information.

import 'package:flutter/material.dart';
import 'package:kaleidoscope_collaborative/screens/HomeAndLanding/home_page.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0);
  final int _numPages = 4;

  // Dispose of PageController when the widget is disposed.
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar setup with dynamic title based on the current onboarding page.
      appBar: AppBar(
        title: Text('Onboarding ${_currentPage + 1}'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // PageView to create a swipeable series of onboarding pages.
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              children: [
                // Individual onboarding pages.
                buildPage(
                  title: 'Welcome to\nKaleidoscope',
                  content: 'We are here to empower your experience with reviews from your community.',
                  imagePath: 'images/welcome.jpg', // Replace with your image path
                ),
                buildPage(
                  title: 'Explore',
                  content: 'Read reviews about disability accommodations at locations around you',
                  imagePath: 'images/explore.jpg', // Replace with your image path
                ),
                buildPage(
                  title: 'Share',
                  content: 'Share your experience and help others by writing reviews',
                  imagePath: 'images/share.jpg', // Replace with your image path
                ),
                buildPage(
                  title: 'Personalize',
                  content: 'Customize your search settings for a more personalized experience',
                  imagePath: 'images/personalize.jpg', // Replace with your image path
                ),
              ],
            ),
          ),
          // // Dots indicators for onboarding progress.
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _numPages,
                  (index) => buildDot(index, context),
            ),
          ),

          // Navigation buttons to move through onboarding pages.
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                if (_currentPage > 0)
                  TextButton(
                    onPressed: () {
                      _pageController.previousPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: Text('Back'),
                    style: TextButton.styleFrom(
                      primary: Colors.deepPurple,
                    ),
                  ),

                if (_currentPage < _numPages - 1)
                  TextButton(
                    onPressed: () {
                      _pageController.nextPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: Text('Next'),
                    style: TextButton.styleFrom(
                      primary: Colors.deepPurple,
                    ),
                  ),
                if (_currentPage == _numPages - 1)
                  TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => DashboardScreen()));
                    },
                    child: Text('Finish'),
                    style: TextButton.styleFrom(
                      primary: Colors.deepPurple,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper function to build each onboarding page.
  Widget buildPage({required String title, required String content, required String imagePath}) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          Text(
            content,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16.0,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 30),
          Image.asset(imagePath, height: 300),
        ],
      ),
    );
  }

  // Helper function to build the dot indicators for the onboarding page.
  Widget buildDot(int index, BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      height: 10,
      width: _currentPage == index ? 20 : 10,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: _currentPage == index ? Colors.deepPurple : Colors.deepPurple[200],
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}

