import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/widgets/category_list_item.dart';

void main() {
  group('CategoryListItem Widget Tests', () {
    testWidgets('should display category title and description',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CategoryListItem(
              title: 'Test Category',
              description: 'Test Description',
              imageUrl: 'assets/images/category_clothing.png',
            ),
          ),
        ),
      );

      expect(find.text('Test Category'), findsOneWidget);
      expect(find.text('Test Description'), findsOneWidget);
    });

    testWidgets('should display arrow icon', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CategoryListItem(
              title: 'Test Category',
              description: 'Test Description',
              imageUrl: 'assets/images/category_clothing.png',
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.arrow_forward_ios), findsOneWidget);
    });

    testWidgets('should be tappable', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CategoryListItem(
              title: 'Test Category',
              description: 'Test Description',
              imageUrl: 'assets/images/category_clothing.png',
            ),
          ),
        ),
      );

      await tester.tap(find.byType(CategoryListItem));
      await tester.pumpAndSettle();

      // Verify widget is tappable (no errors thrown)
      expect(find.byType(CategoryListItem), findsOneWidget);
    });
  });
}
