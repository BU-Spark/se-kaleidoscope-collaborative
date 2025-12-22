// The OnboardingScreen provides a multi-step introduction to the app's features and purpose, guiding new users through key information.

import 'package:flutter/material.dart';
import 'package:kaleidoscope_collaborative/screens/HomeAndLanding/home_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

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
    // Limit text scale factor for the entire screen
    final textScaleFactor = MediaQuery.of(context).textScaleFactor.clamp(1.0, 1.3);
    
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaleFactor: textScaleFactor,
      ),
      child: Scaffold(
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
                    content:
                        'We are here to empower your experience with reviews from your community.',
                    imagePath:
                        'images/welcome.jpg', // Replace with your image path
                  ),
                  buildPage(
                    title: 'Explore',
                    content:
                        'Read reviews about disability accommodations at locations around you',
                    imagePath:
                        'images/explore.jpg', // Replace with your image path
                  ),
                  buildPage(
                    title: 'Share',
                    content:
                        'Share your experience and help others by writing reviews',
                    imagePath: 'images/share.jpg', // Replace with your image path
                  ),
                  buildPage(
                    title: 'Personalize',
                    content:
                        'Customize your search settings for a more personalized experience',
                    imagePath:
                        'images/personalize.jpg', // Replace with your image path
                  ),
                ],
              ),
            ),
            // // Dots indicators for onboarding progress.
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _numPages,
                  (index) => buildDot(index, context),
                ),
              ),
            ),

            // Navigation buttons to move through onboarding pages.
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  if (_currentPage > 0)
                    TextButton(
                      onPressed: () {
                        _pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.deepPurple,
                      ),
                      child: const Text('Back'),
                    )
                  else
                    const SizedBox(width: 48), // Placeholder for alignment
                  if (_currentPage < _numPages - 1)
                    TextButton(
                      onPressed: () {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.deepPurple,
                      ),
                      child: const Text('Next'),
                    ),
                  if (_currentPage == _numPages - 1)
                    TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const DashboardScreen()));
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.deepPurple,
                      ),
                      child: const Text('Finish'),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to build each onboarding page.
  Widget buildPage(
      {required String title,
      required String content,
      required String imagePath}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate responsive dimensions based on available space
        final availableHeight = constraints.maxHeight;
        final availableWidth = constraints.maxWidth;
        
        // Adjust padding based on screen size
        final horizontalPadding = (availableWidth * 0.08).clamp(20.0, 40.0);
        final verticalPadding = (availableHeight * 0.05).clamp(20.0, 40.0);
        
        // Calculate responsive image height
        final imageHeight = (availableHeight * 0.35).clamp(120.0, 250.0);
        
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: verticalPadding,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: availableHeight - (verticalPadding * 2)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Title with FittedBox to scale down if needed
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: availableWidth - (horizontalPadding * 2),
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.center,
                      child: Text(
                        title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: (availableHeight * 0.03).clamp(12.0, 20.0)),
                  // Content text
                  Text(
                    content,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey,
                    ),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: (availableHeight * 0.04).clamp(16.0, 30.0)),
                  // Responsive image
                  Image.asset(
                    imagePath,
                    height: imageHeight,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Helper function to build the dot indicators for the onboarding page.
  Widget buildDot(int index, BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: 10,
      width: _currentPage == index ? 20 : 10,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color:
            _currentPage == index ? Colors.deepPurple : Colors.deepPurple[200],
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}
