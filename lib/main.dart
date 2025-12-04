import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:union_shop/config/supabase_config.dart';
import 'package:union_shop/constants/app_colors.dart';
import 'package:union_shop/screens/product_page.dart';
import 'package:union_shop/screens/about_page.dart';
import 'package:union_shop/screens/collections_page.dart';
import 'package:union_shop/screens/collection_detail_page.dart';
import 'package:union_shop/screens/sale_collection_page.dart';
import 'package:union_shop/screens/login_page.dart';
import 'package:union_shop/screens/signup_page.dart';
import 'package:union_shop/screens/account_page.dart';
import 'package:union_shop/screens/forgot_password_page.dart';
import 'package:union_shop/screens/print_shack_page.dart';
import 'package:union_shop/screens/print_shack_info_page.dart';
import 'package:union_shop/screens/cart_page.dart';
import 'package:union_shop/screens/search_results_page.dart';
import 'package:union_shop/services/auth_service.dart';
import 'package:union_shop/services/cart_service.dart';
import 'package:union_shop/widgets/product_card.dart';
import 'package:union_shop/widgets/collection_card.dart';
import 'package:union_shop/widgets/footer_widget.dart';
import 'package:union_shop/widgets/hero_carousel.dart';
import 'package:union_shop/widgets/navbar.dart';
import 'package:web/web.dart' as web;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: SupabaseConfig.supabaseUrl,
    anonKey: SupabaseConfig.supabaseAnonKey,
  );

  // Initialize cart service
  await CartService().loadCart();

  runApp(const UnionShopApp());
}

