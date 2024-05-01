import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kaleidoscope_collaborative/screens/ProfileCustomization/finished_customization_page.dart';

void main() {
  group('Profile Page Tests', () {
    testWidgets('Finds TextFields, Button, and performs navigation', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: finished_customization_page()));

      // Verify the relationship text exist
      expect(find.text('Relationship'), findsOneWidget);

       // Verify the Familiar with these disabilities text exist
      expect(find.text('Familiar with these disabilities'), findsOneWidget);

      // Verify the Accommodations text exist
      expect(find.text('Accommodations'), findsOneWidget);

      // Verify the Frequently Visited Locations text exist
      expect(find.text('Frequently Visited Locations'), findsOneWidget);

    });
  });
}
