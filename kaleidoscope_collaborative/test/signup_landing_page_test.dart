import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kaleidoscope_collaborative/screens/SignUp/signupLandingPage.dart';
void main() {
    testWidgets('Sign Up Landing Page', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: SignupLandingPage()));

      // Verify that important widgets are present
      expect(find.text('Sign up Landing Page'), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
      expect(find.text('Sign Up'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton,'Sign Up in App'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton,'Sign Up with Facebook'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton,'Sign Up with Google'), findsOneWidget);
    });
}