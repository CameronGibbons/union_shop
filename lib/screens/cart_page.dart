import 'package:flutter/material.dart';
import 'package:union_shop/constants/app_colors.dart';
import 'package:union_shop/models/cart_item.dart';
import 'package:union_shop/services/cart_service.dart';
import 'package:union_shop/services/auth_service.dart';
import 'package:union_shop/services/order_service.dart';
import 'package:union_shop/utils/snackbar_utils.dart';
import 'package:union_shop/widgets/navbar.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final _cartService = CartService();
  final _orderService = OrderService();
  final _noteController = TextEditingController();
  bool _isProcessingOrder = false;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _handleCheckout() async {
    final authService = AuthService();

    if (!authService.isSignedIn) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Sign In Required'),
          content: const Text('You need to log in to checkout'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/login');
              },
              child: const Text('Sign In'),
            ),
          ],
        ),
      );
      return;
    }

    if (_isProcessingOrder) return;

    setState(() {
      _isProcessingOrder = true;
    });

    try {
      // Create order in database
      final order = await _orderService.createOrder(
        items: _cartService.cartItems,
        note: _noteController.text.trim().isNotEmpty
            ? _noteController.text.trim()
            : null,
      );

      // Clear cart after successful order
      await _cartService.clearCart();

      if (!mounted) return;

      // Show success dialog
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('Order Placed!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 64,
              ),
              const SizedBox(height: 16),
              const Text(
                'Your order has been placed successfully!',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Order #${order.id.substring(0, 8).toUpperCase()}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/account');
              },
              child: const Text('View Orders'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/');
              },
              child: const Text('Continue Shopping'),
            ),
          ],
        ),
      );
    } catch (e) {
      if (!mounted) return;
      // ignore: use_build_context_synchronously
      SnackbarUtils.showError(context, 'Failed to place order: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isProcessingOrder = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 768;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F3),
      body: Column(
        children: [
          const Navbar(),
          Expanded(
            child: ListenableBuilder(
              listenable: _cartService,
              builder: (context, _) {
                if (_cartService.isEmpty) {
                  return _buildEmptyCart();
                }

                return SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(isDesktop ? 32.0 : 16.0),
                    child: isDesktop
                        ? _buildDesktopLayout()
                        : _buildMobileLayout(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Your cart',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Your cart is currently empty.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/collections'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('CONTINUE SHOPPING'),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward, size: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Continue shopping link
        TextButton(
          onPressed: () => Navigator.pushNamed(context, '/collections'),
          child: const Text(
            'Continue shopping',
            style: TextStyle(
              fontSize: 14,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Cart items
        ..._cartService.cartItems.map((item) => _buildCartItem(item)),

        const SizedBox(height: 24),

        // Order note
        const Text(
          'Add a note to your order',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _noteController,
          maxLines: 4,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
        const SizedBox(height: 24),

        // Subtotal
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Subtotal',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '£${_cartService.subtotal.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          'Tax included and shipping calculated at checkout',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 24),

        // Checkout buttons
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  SnackbarUtils.showInfo(context, 'Cart updated');
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: Colors.black54),
                ),
                child: const Text(
                  'UPDATE',
                  style: TextStyle(color: Colors.black87),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: _handleCheckout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'CHECK OUT',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Alternative payment buttons
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  SnackbarUtils.showInfo(context, 'Shop Pay coming soon!');
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor: const Color(0xFF5A31F4),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: BorderSide.none,
                ),
                child: const Text(
                  'Shop Pay',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  SnackbarUtils.showInfo(context, 'Google Pay coming soon!');
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: BorderSide.none,
                ),
                child: const Text(
                  'G Pay',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDesktopLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Continue shopping link
        TextButton(
          onPressed: () => Navigator.pushNamed(context, '/collections'),
          child: const Text(
            'Continue shopping',
            style: TextStyle(
              fontSize: 14,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Table header
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.grey.shade300),
            ),
          ),
          child: const Row(
            children: [
              Expanded(
                  flex: 3,
                  child: Text('Product',
                      style: TextStyle(fontWeight: FontWeight.w600))),
              Expanded(
                  child: Text('Price',
                      style: TextStyle(fontWeight: FontWeight.w600))),
              Expanded(
                  child: Text('Quantity',
                      style: TextStyle(fontWeight: FontWeight.w600))),
              Expanded(
                  child: Text('Total',
                      style: TextStyle(fontWeight: FontWeight.w600),
                      textAlign: TextAlign.right)),
            ],
          ),
        ),

        // Cart items
        ..._cartService.cartItems
            .map((item) => _buildCartItem(item, isDesktop: true)),

        const SizedBox(height: 32),

        // Order note and checkout
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Add a note to your order',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _noteController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 60),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text(
                        'Subtotal',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 32),
                      Text(
                        '£${_cartService.subtotal.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Tax included and shipping calculated at checkout',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Cart updated')),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                          side: const BorderSide(color: Colors.black54),
                        ),
                        child: const Text(
                          'UPDATE',
                          style: TextStyle(color: Colors.black87),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: _handleCheckout,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 48,
                            vertical: 16,
                          ),
                        ),
                        child: const Text(
                          'CHECK OUT',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Shop Pay coming soon!')),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          backgroundColor: const Color(0xFF5A31F4),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 14,
                          ),
                          side: BorderSide.none,
                        ),
                        child: const Text(
                          'Shop Pay',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Google Pay coming soon!')),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 14,
                          ),
                          side: BorderSide.none,
                        ),
                        child: const Text(
                          'G Pay',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCartItem(CartItem item, {bool isDesktop = false}) {
    if (isDesktop) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade200),
          ),
        ),
        child: Row(
          children: [
            // Product info
            Expanded(
              flex: 3,
              child: Row(
                children: [
                  // Image
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: item.imageUrl != null
                        ? Image.asset(
                            item.imageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.image,
                                  size: 40, color: Colors.grey);
                            },
                          )
                        : const Icon(Icons.image, size: 40, color: Colors.grey),
                  ),
                  const SizedBox(width: 16),
                  // Name and variant
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.productName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (item.variantDescription.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            item.variantDescription,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                        if (item.productId == 'personalisation' &&
                            item.color != null &&
                            item.color!.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            'Personalisation Line 1: ${item.color}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () => _removeItem(item),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(0, 0),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text(
                            'Remove',
                            style: TextStyle(
                              fontSize: 14,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Price
            Expanded(
              child: Text(
                '£${item.price.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 16),
              ),
            ),
            // Quantity
            Expanded(
              child: _buildQuantitySelector(item),
            ),
            // Total
            Expanded(
              child: Text(
                '£${item.totalPrice.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
      );
    }

    // Mobile layout
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: item.imageUrl != null
                    ? Image.asset(
                        item.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.image,
                              size: 40, color: Colors.grey);
                        },
                      )
                    : const Icon(Icons.image, size: 40, color: Colors.grey),
              ),
              const SizedBox(width: 16),
              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.productName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (item.variantDescription.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        item.variantDescription,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                    if (item.productId == 'personalisation' &&
                        item.color != null &&
                        item.color!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Personalisation Line 1: ${item.color}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    Text(
                      '£${item.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildQuantitySelector(item),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '£${item.totalPrice.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextButton(
                    onPressed: () => _removeItem(item),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      'Remove',
                      style: TextStyle(
                        fontSize: 14,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuantitySelector(CartItem item) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: () => _updateQuantity(item, item.quantity - 1),
          icon: const Icon(Icons.remove, size: 20),
          style: IconButton.styleFrom(
            backgroundColor: Colors.grey.shade200,
            padding: const EdgeInsets.all(8),
            minimumSize: const Size(32, 32),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            '${item.quantity}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        IconButton(
          onPressed: () => _updateQuantity(item, item.quantity + 1),
          icon: const Icon(Icons.add, size: 20),
          style: IconButton.styleFrom(
            backgroundColor: Colors.grey.shade200,
            padding: const EdgeInsets.all(8),
            minimumSize: const Size(32, 32),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
      ],
    );
  }

  Future<void> _updateQuantity(CartItem item, int newQuantity) async {
    await _cartService.updateQuantity(
      item.productId,
      newQuantity,
      color: item.color,
      size: item.size,
    );
  }

  Future<void> _removeItem(CartItem item) async {
    await _cartService.removeFromCart(
      item.productId,
      color: item.color,
      size: item.size,
    );
  }
}
