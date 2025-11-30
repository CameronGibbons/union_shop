import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/widgets/footer_widget.dart';

void main() {
  testWidgets('FooterWidget displays shop name', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: FooterWidget(),
          ),
        ),
      ),
    );

    expect(find.text('UPSU SHOP'), findsOneWidget);
    expect(
        find.text('University of Portsmouth Students\' Union'), findsOneWidget);
  });

  testWidgets('FooterWidget displays Quick Links section',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: FooterWidget(),
          ),
        ),
      ),
    );

    expect(find.text('Quick Links'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('About Us'), findsOneWidget);
    expect(find.text('Sale'), findsOneWidget);
    expect(find.text('Collections'), findsOneWidget);
  });

  testWidgets('FooterWidget displays Help & Information section',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: FooterWidget(),
          ),
        ),
      ),
    );

    expect(find.text('Help & Information'), findsOneWidget);
    expect(find.text('Search'), findsOneWidget);
    expect(find.text('Contact Us'), findsOneWidget);
    expect(find.text('Terms & Conditions'), findsOneWidget);
    expect(find.text('Privacy Policy'), findsOneWidget);
  });

  testWidgets('FooterWidget displays social media section',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: FooterWidget(),
          ),
        ),
      ),
    );

    expect(find.text('Follow Us'), findsOneWidget);
    expect(find.byIcon(Icons.facebook), findsOneWidget);
    expect(find.byIcon(Icons.camera_alt), findsOneWidget);
    expect(find.byIcon(Icons.play_arrow), findsOneWidget);
  });

  testWidgets('FooterWidget displays opening hours',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: FooterWidget(),
          ),
        ),
      ),
    );

    expect(find.text('Opening Hours'), findsOneWidget);
    expect(find.text('Monday - Friday: 10am - 4pm'), findsOneWidget);
    expect(find.text('Online: 24/7'), findsOneWidget);
  });

  testWidgets('FooterWidget displays copyright', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: FooterWidget(),
          ),
        ),
      ),
    );

    expect(find.text('© 2025 UPSU. All rights reserved.'), findsOneWidget);
  });

  testWidgets('FooterWidget has dark background color',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: FooterWidget(),
          ),
        ),
      ),
    );

    final Container container = tester.widget(find.byType(Container).first);
    expect(container.color, const Color(0xFF2c2c2c));
  });

  testWidgets('Social media icons are tappable', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: FooterWidget(),
          ),
        ),
      ),
    );

    // Tap Facebook icon
    await tester.tap(find.byIcon(Icons.facebook));
    await tester.pumpAndSettle();

    // Tap Instagram icon
    await tester.tap(find.byIcon(Icons.camera_alt));
    await tester.pumpAndSettle();

    // Tap Twitter icon
    await tester.tap(find.byIcon(Icons.play_arrow));
    await tester.pumpAndSettle();

    // No errors should occur
  });
}
