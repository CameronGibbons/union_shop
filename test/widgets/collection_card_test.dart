import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/widgets/collection_card.dart';

void main() {
  group('CollectionCard Widget Tests', () {
    testWidgets('should display collection title and subtitle', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 200,
              child: CollectionCard(
                title: 'Test Collection',
                subtitle: 'Test Subtitle',
                imageUrl: 'assets/images/category_clothing.png',
              ),
            ),
          ),
        ),
      );

      expect(find.text('Test Collection'), findsOneWidget);
      expect(find.text('Test Subtitle'), findsOneWidget);
    });

    testWidgets('should be tappable', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 200,
              child: CollectionCard(
                title: 'Test Collection',
                subtitle: 'Test Subtitle',
                imageUrl: 'assets/images/category_clothing.png',
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(CollectionCard));
      await tester.pumpAndSettle();

      // Verify widget is tappable (no errors thrown)
      expect(find.byType(CollectionCard), findsOneWidget);
    });
  });
}
