import 'package:flutter/material.dart';
import 'package:kaleidoscope_collaborative/screens/HomeAndLanding/home_page.dart';
import 'package:kaleidoscope_collaborative/screens/ProfileCustomization/profile_customize_1_1.dart';

class CustomizeProfilePage extends StatelessWidget {
  const CustomizeProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double spacerHeight = height / 21;
    double halfSpacerHeight = height / 42;
    double screenWidth = MediaQuery.of(context).size.width;
    double containerWidth = screenWidth * (2 / 3);
    double padding = width / 24;
    print(padding);
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(padding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: spacerHeight),
            const Text(
              'Customize Profile',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
                fontSize: 32,
                height: 40 / 32,
                color: Colors.black,
                letterSpacing: 0.1,
              ),
            ),
            SizedBox(height: halfSpacerHeight),
            SizedBox(
              width: containerWidth,
              child: const Text(
                "These questions will make your experience with [app name] better by adding preset filters and other benefits...",
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  height: 24 / 16,
                  letterSpacing: 0.15,
                  color: Colors.black,
                ),
                softWrap: true,
              ),
            ),
            Expanded(
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const DashboardScreen()),
                          (Route<dynamic> route) =>
                              false, // Remove all routes beneath the new route
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF74777F), width: 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        minimumSize: const Size(84, 40),
                      ),
                      child: const Text(
                        'home',
                        style: TextStyle(
                          color: Color(0xFF275EA7),
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          height: 20 / 14,
                          letterSpacing: 0.1,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CustomizeProfilePage_1_1()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF275EA7),
                        side: const BorderSide(color: Color(0xFF275EA7), width: 1),
                        elevation: 0,
                        shape: const StadiumBorder(),
                        minimumSize: const Size(84, 40),
                      ),
                      child: const Text(
                        'Ready?',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          height: 20 / 14,
                          letterSpacing: 0.1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
