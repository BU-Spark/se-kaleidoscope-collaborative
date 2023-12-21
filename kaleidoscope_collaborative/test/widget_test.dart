// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kaleidoscope_collaborative/screens/first_screen.dart';

import 'package:kaleidoscope_collaborative/screens/main.dart';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kaleidoscope_collaborative/screens/SignupLandingPage.dart';
import 'package:kaleidoscope_collaborative/screens/LoggingIn/login_screen.dart';
import 'package:mockito/mockito.dart';


import 'package:mockito/mockito.dart';
// Import the `any` matcher for null-safety
import 'package:mockito/annotations.dart';

// Use @GenerateMocks to generate the MockNavigatorObserver class
// @GenerateMocks([NavigatorObserver])


// class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  // Mock Firebase initialization before running the tests
  // setUpAll(() async {
  //   TestWidgetsFlutterBinding.ensureInitialized();
  //   await Firebase.initializeApp(
  //     options: DefaultFirebaseOptions.currentPlatform,
  //   );
  // });

  testWidgets('MyApp loads FirstScreen as the home', (WidgetTester tester) async {
    // Testing main.dart
    // This will test whether your FirstScreen widget is being loaded as the home screen in your MyApp widget
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());
    // Verify that FirstScreen is loaded.
    expect(find.byType(FirstScreen), findsOneWidget);
  });


  // Testing first_screen.dart
  testWidgets('FirstScreen UI Test', (WidgetTester tester) async {
    // Create the widget by telling the tester to build it
    await tester.pumpWidget(MaterialApp(home: FirstScreen()));

    // Verify the title is displayed
    expect(find.text('Kaleidoscope Collaborative'), findsOneWidget);

    // Verify the logo is displayed
    expect(find.byType(Image), findsOneWidget);

    // Verify the main message is displayed
    expect(find.text('Discover Disability Inclusive\nServices Around You!'), findsOneWidget);

    // Verify the 'Sign Up' button is displayed
    expect(find.widgetWithText(ElevatedButton, 'Sign Up'), findsOneWidget);

    // Verify the 'Log In' button is displayed
    expect(find.widgetWithText(ElevatedButton, 'Log In'), findsOneWidget);

    // Verify the 'Skip for now' text button is displayed
    expect(find.widgetWithText(TextButton, 'Skip for now'), findsOneWidget);
  });


  // Testing login_screen UI
}

