import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/widgets/product_card.dart';
import '../test_helpers.dart';

void main() {
  group('ProductCard Widget Tests', () {
    testWidgetsWithLargeViewport('should display product title, price, and image',
        (tester) async {
      await tester.pumpWidget(
        createTestApp(
          Scaffold(
            body: GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 0.7,  // Allow more vertical space for content
              children: const [
                ProductCard(
                  title: 'Test Product',
                  price: '£25.00',
                  imageUrl: 'assets/images/essential_hoodie.png',
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Test Product'), findsOneWidget);
      expect(find.text('£25.00'), findsOneWidget);
    });

    testWidgetsWithLargeViewport('should show sold out when isSoldOut is true', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          Scaffold(
            body: GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 0.7,  // Allow more vertical space for content
              children: const [
                ProductCard(
                  title: 'Test Product',
                  price: '£25.00',
                  imageUrl: 'assets/images/essential_hoodie.png',
                  isSoldOut: true,
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Sold out'), findsOneWidget);
      expect(find.text('Test Product'), findsOneWidget);
    });
  });
}
