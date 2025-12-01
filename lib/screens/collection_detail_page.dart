import 'package:flutter/material.dart';
import 'package:union_shop/models/collection.dart';
import 'package:union_shop/models/product.dart';
import 'package:union_shop/services/collections_service.dart';
import 'package:union_shop/services/products_service.dart';
import 'package:union_shop/services/auth_service.dart';
import 'package:union_shop/widgets/footer_widget.dart';
import 'package:union_shop/widgets/product_card.dart';

class CollectionDetailPage extends StatefulWidget {
  final String collectionId;

  const CollectionDetailPage({
    super.key,
    required this.collectionId,
  });

  @override
  State<CollectionDetailPage> createState() => _CollectionDetailPageState();
}

class _CollectionDetailPageState extends State<CollectionDetailPage> {
  final CollectionsService _collectionsService = CollectionsService();
  final ProductsService _productsService = ProductsService();

  Collection? _collection;
  List<Product> _allProducts = [];
  List<Product> _displayedProducts = [];
  bool _isLoading = true;
  String _errorMessage = '';

  // Filter and sort state
  String _selectedCategory = 'All products';
  String _selectedSort = 'Featured';
  int _currentPage = 0;
  static const int _itemsPerPage = 10;

  @override
  void initState() {
    super.initState();
    _loadCollectionData();
  }

  Future<void> _loadCollectionData() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      final collection =
          await _collectionsService.getCollectionById(widget.collectionId);
      final products =
          await _productsService.getProductsByCollection(widget.collectionId);

