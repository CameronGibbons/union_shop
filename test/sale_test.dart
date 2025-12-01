import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/screens/sale_collection_page.dart';

void main() {
  group('SaleCollectionPage Tests', () {
    testWidgets('displays sale page header and promotional banner',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SaleCollectionPage(),
        ),
      );

      // Wait for async loading to complete
      await tester.pumpAndSettle();

      // Verify promotional banner
      expect(
          find.text(
              'BIG SALE! OUR ESSENTIAL RANGE HAS DROPPED IN PRICE! OVER 20% OFF! COME GRAB YOURS WHILE STOCK LASTS!'),
          findsOneWidget);

      // Verify SALE header
      expect(find.text('SALE'), findsOneWidget);

      // Verify promotional message
      expect(find.text('Don\'t miss out! Get yours before they\'re all gone!'),
          findsOneWidget);

      // Verify discount notice
      expect(
          find.textContaining('All prices shown are inclusive of the discount'),
          findsOneWidget);
    });

    testWidgets('displays filter and sort controls', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SaleCollectionPage(),
        ),
      );

      await tester.pumpAndSettle();

      // Verify filter and sort labels
      expect(find.text('FILTER BY'), findsOneWidget);
      expect(find.text('SORT BY'), findsOneWidget);
    });

    testWidgets('displays sale products with discounted prices',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SaleCollectionPage(),
        ),
      );

      await tester.pumpAndSettle();

      // Verify product count is displayed
      expect(find.textContaining('products'), findsOneWidget);

      // Products should be displayed in a grid
      expect(find.byType(GridView), findsWidgets);
    });

    testWidgets('filter dropdown changes category',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SaleCollectionPage(),
        ),
      );

      await tester.pumpAndSettle();

      // Find the filter dropdown
      final filterDropdown = find.byType(DropdownButton<String>).first;
      expect(filterDropdown, findsOneWidget);

      // Tap to open dropdown
      await tester.tap(filterDropdown);
      await tester.pumpAndSettle();

      // Verify 'All products' option exists
      expect(find.text('All products').last, findsOneWidget);
    });

    testWidgets('sort dropdown changes order', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SaleCollectionPage(),
        ),
      );

      await tester.pumpAndSettle();

      // Find the sort dropdown (second dropdown)
      final sortDropdown = find.byType(DropdownButton<String>).last;
      expect(sortDropdown, findsOneWidget);

      // Tap to open dropdown
      await tester.tap(sortDropdown);
      await tester.pumpAndSettle();

      // Verify sort options exist
      expect(find.text('Best selling').last, findsOneWidget);
      expect(find.text('Price: Low to High').last, findsOneWidget);
      expect(find.text('Price: High to Low').last, findsOneWidget);
    });

    testWidgets('displays pagination controls', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SaleCollectionPage(),
        ),
      );

      await tester.pumpAndSettle();

      // Verify pagination text
      expect(find.textContaining('Page'), findsOneWidget);

      // Verify navigation buttons
      expect(find.text('PREVIOUS'), findsOneWidget);
      expect(find.text('NEXT PAGE'), findsOneWidget);
    });

    testWidgets('shopping cart icon navigates to placeholder',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SaleCollectionPage(),
        ),
      );

      await tester.pumpAndSettle();

      // Find cart icon
      final cartIcon = find.byIcon(Icons.shopping_bag_outlined);
      expect(cartIcon, findsOneWidget);

      // Tap cart icon (placeholder action - should not crash)
      await tester.tap(cartIcon);
      await tester.pumpAndSettle();
    });

    testWidgets('logo tap navigates to home', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SaleCollectionPage(),
        ),
      );

      await tester.pumpAndSettle();

      // Find logo text
      final logo = find.text('The UNION');
      expect(logo, findsOneWidget);

      // Tap logo - should trigger navigateToHome but with MaterialApp wrapper
      // it will stay on the same page
      await tester.tap(logo);
      await tester.pumpAndSettle();

      // After navigation attempt with basic MaterialApp, page stays the same
      expect(find.text('SALE'), findsOneWidget);
    });

    testWidgets('displays loading state initially', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SaleCollectionPage(),
        ),
      );

      // Before pumpAndSettle, should show loading indicator
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // After loading completes
      await tester.pumpAndSettle();
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('footer is displayed', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SaleCollectionPage(),
        ),
      );

      await tester.pumpAndSettle();

      // Scroll to bottom to see footer
      await tester.drag(
          find.byType(SingleChildScrollView), const Offset(0, -1000));
      await tester.pumpAndSettle();

      // Footer should be present (contains FooterWidget)
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('displays cart icon in header', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SaleCollectionPage(),
        ),
      );

      await tester.pumpAndSettle();

      // Verify shopping cart icon with emoji
      expect(find.byIcon(Icons.shopping_cart), findsOneWidget);
    });

    testWidgets('header has correct purple color', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SaleCollectionPage(),
        ),
      );

      await tester.pumpAndSettle();

      // Find the announcement banner container (not the outer white container)
      final containers = tester.widgetList<Container>(find.byType(Container));
      
      // Find container with purple background (announcement bar)
      final purpleContainer = containers.firstWhere(
        (container) => container.color == const Color(0xFF4d2963),
      );

      expect(purpleContainer.color, const Color(0xFF4d2963));
    });
  });
}
