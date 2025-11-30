import 'package:flutter/material.dart';
import 'package:union_shop/product_page.dart';
import 'package:union_shop/screens/about_page.dart';
import 'package:union_shop/widgets/product_card.dart';
import 'package:union_shop/widgets/collection_card.dart';
import 'package:union_shop/widgets/footer_widget.dart';
import 'package:union_shop/widgets/hero_carousel.dart';

void main() {
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
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4d2963)),
      ),
      home: const HomeScreen(),
      // By default, the app starts at the '/' route, which is the HomeScreen
      initialRoute: '/',
      // When navigating to '/product', build and return the ProductPage
      // In your browser, try this link: http://localhost:49856/#/product
      routes: {
        '/product': (context) => const ProductPage(),
        '/about': (context) => const AboutPage(),
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
            _buildHeader(context),

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
            _buildPrintShackSection(),

            // Footer
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  // Header with announcement bar and main navigation
  Widget _buildHeader(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // Announcement Bar
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            color: const Color(0xFF4d2963),
            child: const Text(
              'BIG SALE! OUR ESSENTIAL RANGE HAS DROPPED IN PRICE! OVER 20% OFF!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ),
          // Main Navigation
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Logo
                GestureDetector(
                  onTap: () => navigateToHome(context),
                  child: const Text(
                    'upsu-store',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4d2963),
                    ),
                  ),
                ),
                // Navigation Icons
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.search, size: 24),
                      onPressed: placeholderCallbackForButtons,
                    ),
                    IconButton(
                      icon: const Icon(Icons.person_outline, size: 24),
                      onPressed: placeholderCallbackForButtons,
                    ),
                    IconButton(
                      icon: const Icon(Icons.shopping_bag_outlined, size: 24),
                      onPressed: placeholderCallbackForButtons,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
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
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 16,
            childAspectRatio: 0.62,
            children: const [
              ProductCard(
                title: 'Limited Edition Essential Zip Hoodies',
                price: '£14.99',
                originalPrice: '£20.00',
                imageUrl: 'assets/images/essential_hoodie.png',
              ),
              ProductCard(
                title: 'Essential T-Shirt',
                price: '£6.99',
                originalPrice: '£10.00',
                imageUrl: 'assets/images/essential_tshirt.png',
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Signature Range Section
  Widget _buildSignatureRangeSection() {
    return Container(
      color: Colors.grey[50],
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
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
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 16,
            childAspectRatio: 0.62,
            children: const [
              ProductCard(
                title: 'Signature Hoodie',
                price: '£32.99',
                imageUrl: 'assets/images/signature_hoodie.png',
              ),
              ProductCard(
                title: 'Signature T-Shirt',
                price: '£14.99',
                imageUrl: 'assets/images/signature_tshirt.png',
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Portsmouth City Collection Section
  Widget _buildPortsmouthCitySection() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
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
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 16,
            childAspectRatio: 0.62,
            children: const [
              ProductCard(
                title: 'Portsmouth City Postcard',
                price: '£1.00',
                imageUrl: 'assets/images/portsmouth_postcard.png',
              ),
              ProductCard(
                title: 'Portsmouth City Magnet',
                price: '£4.50',
                imageUrl: 'assets/images/portsmouth_magnet.png',
              ),
              ProductCard(
                title: 'Portsmouth City Bookmark',
                price: '£3.00',
                imageUrl: 'assets/images/portsmouth_bookmark.png',
              ),
              ProductCard(
                title: 'Portsmouth City Notebook',
                price: '£7.50',
                imageUrl: 'assets/images/portsmouth_notebook.png',
              ),
            ],
          ),
          const SizedBox(height: 24),
          OutlinedButton(
            onPressed: placeholderCallbackForButtons,
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF4d2963),
              side: const BorderSide(color: Color(0xFF4d2963)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
        ],
      ),
    );
  }

  // Our Range Section - Category tiles
  Widget _buildOurRangeSection() {
    return Container(
      color: Colors.grey[50],
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
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
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.1,
            children: const [
              CollectionCard(
                title: 'Clothing',
                subtitle: '',
                imageUrl: 'assets/images/category_clothing.png',
              ),
              CollectionCard(
                title: 'Merchandise',
                subtitle: '',
                imageUrl: 'assets/images/category_merchandise.png',
              ),
              CollectionCard(
                title: 'Graduation',
                subtitle: '',
                imageUrl: 'assets/images/category_graduation.png',
              ),
              CollectionCard(
                title: 'SALE',
                subtitle: '',
                imageUrl: 'assets/images/category_sale.png',
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Print Shack / Personalization Section
  Widget _buildPrintShackSection() {
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
            onPressed: placeholderCallbackForButtons,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4d2963),
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
