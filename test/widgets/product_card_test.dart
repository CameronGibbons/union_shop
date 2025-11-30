import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/widgets/product_card.dart';

void main() {
  group('ProductCard Widget Tests', () {
    testWidgets('should display product title, price, and image',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 300,
              child: ProductCard(
                title: 'Test Product',
                price: '£25.00',
                imageUrl: 'assets/images/essential_hoodie.png',
              ),
            ),
          ),
        ),
      );

      expect(find.text('Test Product'), findsOneWidget);
      expect(find.text('£25.00'), findsOneWidget);
    });

    testWidgets('should navigate to product page when tapped', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const Scaffold(
            body: SizedBox(
              height: 300,
              child: ProductCard(
                title: 'Test Product',
                price: '£25.00',
                imageUrl: 'assets/images/essential_hoodie.png',
              ),
            ),
          ),
          routes: {
            '/product': (context) => const Scaffold(
                  body: Center(child: Text('Product Page')),
                ),
          },
        ),
      );

      await tester.tap(find.byType(ProductCard));
      await tester.pumpAndSettle();

      expect(find.text('Product Page'), findsOneWidget);
    });
  });
}
