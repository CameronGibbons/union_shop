import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/screens/about_page.dart';
import '../test_helpers.dart';

void main() {
  group('AboutPage Tests', () {
    Widget createTestWidget() {
      return createTestApp(const AboutPage());
    }

    testWidgetsWithLargeViewport('should display page title', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('About Us'), findsWidgets);
    });

    testWidgetsWithLargeViewport('should display welcome message', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Welcome to the Union Shop!'), findsOneWidget);
    });

    testWidgetsWithLargeViewport('should display company description', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(
        find.textContaining('dedicated to giving you the very best'),
        findsOneWidget,
      );
      expect(
        find.textContaining('personalisation service'),
        findsOneWidget,
      );
    });

    testWidgetsWithLargeViewport('should display team signature', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Happy shopping!'), findsOneWidget);
      expect(
        find.text('The Union Shop & Reception Team'),
        findsOneWidget,
      );
    });

    testWidgetsWithLargeViewport('should display opening hours section', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Opening Hours'), findsAtLeastNWidgets(1));
      expect(find.text('Term Time'), findsOneWidget);
      expect(find.text('Monday - Friday 10am - 4pm'), findsAtLeastNWidgets(1));
      expect(find.text('Outside Term Time'), findsOneWidget);
      expect(find.text('Monday - Friday 10am - 3pm'), findsOneWidget);
      expect(find.text('Online Shopping'), findsOneWidget);
      expect(find.text('Available 24/7'), findsOneWidget);
    });

    testWidgetsWithLargeViewport('should display contact information', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Contact Us'), findsAtLeastNWidgets(1));
      expect(find.text('hello@upsu.net'), findsOneWidget);
      expect(
        find.text('University of Portsmouth Students\' Union'),
        findsAtLeastNWidgets(1),
      );
    });

    testWidgetsWithLargeViewport('should display contact icons', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.email_outlined), findsOneWidget);
      expect(find.byIcon(Icons.location_on_outlined), findsOneWidget);
    });

    testWidgetsWithLargeViewport('should have navbar', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AboutPage(),
        ),
      );

      // AboutPage uses Navbar instead of AppBar with back button
      expect(find.byType(Image), findsWidgets);
    });

    testWidgetsWithLargeViewport('should be scrollable', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AboutPage(),
        ),
      );

      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });
  });
}
