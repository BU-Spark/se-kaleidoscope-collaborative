import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kaleidoscope_collaborative/screens/LoggingIn/create_password.dart';
import 'package:kaleidoscope_collaborative/screens/LoggingIn/reset_complete.dart';

void main() {
  group('CreatePassword Screen Tests', () {
    testWidgets('Finds TextFields, Button, and performs navigation', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: CreatePassword()));

      // Verify the presence of two TextFields
      expect(find.byType(TextField), findsNWidgets(2));

      // Verify the presence of the 'Reset Password' button
      expect(find.widgetWithText(ElevatedButton, 'Reset Password'), findsOneWidget);

      // Tap the 'Reset Password' button
      await tester.tap(find.widgetWithText(ElevatedButton, 'Reset Password'));

    });
  });
}

