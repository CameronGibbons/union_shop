import 'package:flutter/material.dart';
import 'package:union_shop/constants/app_colors.dart';
import 'package:union_shop/models/collection.dart';
import 'package:union_shop/services/collections_service.dart';
import 'package:union_shop/widgets/navbar.dart';
import 'package:union_shop/widgets/footer_widget.dart';

class CollectionsPage extends StatefulWidget {
  const CollectionsPage({super.key});

  @override
  State<CollectionsPage> createState() => _CollectionsPageState();
}

class _CollectionsPageState extends State<CollectionsPage> {
  final CollectionsService _collectionsService = CollectionsService();
  List<Collection> _collections = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadCollections();
  }

  Future<void> _loadCollections() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      final collections = await _collectionsService.getAllCollections();

      setState(() {
        _collections = collections;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load collections: $e';
        _isLoading = false;
      });
    }
  }

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
            // Navbar
            const Navbar(),

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
    if (_isLoading) {
      return Container(
        color: Colors.white,
        padding: const EdgeInsets.all(64),
        child: const Center(
          child: CircularProgressIndicator(
            color: AppColors.primary,
          ),
        ),
      );
    }

    if (_errorMessage.isNotEmpty) {
      return Container(
        color: Colors.white,
        padding: const EdgeInsets.all(32),
        child: Center(
          child: Column(
            children: [
              const Icon(
                Icons.error_outline,
                size: 48,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              Text(
                _errorMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadCollections,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (_collections.isEmpty) {
      return Container(
        color: Colors.white,
        padding: const EdgeInsets.all(32),
        child: const Center(
          child: Text(
            'No collections available',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      );
    }

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1400),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: MediaQuery.of(context).size.width > 1200
                  ? 4
                  : MediaQuery.of(context).size.width > 768
                      ? 3
                      : 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.85,
            ),
            itemCount: _collections.length,
            itemBuilder: (context, index) {
              return _buildCollectionCard(_collections[index]);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCollectionCard(Collection collection) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/collection/${collection.id}',
        );
      },
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
                    color: AppColors.primary,
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
