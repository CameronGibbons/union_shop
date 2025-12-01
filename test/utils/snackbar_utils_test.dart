import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/utils/snackbar_utils.dart';

void main() {
  group('SnackbarUtils', () {
    testWidgets('showAddedToCart displays snackbar with correct message',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    SnackbarUtils.showAddedToCart(
                      context,
                      'Test Product',
                      onViewCart: () {},
                    );
                  },
                  child: const Text('Add to Cart'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Add to Cart'));
      await tester.pump();

      expect(find.text('Added Test Product to cart'), findsOneWidget);
      expect(find.text('VIEW CART'), findsOneWidget);
    });

    testWidgets('showAddedToCart shows action button when callback provided',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    SnackbarUtils.showAddedToCart(
                      context,
                      'Test Product',
                      onViewCart: () {},
                    );
                  },
                  child: const Text('Add to Cart'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Add to Cart'));
      await tester.pump();

      expect(find.text('Added Test Product to cart'), findsOneWidget);
      expect(find.text('VIEW CART'), findsOneWidget);
    });

    testWidgets('showSuccess displays success snackbar',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    SnackbarUtils.showSuccess(context, 'Success message');
                  },
                  child: const Text('Show Success'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Success'));
      await tester.pump();

      expect(find.text('Success message'), findsOneWidget);
    });

    testWidgets('showError displays error snackbar',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    SnackbarUtils.showError(context, 'Error message');
                  },
                  child: const Text('Show Error'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Error'));
      await tester.pump();

      expect(find.text('Error message'), findsOneWidget);
    });

    testWidgets('showInfo displays info snackbar',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    SnackbarUtils.showInfo(context, 'Info message');
                  },
                  child: const Text('Show Info'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Info'));
      await tester.pump();

      expect(find.text('Info message'), findsOneWidget);
    });
  });
}
