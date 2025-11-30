import 'package:flutter/material.dart';
import 'package:union_shop/product_page.dart';
import 'package:union_shop/screens/about_page.dart';
import 'package:union_shop/widgets/product_card.dart';
import 'package:union_shop/widgets/collection_card.dart';
import 'package:union_shop/widgets/category_list_item.dart';

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

            // Hero Banner Section
            _buildHeroBanner(),

            // Featured Collections Section
            _buildFeaturedCollections(),

            // Best Sellers Section
            _buildBestSellers(),

            // Categories Section
            _buildCategoriesSection(),

            // Footer (placeholder for now)
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
            padding: const EdgeInsets.symmetric(vertical: 10),
            color: const Color(0xFF4d2963),
            child: const Text(
              '🎓 STUDENT DISCOUNT AVAILABLE',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
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
                  child: Image.asset(
                    'assets/images/logo.png',
                    height: 40,
                    errorBuilder: (context, error, stackTrace) {
                      return const Text(
                        'UPSU SHOP',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4d2963),
                        ),
                      );
                    },
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
                    IconButton(
                      icon: const Icon(Icons.menu, size: 24),
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

  // Hero Banner with Call-to-Action
  Widget _buildHeroBanner() {
    return Container(
      height: 450,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: const AssetImage('assets/images/hero_banner.png'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withValues(alpha: 0.4),
            BlendMode.darken,
          ),
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'WELCOME TO UPSU SHOP',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'Official University of Portsmouth Students\' Union Merchandise',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: placeholderCallbackForButtons,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4d2963),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                child: const Text(
                  'SHOP NOW',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Featured Collections
  Widget _buildFeaturedCollections() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Text(
            'FEATURED COLLECTIONS',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Explore our most popular product ranges',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 32),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.75,
            children: const [
              CollectionCard(
                title: 'Essential Range',
                subtitle: 'Classic designs',
                imageUrl: 'assets/images/essential_hoodie.png',
              ),
              CollectionCard(
                title: 'Signature Collection',
                subtitle: 'Premium quality',
                imageUrl: 'assets/images/signature_hoodie.png',
              ),
              CollectionCard(
                title: 'Portsmouth Gifts',
                subtitle: 'Souvenirs & more',
                imageUrl: 'assets/images/portsmouth_postcard.png',
              ),
              CollectionCard(
                title: 'Sale Items',
                subtitle: 'Up to 50% off',
                imageUrl: 'assets/images/category_sale.png',
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Best Sellers Section
  Widget _buildBestSellers() {
    return Container(
      color: Colors.grey[50],
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Text(
            'BEST SELLERS',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 32),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 24,
            childAspectRatio: 0.65,
            children: const [
              ProductCard(
                title: 'Essential Hoodie',
                price: '£35.00',
                imageUrl: 'assets/images/essential_hoodie.png',
              ),
              ProductCard(
                title: 'Essential T-Shirt',
                price: '£18.00',
                imageUrl: 'assets/images/essential_tshirt.png',
              ),
              ProductCard(
                title: 'Signature Hoodie',
                price: '£42.00',
                imageUrl: 'assets/images/signature_hoodie.png',
              ),
              ProductCard(
                title: 'Signature T-Shirt',
                price: '£22.00',
                imageUrl: 'assets/images/signature_tshirt.png',
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
              'VIEW ALL PRODUCTS',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Categories Section
  Widget _buildCategoriesSection() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(24),
      child: const Column(
        children: [
          Text(
            'SHOP BY CATEGORY',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          SizedBox(height: 32),
          Column(
            children: [
              CategoryListItem(
                title: 'Clothing',
                description: 'Hoodies, T-Shirts & More',
                imageUrl: 'assets/images/category_clothing.png',
              ),
              SizedBox(height: 16),
              CategoryListItem(
                title: 'Merchandise',
                description: 'Gifts & Accessories',
                imageUrl: 'assets/images/category_merchandise.png',
              ),
              SizedBox(height: 16),
              CategoryListItem(
                title: 'Graduation',
                description: 'Celebrate Your Achievement',
                imageUrl: 'assets/images/category_graduation.png',
              ),
              SizedBox(height: 16),
              CategoryListItem(
                title: 'Sale',
                description: 'Limited Time Offers',
                imageUrl: 'assets/images/category_sale.png',
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Footer Placeholder
  Widget _buildFooter(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFF2c2c2c),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'UPSU SHOP',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'University of Portsmouth Students\' Union',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/about');
            },
            child: const Text(
              'About Us',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            '© 2025 UPSU. All rights reserved.',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
