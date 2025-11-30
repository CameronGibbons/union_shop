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
      expect(
          find.text(
              'BIG SALE! OUR ESSENTIAL RANGE HAS DROPPED IN PRICE! OVER 20% OFF!'),
          findsOneWidget);

      // Check navigation icons
      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byIcon(Icons.person_outline), findsOneWidget);
      expect(find.byIcon(Icons.shopping_bag_outlined), findsOneWidget);
    });

    testWidgets('should display hero banner with call-to-action',
        (tester) async {
      await tester.pumpWidget(const UnionShopApp());
      await tester.pump();

      // Check hero section text
      expect(find.text('Essential Range - Over 20% OFF!'), findsOneWidget);
      expect(
        find.text(
            'Over 20% off our Essential Range. Come and grab yours while stock lasts!'),
        findsOneWidget,
      );
      expect(find.text('BROWSE COLLECTION'), findsOneWidget);
    });

    testWidgets('should display featured collections section', (tester) async {
      await tester.pumpWidget(const UnionShopApp());
      await tester.pump();

      // Check section title
      expect(find.text('ESSENTIAL RANGE - OVER 20% OFF!'), findsOneWidget);

      // Check product cards with sale prices
      expect(
          find.text('Limited Edition Essential Zip Hoodies'), findsOneWidget);
      expect(find.text('Essential T-Shirt'), findsOneWidget);
    });

    testWidgets('should display best sellers section', (tester) async {
      await tester.pumpWidget(const UnionShopApp());
      await tester.pump();

      // Check section title
      expect(find.text('SIGNATURE RANGE'), findsOneWidget);

      // Check product cards
      expect(find.text('Signature Hoodie'), findsOneWidget);
      expect(find.text('Signature T-Shirt'), findsOneWidget);

      // Check prices
      expect(find.text('£32.99'), findsOneWidget);
      expect(find.text('£14.99'), findsAtLeastNWidgets(1));
    });

    testWidgets('should display categories section', (tester) async {
      await tester.pumpWidget(const UnionShopApp());
      await tester.pump();

      // Check section title
      expect(find.text('OUR RANGE'), findsOneWidget);

      // Check category items
      expect(find.text('Clothing'), findsOneWidget);
      expect(find.text('Merchandise'), findsOneWidget);
      expect(find.text('Graduation'), findsOneWidget);
      expect(find.text('SALE'), findsAtLeastNWidgets(1));
    });

    testWidgets('should display Portsmouth City Collection section',
        (tester) async {
      await tester.pumpWidget(const UnionShopApp());
      await tester.pump();

      // Check section title
      expect(find.text('PORTSMOUTH CITY COLLECTION'), findsOneWidget);

      // Check product cards
      expect(find.text('Portsmouth City Postcard'), findsOneWidget);
      expect(find.text('Portsmouth City Magnet'), findsOneWidget);
      expect(find.text('Portsmouth City Bookmark'), findsOneWidget);
      expect(find.text('Portsmouth City Notebook'), findsOneWidget);

      // Check view all button
      expect(find.text('View all products in the Portsmouth City Collection'),
          findsOneWidget);
    });

    testWidgets('should display Print Shack section', (tester) async {
      await tester.pumpWidget(const UnionShopApp());
      await tester.pumpAndSettle();

      // Scroll to Print Shack section
      final scrollView = find.byType(SingleChildScrollView);
      await tester.drag(scrollView, const Offset(0, -2000));
      await tester.pumpAndSettle();

      // Check Print Shack content
      expect(find.text('Add a Personal Touch'), findsOneWidget);
      expect(find.text('CLICK HERE TO ADD TEXT!'), findsOneWidget);
      expect(find.text('Opening Hours'), findsAtLeastNWidgets(1));
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

      // Scroll down to ensure product card is visible
      final scrollView = find.byType(SingleChildScrollView);
      await tester.drag(scrollView, const Offset(0, -800));
      await tester.pumpAndSettle();

      // Find product card by type and tap the first one
      final productCards = find.byType(ProductCard);
      expect(productCards, findsWidgets);

      await tester.tap(productCards.first, warnIfMissed: false);
      await tester.pumpAndSettle();

      // Verify navigation to product page by checking for product page content
      expect(find.text('Placeholder Product Name'), findsOneWidget);
    });

    testWidgets('should have scrollable content', (tester) async {
      await tester.pumpWidget(const UnionShopApp());
      await tester.pump();

      // Verify SingleChildScrollView exists
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });
  });
}
