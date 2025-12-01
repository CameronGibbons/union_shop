import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:union_shop/models/cart_item.dart';

class CartService extends ChangeNotifier {
  static final CartService _instance = CartService._internal();
  factory CartService() => _instance;
  CartService._internal();

  final List<CartItem> _cartItems = [];
  static const String _cartKey = 'shopping_cart';

  List<CartItem> get cartItems => List.unmodifiable(_cartItems);

  int get itemCount {
    return _cartItems.fold(0, (sum, item) => sum + item.quantity);
  }

  double get subtotal {
    return _cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  bool get isEmpty => _cartItems.isEmpty;
  bool get isNotEmpty => _cartItems.isNotEmpty;

  // Load cart from storage
  Future<void> loadCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartString = prefs.getString(_cartKey);

      if (cartString != null) {
        final List<dynamic> cartJson = jsonDecode(cartString);
        _cartItems.clear();
        _cartItems.addAll(
          cartJson
              .map((item) => CartItem.fromJson(item as Map<String, dynamic>)),
        );
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading cart: $e');
    }
  }

  // Save cart to storage
  Future<void> _saveCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartJson = _cartItems.map((item) => item.toJson()).toList();
      await prefs.setString(_cartKey, jsonEncode(cartJson));
    } catch (e) {
      debugPrint('Error saving cart: $e');
    }
  }

  // Find existing cart item
  CartItem? _findItem(String productId, {String? color, String? size}) {
    try {
      return _cartItems.firstWhere(
        (item) =>
            item.productId == productId &&
            item.color == color &&
            item.size == size,
      );
    } catch (e) {
      return null;
    }
  }

  // Add item to cart
  Future<void> addToCart(CartItem newItem) async {
    final existingItem = _findItem(
      newItem.productId,
      color: newItem.color,
      size: newItem.size,
    );

    if (existingItem != null) {
      // Item already exists, increment quantity
      existingItem.quantity += newItem.quantity;
    } else {
      // Add new item
      _cartItems.add(newItem);
    }

    await _saveCart();
    notifyListeners();
  }

  // Remove item from cart
  Future<void> removeFromCart(String productId,
      {String? color, String? size}) async {
    _cartItems.removeWhere(
      (item) =>
          item.productId == productId &&
          item.color == color &&
          item.size == size,
    );

    await _saveCart();
    notifyListeners();
  }

  // Update item quantity
  Future<void> updateQuantity(
    String productId,
    int quantity, {
    String? color,
    String? size,
  }) async {
    if (quantity <= 0) {
      await removeFromCart(productId, color: color, size: size);
      return;
    }

    final item = _findItem(productId, color: color, size: size);
    if (item != null) {
      item.quantity = quantity;
      await _saveCart();
      notifyListeners();
    }
  }

  // Clear entire cart
  Future<void> clearCart() async {
    _cartItems.clear();
    await _saveCart();
    notifyListeners();
  }

  // Get specific item count
  int getItemQuantity(String productId, {String? color, String? size}) {
    final item = _findItem(productId, color: color, size: size);
    return item?.quantity ?? 0;
  }
}
