import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/screens/about_page.dart';
import 'package:union_shop/screens/account_page.dart';
import 'package:union_shop/screens/cart_page.dart';
import 'package:union_shop/screens/collection_detail_page.dart';
import 'package:union_shop/screens/collections_page.dart';
import 'package:union_shop/screens/sale_collection_page.dart';

/// Creates a MaterialApp with all necessary routes for testing
/// This prevents navigation errors in tests
Widget createTestApp(Widget home) {
  return MaterialApp(
      home: home,
      routes: {
      '/cart': (context) => const CartPage(),
      '/search': (context) => const Scaffold(body: Center(child: Text('Search Page'))),
      '/login': (context) => const Scaffold(body: Center(child: Text('Login Page'))),
      '/account': (context) => const AccountPage(),
      '/collections': (context) => const CollectionsPage(),
      '/sale': (context) => const SaleCollectionPage(),
      '/about': (context) => const AboutPage(),
      '/print-shack': (context) => const Scaffold(body: Center(child: Text('Print Shack'))),
      '/print-shack-info': (context) => const Scaffold(body: Center(child: Text('Print Shack Info'))),
    },
    onGenerateRoute: (settings) {
      // Handle dynamic routes for collections and products
      if (settings.name != null) {
        if (settings.name!.startsWith('/collection/')) {
          final collectionId = settings.name!.split('/').last;
          return MaterialPageRoute(
            builder: (context) => CollectionDetailPage(collectionId: collectionId),
            settings: settings,
          );
        }
        if (settings.name!.startsWith('/product/')) {
          // Return a placeholder for product pages in tests
          return MaterialPageRoute(
            builder: (context) => const Scaffold(
              body: Center(child: Text('Product Page')),
            ),
            settings: settings,
          );
        }
      }
      return null;
    },
  );
}

/// Sets up a larger viewport for tests to prevent navbar overflow
/// Call this before pumpWidget in tests that render the full app with navbar
void setUpLargeViewport(WidgetTester tester) {
  tester.view.physicalSize = const Size(1200, 900);
  tester.view.devicePixelRatio = 1.0;
}

/// Resets viewport to default size
void tearDownViewport(WidgetTester tester) {
  tester.view.resetPhysicalSize();
  tester.view.resetDevicePixelRatio();
}

/// Wrapper for testWidgets that automatically sets up large viewport
/// Use this instead of testWidgets for tests that render pages with navbar
void testWidgetsWithLargeViewport(
  String description,
  WidgetTesterCallback callback, {
  bool skip = false,
  Timeout? timeout,
  bool semanticsEnabled = true,
  TestVariant<Object?> variant = const DefaultTestVariant(),
  dynamic tags,
}) {
  testWidgets(
    description,
    (tester) async {
      setUpLargeViewport(tester);
      addTearDown(() => tearDownViewport(tester));
      await callback(tester);
    },
    skip: skip,
    timeout: timeout,
    semanticsEnabled: semanticsEnabled,
    variant: variant,
    tags: tags,
  );
}
