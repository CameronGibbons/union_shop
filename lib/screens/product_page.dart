import 'package:flutter/material.dart';
import 'package:union_shop/constants/app_colors.dart';
import 'package:union_shop/models/product.dart';
import 'package:union_shop/models/cart_item.dart';
import 'package:union_shop/services/products_service.dart';
import 'package:union_shop/services/cart_service.dart';
import 'package:union_shop/utils/snackbar_utils.dart';
import 'package:union_shop/widgets/navbar.dart';
import 'package:union_shop/widgets/footer_widget.dart';

class ProductPage extends StatefulWidget {
  final String? productId;

  const ProductPage({
    super.key,
    this.productId,
  });

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final ProductsService _productsService = ProductsService();

  Product? _product;
  bool _isLoading = true;
  String _errorMessage = '';

  // Selected options
  String? _selectedColor;
  String? _selectedSize;
  int _quantity = 1;
  int _selectedImageIndex = 0;

  // Mock product images for carousel
  List<String> get _productImages => [
        _product?.imageUrl ?? '',
        _product?.imageUrl ?? '',
        _product?.imageUrl ?? '',
        _product?.imageUrl ?? '',
      ];

  @override
  void initState() {
    super.initState();
    _loadProduct();
  }

  Future<void> _loadProduct() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      // Use provided product ID or default to first product
      final productId = widget.productId ?? 'classic-sweatshirt';
      final product = await _productsService.getProductById(productId);

      if (product == null) {
        setState(() {
          _errorMessage = 'Product not found';
          _isLoading = false;
        });
        return;
      }

      setState(() {
        _product = product;
        // Set default selections
        _selectedColor =
            product.colors.isNotEmpty ? product.colors.first : null;
        _selectedSize = product.sizes.isNotEmpty ? product.sizes.first : null;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load product: $e';
        _isLoading = false;
      });
    }
  }

  void _incrementQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  void navigateToHome(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  void placeholderCallbackForButtons() {
    // Placeholder for buttons that don't work yet
  }

  Future<void> _addToCart() async {
    // Validate selections
    if (_product == null) return;

    if (_product!.colors.isNotEmpty && _selectedColor == null) {
      SnackbarUtils.showError(context, 'Please select a color');
      return;
    }

    if (_product!.sizes.isNotEmpty && _selectedSize == null) {
      SnackbarUtils.showError(context, 'Please select a size');
      return;
    }

    // Create cart item
    final cartItem = CartItem(
      productId: _product!.id,
      productName: _product!.name,
      price: _product!.price,
      quantity: _quantity,
      color: _selectedColor,
      size: _selectedSize,
      imageUrl: _product!.imageUrl,
    );

    // Add to cart
    await CartService().addToCart(cartItem);

    if (mounted) {
      SnackbarUtils.showAddedToCart(
        context,
        cartItem.productName,
        onViewCart: () => Navigator.pushNamed(context, '/cart'),
      );
    }
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
              _buildProductContent(),
              _buildBackButton(),
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
              onPressed: _loadProduct,
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

  Widget _buildProductContent() {
    if (_product == null) return const SizedBox.shrink();

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildImageCarousel(),
          const SizedBox(height: 24),
          _buildProductInfo(),
          const SizedBox(height: 24),
          _buildProductOptions(),
          const SizedBox(height: 24),
          _buildAddToCartButton(),
          const SizedBox(height: 32),
          _buildProductDescription(),
        ],
      ),
    );
  }

  Widget _buildImageCarousel() {
    return Column(
      children: [
        // Main image
        Container(
          height: 400,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey[200],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              _productImages[_selectedImageIndex],
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: AppColors.primary,
                  child: const Center(
                    child: Icon(
                      Icons.image,
                      size: 64,
                      color: Colors.white,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Thumbnail navigation
        SizedBox(
          height: 80,
          child: Row(
            children: [
              // Previous arrow
              IconButton(
                icon: const Icon(Icons.chevron_left, size: 32),
                onPressed: _selectedImageIndex > 0
                    ? () {
                        setState(() {
                          _selectedImageIndex--;
                        });
                      }
                    : null,
                color: Colors.black,
                disabledColor: Colors.grey,
              ),
              // Thumbnails
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _productImages.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedImageIndex = index;
                        });
                      },
                      child: Container(
                        width: 70,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: _selectedImageIndex == index
                                ? AppColors.primary
                                : Colors.grey.shade300,
                            width: _selectedImageIndex == index ? 2 : 1,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Image.asset(
                            _productImages[index],
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[300],
                                child:
                                    const Icon(Icons.image, color: Colors.grey),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Next arrow
              IconButton(
                icon: const Icon(Icons.chevron_right, size: 32),
                onPressed: _selectedImageIndex < _productImages.length - 1
                    ? () {
                        setState(() {
                          _selectedImageIndex++;
                        });
                      }
                    : null,
                color: Colors.black,
                disabledColor: Colors.grey,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProductInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _product!.name,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        if (_product!.isOnSale) ...[
          Row(
            children: [
              Text(
                '£${_product!.displayPrice.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '£${_product!.price.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey.shade600,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
            ],
          ),
        ] else ...[
          Text(
            '£${_product!.price.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ],
        const SizedBox(height: 8),
        const Text(
          'Tax included.',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildProductOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Color dropdown
        if (_product!.colors.isNotEmpty) ...[
          const Text(
            'Color',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
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
              value: _selectedColor,
              isExpanded: true,
              underline: const SizedBox(),
              items: _product!.colors.map((color) {
                return DropdownMenuItem(
                  value: color,
                  child: Text(color),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedColor = value;
                });
              },
            ),
          ),
          const SizedBox(height: 16),
        ],

        // Size dropdown
        if (_product!.sizes.isNotEmpty) ...[
          const Text(
            'Size',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
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
              value: _selectedSize,
              isExpanded: true,
              underline: const SizedBox(),
              items: _product!.sizes.map((size) {
                return DropdownMenuItem(
                  value: size,
                  child: Text(size),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedSize = value;
                });
              },
            ),
          ),
          const SizedBox(height: 16),
        ],

        // Quantity counter
        const Text(
          'Quantity',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            // Decrement button
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  bottomLeft: Radius.circular(4),
                ),
              ),
              child: IconButton(
                icon: const Icon(Icons.remove, size: 20),
                onPressed: _quantity > 1 ? _decrementQuantity : null,
                color: Colors.black,
                disabledColor: Colors.grey,
              ),
            ),
            // Quantity display
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey.shade300),
                  bottom: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              child: Text(
                _quantity.toString(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            // Increment button
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(4),
                  bottomRight: Radius.circular(4),
                ),
              ),
              child: IconButton(
                icon: const Icon(Icons.add, size: 20),
                onPressed: _incrementQuantity,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAddToCartButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _addToCart,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        child: const Text(
          'ADD TO CART',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }

  Widget _buildProductDescription() {
    if (_product!.description == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _product!.description!,
          style: const TextStyle(
            fontSize: 16,
            height: 1.6,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildBackButton() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: OutlinedButton(
        onPressed: () => Navigator.pop(context),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.arrow_back, size: 20),
            SizedBox(width: 8),
            Text(
              'BACK TO AUTUMN FAVOURITES',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
