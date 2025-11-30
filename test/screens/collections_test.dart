import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/screens/collections_page.dart';

void main() {
  group('Collections Page Tests', () {
    Widget createTestWidget() {
      return const MaterialApp(home: CollectionsPage());
    }

    testWidgets('should display header with announcement bar', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Check announcement bar
      expect(
        find.text(
            'BIG SALE! OUR ESSENTIAL RANGE HAS DROPPED IN PRICE! OVER 20% OFF!'),
        findsOneWidget,
      );

      // Check logo
      expect(find.text('upsu-store'), findsOneWidget);

      // Check navigation icons
      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byIcon(Icons.person_outline), findsOneWidget);
      expect(find.byIcon(Icons.shopping_bag_outlined), findsOneWidget);
    });

    testWidgets('should display page title', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      expect(
        find.text('Collections'),
        findsAtLeastNWidgets(1),
      );
    });

    testWidgets('should display all collection links', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Check for various collections
      expect(find.text('Essential Range'), findsOneWidget);
      expect(find.text('Signature Range'), findsOneWidget);
      expect(find.text('Portsmouth City Collection'), findsOneWidget);
      expect(find.text('Graduation'), findsOneWidget);
      expect(find.text('Merchandise'), findsOneWidget);
      expect(find.text('SALE'), findsOneWidget);
    });

    testWidgets('should display seasonal collections', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      expect(find.text('Autumn Favourites'), findsOneWidget);
      expect(find.text('Winter Favourites'), findsOneWidget);
      expect(find.text('Spring Favourites'), findsOneWidget);
      expect(find.text('Summer Favourites'), findsOneWidget);
    });

    testWidgets('should display special collections', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      expect(find.text('Black Friday'), findsOneWidget);
      expect(find.text('Pride Collection'), findsOneWidget);
      expect(find.text('UPSU Bears'), findsOneWidget);
    });

    testWidgets('should have scrollable content', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Verify SingleChildScrollView exists
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('should display footer', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Scroll to footer
      final scrollView = find.byType(SingleChildScrollView);
      await tester.drag(scrollView, const Offset(0, -3000));
      await tester.pumpAndSettle();

      // Check footer content
      expect(find.text('UPSU SHOP'), findsOneWidget);
    });

    testWidgets('collections should be tappable', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Find a collection card
      final essentialRange = find.text('Essential Range');
      expect(essentialRange, findsOneWidget);

      // Verify it's in a GestureDetector (tappable)
      final gestureDetector = find.ancestor(
        of: essentialRange,
        matching: find.byType(GestureDetector),
      );
      expect(gestureDetector, findsOneWidget);
    });

    testWidgets('should display collections in a grid layout', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Verify GridView exists
      expect(find.byType(GridView), findsOneWidget);
    });

    testWidgets('should display collection cards with images', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Check that collection cards have Stack layout for image + text overlay
      expect(find.byType(Stack), findsWidgets);
    });
  });
}
