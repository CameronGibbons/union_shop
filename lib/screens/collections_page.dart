import 'package:flutter/material.dart';
import 'package:union_shop/widgets/footer_widget.dart';

class CollectionsPage extends StatelessWidget {
  const CollectionsPage({super.key});

  void navigateToHome(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  void placeholderCallbackForButtons() {
    // Placeholder for buttons that don't work yet
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            _buildHeader(context),

            // Page Title
            _buildPageTitle(),

            // Collections List
            _buildCollectionsList(),

            // Footer
            const FooterWidget(),
          ],
        ),
      ),
    );
  }

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

  Widget _buildPageTitle() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
      color: Colors.white,
      child: const Text(
        'Collections',
        style: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildCollectionsList() {
    final collections = [
      CollectionItem(
          'Autumn Favourites', 'assets/images/category_clothing.png'),
      CollectionItem('Black Friday', 'assets/images/category_sale.png'),
      CollectionItem('Clothing', 'assets/images/signature_hoodie.png'),
      CollectionItem(
          'Clothing - Original', 'assets/images/signature_hoodie.png'),
      CollectionItem(
          'Elections Discounts', 'assets/images/essential_hoodie.png'),
      CollectionItem('Essential Range', 'assets/images/essential_hoodie.png'),
      CollectionItem('Graduation', 'assets/images/category_graduation.png'),
      CollectionItem('Limited Edition Essential Zip Hoodies',
          'assets/images/essential_hoodie.png'),
      CollectionItem('Merchandise', 'assets/images/category_merchandise.png'),
      CollectionItem('Nike Final Chance', 'assets/images/category_sale.png'),
      CollectionItem(
          'Personalisation', 'assets/images/personalization_banner.png'),
      CollectionItem('Popular', 'assets/images/signature_tshirt.png'),
      CollectionItem('Portsmouth City Collection',
          'assets/images/portsmouth_postcard.png'),
      CollectionItem('Pride Collection', 'assets/images/signature_tshirt.png'),
      CollectionItem('SALE', 'assets/images/category_sale.png'),
      CollectionItem(
          'Signature & Essential Range', 'assets/images/signature_hoodie.png'),
      CollectionItem('Signature Range', 'assets/images/signature_hoodie.png'),
      CollectionItem('Sports Clubs', 'assets/images/signature_hoodie.png'),
      CollectionItem('Spring Favourites', 'assets/images/essential_tshirt.png'),
      CollectionItem(
          'Student Essentials', 'assets/images/essential_tshirt.png'),
      CollectionItem('Student Groups', 'assets/images/signature_hoodie.png'),
      CollectionItem('Summer Essentials', 'assets/images/essential_tshirt.png'),
      CollectionItem('Summer Favourites', 'assets/images/essential_tshirt.png'),
      CollectionItem(
          'University Clothing', 'assets/images/signature_hoodie.png'),
      CollectionItem(
          'University Merchandise', 'assets/images/category_merchandise.png'),
      CollectionItem('UPSU Bears', 'assets/images/logo.png'),
      CollectionItem('Winter Favourites', 'assets/images/essential_hoodie.png'),
    ];

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.85,
        ),
        itemCount: collections.length,
        itemBuilder: (context, index) {
          return _buildCollectionCard(collections[index]);
        },
      ),
    );
  }

  Widget _buildCollectionCard(CollectionItem collection) {
    return GestureDetector(
      onTap: placeholderCallbackForButtons,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey[200],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                collection.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: const Color(0xFF4d2963),
                  );
                },
              ),
            ),
            // Dark Overlay
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.black.withValues(alpha: 0.3),
              ),
            ),
            // Collection Name
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  collection.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        offset: Offset(0, 1),
                        blurRadius: 3.0,
                        color: Color.fromARGB(128, 0, 0, 0),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CollectionItem {
  final String name;
  final String imageUrl;

  CollectionItem(this.name, this.imageUrl);
}
