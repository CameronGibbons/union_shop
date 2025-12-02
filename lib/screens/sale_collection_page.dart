import 'package:flutter/material.dart';
import 'package:union_shop/constants/app_colors.dart';
import 'package:union_shop/models/product.dart';
import 'package:union_shop/services/products_service.dart';
import 'package:union_shop/widgets/navbar.dart';
import 'package:union_shop/widgets/footer_widget.dart';
import 'package:union_shop/widgets/product_card.dart';

class SaleCollectionPage extends StatefulWidget {
  const SaleCollectionPage({super.key});

  @override
  State<SaleCollectionPage> createState() => _SaleCollectionPageState();
}

class _SaleCollectionPageState extends State<SaleCollectionPage> {
  final ProductsService _productsService = ProductsService();

  List<Product> _allProducts = [];
  List<Product> _displayedProducts = [];
  bool _isLoading = true;
  String _errorMessage = '';

  // Filter and sort state
  String _selectedCategory = 'All products';
  String _selectedSort = 'Best selling';
  int _currentPage = 0;
  static const int _itemsPerPage = 10;

  @override
  void initState() {
    super.initState();
    _loadSaleProducts();
  }

  Future<void> _loadSaleProducts() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      // Get all products that are on sale
      final products = await _productsService.filterProducts(onSale: true);

      setState(() {
        _allProducts = products;
        _updateDisplayedProducts();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load sale products: $e';
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
            const Navbar(),
            if (_isLoading)
              _buildLoadingState()
            else if (_errorMessage.isNotEmpty)
              _buildErrorState()
            else ...[
              _buildSaleHeader(),
              _buildPromotionalMessage(),
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

  Widget _buildLoadingState() {
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
              onPressed: _loadSaleProducts,
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

  Widget _buildSaleHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
      color: Colors.white,
      child: const Column(
        children: [
          Text(
            'SALE',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              letterSpacing: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPromotionalMessage() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      color: Colors.white,
      child: Column(
        children: [
          const Text(
            'Don\'t miss out! Get yours before they\'re all gone!',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.shopping_cart,
                  size: 18,
                  color: Colors.black54,
                ),
                SizedBox(width: 8),
                Flexible(
                  child: Text(
                    'All prices shown are inclusive of the discount 🛒',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
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
                          value: 'Best selling', child: Text('Best selling')),
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
            'No sale products found',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      );
    }

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
          childAspectRatio: 0.7,
        ),
        itemCount: _displayedProducts.length,
        itemBuilder: (context, index) {
          final product = _displayedProducts[index];
          return ProductCard(
            title: product.name,
            price: '£${product.salePrice!.toStringAsFixed(2)}',
            imageUrl: product.imageUrl,
            originalPrice: '£${product.price.toStringAsFixed(2)}',
            productId: product.id,
            isSoldOut: !product.isInStock,
          );
        },
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