      setState(() {
        _collection = collection;
        _allProducts = products;
        _updateDisplayedProducts();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load collection: $e';
        _isLoading = false;
      });
    }
  }

  void _updateDisplayedProducts() {
    var filtered = List<Product>.from(_allProducts);

    // Apply category filter
    if (_selectedCategory != 'All products') {
      filtered =
          filtered.where((p) => p.category == _selectedCategory).toList();
    }

    // Apply sorting
    filtered = _productsService.sortProducts(filtered, _getSortValue());

    // Apply pagination
    _displayedProducts = _productsService.paginateProducts(
        filtered, _currentPage, _itemsPerPage);
  }

  String _getSortValue() {
    switch (_selectedSort) {
      case 'Price: Low to High':
        return 'price-asc';
      case 'Price: High to Low':
        return 'price-desc';
      case 'Alphabetically, A-Z':
        return 'name-asc';
      case 'Alphabetically, Z-A':
        return 'name-desc';
      default:
        return 'featured';
    }
  }

  int _getTotalPages() {
    var filtered = List<Product>.from(_allProducts);
    if (_selectedCategory != 'All products') {
      filtered =
          filtered.where((p) => p.category == _selectedCategory).toList();
    }
    return _productsService.getTotalPages(filtered.length, _itemsPerPage);
  }

  void _onCategoryChanged(String? value) {
    if (value != null) {
      setState(() {
        _selectedCategory = value;
        _currentPage = 0;
        _updateDisplayedProducts();
      });
    }
  }

  void _onSortChanged(String? value) {
    if (value != null) {
      setState(() {
        _selectedSort = value;
        _updateDisplayedProducts();
      });
    }
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
      _updateDisplayedProducts();
    });
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
            _buildHeader(context),
            if (_isLoading)
              _buildLoadingState()
            else if (_errorMessage.isNotEmpty)
              _buildErrorState()
            else ...[
              _buildCollectionHeader(),
              _buildFilterAndSort(),
              _buildProductCount(),
              _buildProductGrid(),
              _buildPagination(),
            ],
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
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
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.search, size: 24),
                      onPressed: placeholderCallbackForButtons,
                    ),
                    IconButton(
                      icon: const Icon(Icons.person_outline, size: 24),
                      onPressed: () {
                        final authService = AuthService();
                        if (authService.isSignedIn) {
                          Navigator.pushNamed(context, '/account');
                        } else {
                          Navigator.pushNamed(context, '/login');
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.shopping_bag_outlined, size: 24),
                      onPressed: () => Navigator.pushNamed(context, '/cart'),
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

  Widget _buildLoadingState() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(64),
      child: const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF4d2963),
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(32),
      child: Center(
        child: Column(
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              _errorMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadCollectionData,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4d2963),
                foregroundColor: Colors.white,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCollectionHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
      color: Colors.white,
      child: Column(
        children: [
          Text(
            _collection?.name ?? '',
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          if (_collection?.description != null) ...[
            const SizedBox(height: 8),
            Text(
              _collection!.description!,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFilterAndSort() {
    final categories = [
      'All products',
      ..._productsService.getCategories(_allProducts)
    ];

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          // Filter dropdown
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'FILTER BY',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: DropdownButton<String>(
                    value: _selectedCategory,
                    isExpanded: true,
                    underline: const SizedBox(),
                    items: categories.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: _onCategoryChanged,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Sort dropdown
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'SORT BY',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: DropdownButton<String>(
                    value: _selectedSort,
                    isExpanded: true,
                    underline: const SizedBox(),
                    items: const [
                      DropdownMenuItem(
                          value: 'Featured', child: Text('Featured')),
                      DropdownMenuItem(
                          value: 'Price: Low to High',
                          child: Text('Price: Low to High')),
                      DropdownMenuItem(
                          value: 'Price: High to Low',
                          child: Text('Price: High to Low')),
                      DropdownMenuItem(
                          value: 'Alphabetically, A-Z',
                          child: Text('Alphabetically, A-Z')),
                      DropdownMenuItem(
                          value: 'Alphabetically, Z-A',
                          child: Text('Alphabetically, Z-A')),
                    ],
                    onChanged: _onSortChanged,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCount() {
    var filtered = List<Product>.from(_allProducts);
    if (_selectedCategory != 'All products') {
      filtered =
          filtered.where((p) => p.category == _selectedCategory).toList();
    }

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        '${filtered.length} products',
        style: const TextStyle(
          fontSize: 14,
          fontStyle: FontStyle.italic,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildProductGrid() {
    if (_displayedProducts.isEmpty) {
      return Container(
        color: Colors.white,
        padding: const EdgeInsets.all(32),
        child: const Center(
          child: Text(
            'No products found',
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
              childAspectRatio: 0.7,
            ),
            itemCount: _displayedProducts.length,
            itemBuilder: (context, index) {
              final product = _displayedProducts[index];
              return ProductCard(
                title: product.name,
                price: product.isOnSale
                    ? '£${product.salePrice!.toStringAsFixed(2)}'
                    : '£${product.price.toStringAsFixed(2)}',
                imageUrl: product.imageUrl,
                originalPrice: product.isOnSale
                    ? '£${product.price.toStringAsFixed(2)}'
                    : null,
                productId: product.id,
                isSoldOut: !product.isInStock,
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPagination() {
    final totalPages = _getTotalPages();

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
      child: Column(
        children: [
          Text(
            'Page ${_currentPage + 1} of $totalPages',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Previous button
              OutlinedButton(
                onPressed: _currentPage > 0
                    ? () => _onPageChanged(_currentPage - 1)
                    : null,
                style: OutlinedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  side: BorderSide(
                    color: _currentPage > 0 ? Colors.black : Colors.grey,
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.arrow_back, size: 16),
                    SizedBox(width: 8),
                    Text('PREVIOUS'),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Next button
              OutlinedButton(
                onPressed: _currentPage < totalPages - 1
                    ? () => _onPageChanged(_currentPage + 1)
                    : null,
                style: OutlinedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  side: BorderSide(
                    color: _currentPage < totalPages - 1
                        ? Colors.black
                        : Colors.grey,
                  ),
                ),
                child: const Row(
                  children: [
                    Text('NEXT PAGE'),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward, size: 16),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
