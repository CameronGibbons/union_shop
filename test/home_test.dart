import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/main.dart';
import 'package:union_shop/widgets/product_card.dart';

void main() {
  group('Home Page Tests', () {
    testWidgets('should display header with announcement bar and navigation',
        (tester) async {
      await tester.pumpWidget(const UnionShopApp());
      await tester.pump();

      // Check announcement bar
      expect(find.text('🎓 STUDENT DISCOUNT AVAILABLE'), findsOneWidget);

      // Check navigation icons
      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byIcon(Icons.person_outline), findsOneWidget);
      expect(find.byIcon(Icons.shopping_bag_outlined), findsOneWidget);
      expect(find.byIcon(Icons.menu), findsOneWidget);
    });

    testWidgets('should display hero banner with call-to-action',
        (tester) async {
      await tester.pumpWidget(const UnionShopApp());
      await tester.pump();

      // Check hero section text
      expect(find.text('WELCOME TO UPSU SHOP'), findsOneWidget);
      expect(
        find.text(
            'Official University of Portsmouth Students\' Union Merchandise'),
        findsOneWidget,
      );
      expect(find.text('SHOP NOW'), findsOneWidget);
    });

    testWidgets('should display featured collections section', (tester) async {
      await tester.pumpWidget(const UnionShopApp());
      await tester.pump();

      // Check section title
      expect(find.text('FEATURED COLLECTIONS'), findsOneWidget);
      expect(
        find.text('Explore our most popular product ranges'),
        findsOneWidget,
      );

      // Check collection cards
      expect(find.text('Essential Range'), findsOneWidget);
      expect(find.text('Signature Collection'), findsOneWidget);
      expect(find.text('Portsmouth Gifts'), findsOneWidget);
      expect(find.text('Sale Items'), findsOneWidget);
    });

    testWidgets('should display best sellers section', (tester) async {
      await tester.pumpWidget(const UnionShopApp());
      await tester.pump();

      // Check section title
      expect(find.text('BEST SELLERS'), findsOneWidget);

      // Check product cards
      expect(find.text('Essential Hoodie'), findsOneWidget);
      expect(find.text('Essential T-Shirt'), findsOneWidget);
      expect(find.text('Signature Hoodie'), findsOneWidget);
      expect(find.text('Signature T-Shirt'), findsOneWidget);

      // Check prices
      expect(find.text('£35.00'), findsOneWidget);
      expect(find.text('£18.00'), findsOneWidget);
      expect(find.text('£42.00'), findsOneWidget);
      expect(find.text('£22.00'), findsOneWidget);

      // Check view all button
      expect(find.text('VIEW ALL PRODUCTS'), findsOneWidget);
    });

    testWidgets('should display categories section', (tester) async {
      await tester.pumpWidget(const UnionShopApp());
      await tester.pump();

      // Check section title
      expect(find.text('SHOP BY CATEGORY'), findsOneWidget);

      // Check category items
      expect(find.text('Clothing'), findsOneWidget);
      expect(find.text('Merchandise'), findsOneWidget);
      expect(find.text('Graduation'), findsOneWidget);
      expect(find.text('Sale'), findsAtLeastNWidgets(1));

      // Check category descriptions
      expect(find.text('Hoodies, T-Shirts & More'), findsOneWidget);
      expect(find.text('Gifts & Accessories'), findsOneWidget);
      expect(find.text('Celebrate Your Achievement'), findsOneWidget);
      expect(find.text('Limited Time Offers'), findsOneWidget);
    });

    testWidgets('should display footer', (tester) async {
      await tester.pumpWidget(const UnionShopApp());
      await tester.pump();

      // Check footer content
      expect(find.text('UPSU SHOP'), findsOneWidget);
      expect(
        find.text('University of Portsmouth Students\' Union'),
        findsOneWidget,
      );
      expect(find.text('About Us'), findsOneWidget);
      expect(find.text('© 2025 UPSU. All rights reserved.'), findsOneWidget);
    });

    testWidgets('should display comprehensive footer', (tester) async {
      await tester.pumpWidget(const UnionShopApp());
      await tester.pumpAndSettle();

      // Scroll to footer
      final scrollView = find.byType(SingleChildScrollView);
      await tester.drag(scrollView, const Offset(0, -4000));
      await tester.pumpAndSettle();

      // Verify footer content
      expect(find.text('UPSU SHOP'), findsOneWidget);
      expect(find.text('Quick Links'), findsOneWidget);
      expect(find.text('Help & Information'), findsOneWidget);
      expect(find.text('Follow Us'), findsOneWidget);
      expect(find.text('© 2025 UPSU. All rights reserved.'), findsOneWidget);
    });

    testWidgets('should navigate to product page when product card is tapped',
        (tester) async {
      await tester.pumpWidget(const UnionShopApp());
      await tester.pumpAndSettle();

      // Scroll down more to ensure product card is visible
      final scrollView = find.byType(SingleChildScrollView);
      await tester.drag(scrollView, const Offset(0, -1500));
      await tester.pumpAndSettle();

      // Find product card by type and tap the first one
      final productCards = find.byType(ProductCard);
      expect(productCards, findsWidgets);

      await tester.tap(productCards.first);
      await tester.pumpAndSettle();

      // Verify navigation to product page by checking for product page content
      expect(find.text('Placeholder Product Name'), findsOneWidget);
      expect(find.text('Description'), findsOneWidget);
    });

    testWidgets('should have scrollable content', (tester) async {
      await tester.pumpWidget(const UnionShopApp());
      await tester.pump();

      // Verify SingleChildScrollView exists
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });
  });
}
