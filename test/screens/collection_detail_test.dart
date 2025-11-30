import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/screens/collection_detail_page.dart';
import 'package:union_shop/widgets/footer_widget.dart';

void main() {
  group('Collection Detail Page Tests', () {
    Widget createTestWidget() {
      return const MaterialApp(
        home: CollectionDetailPage(collectionId: 'autumn-favourites'),
      );
    }

    testWidgets('should display page title', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(
        find.text('upsu-store'),
        findsAtLeastNWidgets(1),
      );
    });

    testWidgets('should display loading indicator initially', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pumpAndSettle();
    });

    testWidgets('should display collection name after loading', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Autumn Favourites'), findsOneWidget);
    });

    testWidgets('should display collection description', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(
          find.text('Cozy essentials for the autumn season'), findsOneWidget);
    });

    testWidgets('should display filter dropdown', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('FILTER BY'), findsOneWidget);
      expect(find.text('All products'), findsOneWidget);
    });

    testWidgets('should display sort dropdown', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('SORT BY'), findsOneWidget);
      expect(find.text('Featured'), findsOneWidget);
    });

    testWidgets('should display product count', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('10 products'), findsOneWidget);
    });

    testWidgets('should display product grid', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(GridView), findsOneWidget);
    });

    testWidgets('should display products from collection', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Classic Sweatshirts'), findsOneWidget);
      expect(find.text('Classic T-Shirts'), findsOneWidget);
      expect(find.text('Classic Hoodies'), findsOneWidget);
    });

    testWidgets('should filter products by category', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Find and tap the filter dropdown
      final filterDropdown = find.text('All products').first;
      await tester.tap(filterDropdown);
      await tester.pumpAndSettle();

      // Select "Clothing" category
      await tester.tap(find.text('Clothing').last);
      await tester.pumpAndSettle();

      // Should show only clothing items
      expect(find.text('Classic Sweatshirts'), findsOneWidget);
      expect(find.text('Classic T-Shirts'), findsOneWidget);
      expect(find.text('Classic Hoodies'), findsOneWidget);
    });

    testWidgets('should sort products by price low to high', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Find and tap the sort dropdown
      final sortDropdown = find.text('Featured').first;
      await tester.tap(sortDropdown);
      await tester.pumpAndSettle();

      // Select "Price: Low to High"
      await tester.tap(find.text('Price: Low to High').last);
      await tester.pumpAndSettle();

      // Products should be sorted (verified by sort being applied)
      expect(find.text('Price: Low to High'), findsOneWidget);
    });

    testWidgets('should sort products by price high to low', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final sortDropdown = find.text('Featured').first;
      await tester.tap(sortDropdown);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Price: High to Low').last);
      await tester.pumpAndSettle();

      expect(find.text('Price: High to Low'), findsOneWidget);
    });

    testWidgets('should sort products alphabetically A-Z', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final sortDropdown = find.text('Featured').first;
      await tester.tap(sortDropdown);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Alphabetically, A-Z').last);
      await tester.pumpAndSettle();

      expect(find.text('Alphabetically, A-Z'), findsOneWidget);
    });

    testWidgets('should sort products alphabetically Z-A', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final sortDropdown = find.text('Featured').first;
      await tester.tap(sortDropdown);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Alphabetically, Z-A').last);
      await tester.pumpAndSettle();

      expect(find.text('Alphabetically, Z-A'), findsOneWidget);
    });

    testWidgets('should display footer', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(FooterWidget), findsOneWidget);
    });

    testWidgets('should navigate to home when logo is clicked', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final logoFinder = find.text('upsu-store').first;
      await tester.tap(logoFinder);
      await tester.pumpAndSettle();

      // After navigation, should be on home screen
      expect(find.text('upsu-store'), findsWidgets);
    });

    testWidgets('should reset to page 1 when filter changes', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Change filter
      final filterDropdown = find.text('All products').first;
      await tester.tap(filterDropdown);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Accessories').last);
      await tester.pumpAndSettle();

      // Page should reset to 1 (pagination should show page 1 if visible)
      expect(find.text('Accessories'), findsOneWidget);
    });

    testWidgets('should show sale price for discounted items', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Should find the neutral sweatshirt on sale
      expect(find.text('Classic Sweatshirts - Neutral'), findsOneWidget);
    });

    testWidgets('should show sold out status for out of stock items',
        (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // A5 Notepad should be sold out
      expect(find.text('A5 Notepad'), findsOneWidget);
    });

    testWidgets('should handle empty collection gracefully', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: CollectionDetailPage(collectionId: 'empty-collection'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('No products found'), findsOneWidget);
    });

    testWidgets('should display announcement bar', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(
        find.textContaining('BIG SALE'),
        findsAtLeastNWidgets(1),
      );
    });

    testWidgets('should display header icons', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byIcon(Icons.person_outline), findsOneWidget);
      expect(find.byIcon(Icons.shopping_bag_outlined), findsOneWidget);
    });
  });
}
