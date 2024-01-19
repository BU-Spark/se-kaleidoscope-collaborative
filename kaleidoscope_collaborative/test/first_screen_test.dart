// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kaleidoscope_collaborative/screens/firebase_options.dart';
import 'package:kaleidoscope_collaborative/screens/first_screen.dart';




// class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {

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

}

