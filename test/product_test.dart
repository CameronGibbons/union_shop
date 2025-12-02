import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/screens/product_page.dart';
import 'package:union_shop/widgets/footer_widget.dart';
import 'test_helpers.dart';

void main() {
  group('Product Page Tests', () {
    Widget createTestWidget() {
      return createTestApp(const ProductPage(productId: 'classic-sweatshirt'));
    }

    testWidgetsWithLargeViewport('should display loading indicator initially', (tester) async {      
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pumpAndSettle();
    });

    testWidgetsWithLargeViewport('should display product page with basic elements',
        (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(Image), findsWidgets);
      expect(find.text('Classic Sweatshirts'), findsOneWidget);
      expect(find.text('£23.00'), findsOneWidget);
      expect(find.text('Tax included.'), findsOneWidget);
    });

    testWidgetsWithLargeViewport('should display color dropdown', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Color'), findsOneWidget);
      expect(find.byType(DropdownButton<String>), findsAtLeastNWidgets(1));
    });

    testWidgetsWithLargeViewport('should display size dropdown', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Size'), findsOneWidget);
      expect(find.byType(DropdownButton<String>), findsAtLeastNWidgets(2));
    });

    testWidgetsWithLargeViewport('should display quantity counter', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Quantity'), findsOneWidget);
      expect(find.text('1'), findsOneWidget); // Default quantity
      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.byIcon(Icons.remove), findsOneWidget);
    });

    testWidgetsWithLargeViewport('should increment quantity when plus button is tapped',
        (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Scroll to make the quantity controls visible
      await tester.drag(
          find.byType(SingleChildScrollView), const Offset(0, -800));
      await tester.pumpAndSettle();

      // Find and tap the increment button
      final incrementButton = find.byIcon(Icons.add);
      await tester.tap(incrementButton);
      await tester.pump();

      // Quantity should now be 2
      expect(find.text('2'), findsOneWidget);
    });

    testWidgetsWithLargeViewport('should decrement quantity when minus button is tapped',
        (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // First increment to 2
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      // Then decrement back to 1
      await tester.tap(find.byIcon(Icons.remove));
      await tester.pump();

      expect(find.text('1'), findsOneWidget);
    });

    testWidgetsWithLargeViewport('should not decrement quantity below 1', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Try to decrement from 1
      final decrementButton = find.byIcon(Icons.remove);
      await tester.tap(decrementButton);
      await tester.pump();

      // Should still be 1
      expect(find.text('1'), findsOneWidget);
    });

    testWidgetsWithLargeViewport('should have color dropdown with selectable options',
        (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Find the color dropdown
      final colorDropdowns = find.byType(DropdownButton<String>);
      expect(colorDropdowns, findsAtLeastNWidgets(1));

      // Verify color label exists
      expect(find.text('Color'), findsOneWidget);
      // Verify a color is selected (Green is default)
      expect(find.text('Green'), findsOneWidget);
    });

    testWidgetsWithLargeViewport('should display ADD TO CART button', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('ADD TO CART'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsAtLeastNWidgets(1));
    });

    testWidgetsWithLargeViewport('should display header icons', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byIcon(Icons.person_outline), findsOneWidget);
      expect(find.byIcon(Icons.shopping_bag_outlined), findsOneWidget);
    });

    testWidgetsWithLargeViewport('should display footer', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(FooterWidget), findsOneWidget);
    });

    testWidgetsWithLargeViewport('should display back button', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('BACK TO AUTUMN FAVOURITES'), findsOneWidget);
    });

    testWidgetsWithLargeViewport('should display image carousel navigation', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.chevron_left), findsOneWidget);
      expect(find.byIcon(Icons.chevron_right), findsOneWidget);
    });

    testWidgetsWithLargeViewport('should display product description', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Comfortable classic sweatshirt'), findsOneWidget);
    });
  });
}