class UnionShopApp extends StatelessWidget {
  const UnionShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Union Shop',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
      ),
      home: const AuthWrapper(),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        // Handle dynamic collection routes
        if (settings.name != null &&
            settings.name!.startsWith('/collection/')) {
          final collectionId = settings.name!.substring('/collection/'.length);
          return MaterialPageRoute(
            builder: (context) =>
                CollectionDetailPage(collectionId: collectionId),
            settings: settings,
          );
        }

        // Handle dynamic product routes
        if (settings.name != null && settings.name!.startsWith('/product/')) {
          final productId = settings.name!.substring('/product/'.length);
          return MaterialPageRoute(
            builder: (context) => ProductPage(productId: productId),
            settings: settings,
          );
        }

        // Handle other routes
        return null;
      },
      routes: {
        '/product': (context) =>
            const ProductPage(productId: 'classic-sweatshirt'),
        '/about': (context) => const AboutPage(),
        '/collections': (context) => const CollectionsPage(),
        '/sale': (context) => const SaleCollectionPage(),
        '/print-shack': (context) => const PrintShackPage(),
        '/print-shack-info': (context) => const PrintShackInfoPage(),
        '/cart': (context) => const CartPage(),
        '/search': (context) => const SearchResultsPage(),
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignupPage(),
        '/account': (context) => const AccountPage(),
        '/forgot-password': (context) => const ForgotPasswordPage(),
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void navigateToHome(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  void navigateToProduct(BuildContext context) {
    Navigator.pushNamed(context, '/product');
  }

  void placeholderCallbackForButtons() {
    // This is the event handler for buttons that don't work yet
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header with announcement bar and navigation
            const Navbar(),

            // Hero Carousel/Slideshow Section
            _buildHeroCarousel(),

            // Essential Range Section (Featured Sale Items)
            _buildEssentialRangeSection(),

            // Signature Range Section
            _buildSignatureRangeSection(),

            // Portsmouth City Collection Section
            _buildPortsmouthCitySection(),

            // Our Range Section (Categories)
            _buildOurRangeSection(),

            // Print Shack / Info Section
            _buildPrintShackSection(context),

            // Footer
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  // Hero Carousel/Slideshow with promotional banners
  Widget _buildHeroCarousel() {
    return const HeroCarousel();
  }

  // Essential Range Section - Featured Sale Products
  Widget _buildEssentialRangeSection() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1400),
          child: Column(
            children: [
              const Text(
                'ESSENTIAL RANGE - OVER 20% OFF!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              LayoutBuilder(
                builder: (context, constraints) {
                  final crossAxisCount = constraints.maxWidth > 1200
                      ? 4
                      : constraints.maxWidth > 768
                          ? 3
                          : 2;
                  return GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.75,
                    children: const [
                      ProductCard(
                        title: 'Limited Edition Essential Zip Hoodies',
                        price: '£14.99',
                        originalPrice: '£20.00',
                        imageUrl: 'assets/images/essential_hoodie.png',
                        productId: 'limited-edition-zip-hoodie',
                      ),
                      ProductCard(
                        title: 'Essential T-Shirt',
                        price: '£6.99',
                        originalPrice: '£10.00',
                        imageUrl: 'assets/images/essential_tshirt.png',
                        productId: 'essential-tshirt',
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 12),
              Builder(
                builder: (context) => OutlinedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/collection/essential-range');
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: const Text(
                    'View all products in the Essential Range',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Signature Range Section
  Widget _buildSignatureRangeSection() {
    return Container(
      color: Colors.grey[50],
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1400),
          child: Column(
            children: [
              const Text(
                'SIGNATURE RANGE',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              LayoutBuilder(
                builder: (context, constraints) {
                  final crossAxisCount = constraints.maxWidth > 1200
                      ? 4
                      : constraints.maxWidth > 768
                          ? 3
                          : 2;
                  return GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.75,
                    children: const [
                      ProductCard(
                        title: 'Signature Hoodie',
                        price: '£32.99',
                        imageUrl: 'assets/images/signature_hoodie.png',
                        productId: 'signature-hoodie-featured',
                      ),
                      ProductCard(
                        title: 'Signature T-Shirt',
                        price: '£14.99',
                        imageUrl: 'assets/images/signature_tshirt.png',
                        productId: 'signature-tshirt-featured',
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 12),
              Builder(
                builder: (context) => OutlinedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/collection/signature-range');
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: const Text(
                    'View all products in the Signature Range',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Portsmouth City Collection Section
  Widget _buildPortsmouthCitySection() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1400),
          child: Column(
            children: [
              const Text(
                'PORTSMOUTH CITY COLLECTION',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              LayoutBuilder(
                builder: (context, constraints) {
                  final crossAxisCount = constraints.maxWidth > 1200
                      ? 4
                      : constraints.maxWidth > 768
                          ? 3
                          : 2;
                  return GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.75,
                    children: const [
                      ProductCard(
                        title: 'Portsmouth City Postcard',
                        price: '£1.00',
                        imageUrl: 'assets/images/portsmouth_postcard.png',
                        productId: 'portsmouth-postcard',
                      ),
                      ProductCard(
                        title: 'Portsmouth City Magnet',
                        price: '£4.50',
                        imageUrl: 'assets/images/portsmouth_magnet.png',
                        productId: 'portsmouth-magnet',
                      ),
                      ProductCard(
                        title: 'Portsmouth City Bookmark',
                        price: '£3.00',
                        imageUrl: 'assets/images/portsmouth_bookmark.png',
                        productId: 'portsmouth-bookmark',
                      ),
                      ProductCard(
                        title: 'Portsmouth City Notebook',
                        price: '£7.50',
                        imageUrl: 'assets/images/portsmouth_notebook.png',
                        productId: 'portsmouth-notebook',
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 12),
              Builder(
                builder: (context) => OutlinedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/collection/portsmouth-city');
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: const Text(
                    'View all products in the Portsmouth City Collection',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Our Range Section - Category tiles
  Widget _buildOurRangeSection() {
    return Container(
      color: Colors.grey[50],
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1400),
          child: Column(
            children: [
              const Text(
                'OUR RANGE',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              LayoutBuilder(
                builder: (context, constraints) {
                  final crossAxisCount = constraints.maxWidth > 1200
                      ? 4
                      : constraints.maxWidth > 768
                          ? 3
                          : 2;
                  return GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.1,
                    children: const [
                      CollectionCard(
                        title: 'Clothing',
                        subtitle: '',
                        imageUrl: 'assets/images/category_clothing.png',
                        collectionId: 'clothing',
                      ),
                      CollectionCard(
                        title: 'Merchandise',
                        subtitle: '',
                        imageUrl: 'assets/images/category_merchandise.png',
                        collectionId: 'merchandise',
                      ),
                      CollectionCard(
                        title: 'Graduation',
                        subtitle: '',
                        imageUrl: 'assets/images/category_graduation.png',
                        collectionId: 'graduation',
                      ),
                      CollectionCard(
                        title: 'SALE',
                        subtitle: '',
                        imageUrl: 'assets/images/category_sale.png',
                        collectionId: 'sale',
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Print Shack / Personalization Section
  Widget _buildPrintShackSection(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Add a Personal Touch',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'First add your item of clothing to your cart then click below to add your text! One line of text contains 10 characters!',
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/print-shack');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            child: const Text(
              'CLICK HERE TO ADD TEXT!',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            'Opening Hours',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            '❄️ Winter Break Closure Dates ❄️',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Closing 4pm 19/12/2025\nReopening 10am 05/01/2026\nLast post date: 12pm on 18/12/2025',
            style: TextStyle(
              fontSize: 13,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 12),
          const Text(
            '(Term Time)\nMonday - Friday 10am - 4pm',
            style: TextStyle(
              fontSize: 13,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '(Outside of Term Time / Consolidation Weeks)\nMonday - Friday 10am - 3pm',
            style: TextStyle(
              fontSize: 13,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Purchase online 24/7',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // Footer Placeholder
  Widget _buildFooter(BuildContext context) {
    return const FooterWidget();
  }
}

// Auth wrapper to handle OAuth redirects
class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _isChecking = true;

  @override
  void initState() {
    super.initState();
    _checkAuthState();
  }

  Future<void> _checkAuthState() async {
    // Check if this is an OAuth callback (has code parameter)
    final currentUrl = web.window.location.href;
    final uri = Uri.parse(currentUrl);
    final hasCode = uri.queryParameters.containsKey('code');

    if (hasCode) {
      // Wait for Supabase to process the OAuth callback
      await Future.delayed(const Duration(milliseconds: 800));

      // Check if user is now signed in
      try {
        final authService = AuthService();
        if (authService.isSignedIn && mounted) {
          // Use Navigator to clean the URL - safer than direct history manipulation
          Navigator.of(context).pushReplacementNamed('/account');
          return;
        }
      } catch (e) {
        // Continue to show home screen
        debugPrint('Auth check error: $e');
      }
    }

    await Future.delayed(const Duration(milliseconds: 300));
    if (mounted) {
      setState(() {
        _isChecking = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isChecking) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return const HomeScreen();
  }
}
