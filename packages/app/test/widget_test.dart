import 'package:cards_with_dart_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'CardsWithDartApp displays game state and allows turn interactions',
    (WidgetTester tester) async {
      await tester.pumpWidget(const CardsWithDartApp());

      expect(find.text('Cards with Dart'), findsOneWidget);
      expect(find.text('Your Hand'), findsOneWidget);
      expect(find.text('Hand: 1/4'), findsOneWidget);
      expect(find.text('Pass Turn'), findsOneWidget);

      // Tap Pass Turn to draw another card
      await tester.tap(find.text('Pass Turn'));
      await tester.pump();

      expect(find.text('Hand: 2/4'), findsOneWidget);

      // Tap New Game icon button to reset
      await tester.tap(find.byIcon(Icons.refresh));
      await tester.pump();

      expect(find.text('Hand: 1/4'), findsOneWidget);
    },
  );
}
