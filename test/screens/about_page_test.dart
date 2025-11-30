import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/screens/about_page.dart';

void main() {
  group('AboutPage Tests', () {
    testWidgets('should display page title', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AboutPage(),
        ),
      );

      expect(find.text('About Us'), findsWidgets);
    });

    testWidgets('should display welcome message', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AboutPage(),
        ),
      );

      expect(find.text('Welcome to the Union Shop!'), findsOneWidget);
    });

    testWidgets('should display company description', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AboutPage(),
        ),
      );

      expect(
        find.textContaining('dedicated to giving you the very best'),
        findsOneWidget,
      );
      expect(
        find.textContaining('personalisation service'),
        findsOneWidget,
      );
    });

    testWidgets('should display team signature', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AboutPage(),
        ),
      );

      expect(find.text('Happy shopping!'), findsOneWidget);
      expect(
        find.text('The Union Shop & Reception Team'),
        findsOneWidget,
      );
    });

    testWidgets('should display opening hours section', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AboutPage(),
        ),
      );

      expect(find.text('Opening Hours'), findsAtLeastNWidgets(1));
      expect(find.text('Term Time'), findsOneWidget);
      expect(find.text('Monday - Friday 10am - 4pm'), findsAtLeastNWidgets(1));
      expect(find.text('Outside Term Time'), findsOneWidget);
      expect(find.text('Monday - Friday 10am - 3pm'), findsOneWidget);
      expect(find.text('Online Shopping'), findsOneWidget);
      expect(find.text('Available 24/7'), findsOneWidget);
    });

    testWidgets('should display contact information', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AboutPage(),
        ),
      );

      expect(find.text('Contact Us'), findsAtLeastNWidgets(1));
      expect(find.text('hello@upsu.net'), findsOneWidget);
      expect(
        find.text('University of Portsmouth Students\' Union'),
        findsAtLeastNWidgets(1),
      );
    });

    testWidgets('should display contact icons', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AboutPage(),
        ),
      );

      expect(find.byIcon(Icons.email_outlined), findsOneWidget);
      expect(find.byIcon(Icons.location_on_outlined), findsOneWidget);
    });

    testWidgets('should have back button in app bar', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AboutPage(),
        ),
      );

      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });

    testWidgets('should navigate back when back button is pressed',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AboutPage(),
                      ),
                    );
                  },
                  child: const Text('Go to About'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Go to About'));
      await tester.pumpAndSettle();

      expect(find.byType(AboutPage), findsOneWidget);

      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      expect(find.byType(AboutPage), findsNothing);
      expect(find.text('Go to About'), findsOneWidget);
    });

    testWidgets('should be scrollable', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AboutPage(),
        ),
      );

      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });
  });
}
