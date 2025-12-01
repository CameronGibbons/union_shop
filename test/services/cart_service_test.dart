import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:union_shop/services/cart_service.dart';
import 'package:union_shop/models/cart_item.dart';

void main() {
  group('CartService', () {
    late CartService cartService;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      cartService = CartService();
      await cartService.loadCart();
      await cartService.clearCart(); // Ensure clean state
    });

    test('initially cart is empty', () {
      expect(cartService.cartItems, isEmpty);
      expect(cartService.itemCount, 0);
      expect(cartService.subtotal, 0.0);
      expect(cartService.isEmpty, true);
    });

    test('addToCart adds item to cart', () async {
      final item = CartItem(
        productId: 'test-product',
        productName: 'Test Product',
        color: 'Red',
        size: 'M',
        price: 10.0,
        quantity: 1,
        imageUrl: 'test.png',
      );

      await cartService.addToCart(item);

      expect(cartService.cartItems.length, 1);
      expect(cartService.itemCount, 1);
      expect(cartService.subtotal, 10.0);
      expect(cartService.isEmpty, false);
    });

    test('addToCart merges identical items', () async {
      final item1 = CartItem(
        productId: 'test-product',
        productName: 'Test Product',
        color: 'Red',
        size: 'M',
        price: 10.0,
        quantity: 1,
        imageUrl: 'test.png',
      );

      final item2 = CartItem(
        productId: 'test-product',
        productName: 'Test Product',
        color: 'Red',
        size: 'M',
        price: 10.0,
        quantity: 2,
        imageUrl: 'test.png',
      );

      await cartService.addToCart(item1);
      await cartService.addToCart(item2);

      expect(cartService.cartItems.length, 1);
      expect(cartService.cartItems[0].quantity, 3);
      expect(cartService.subtotal, 30.0);
    });

    test('addToCart keeps different variants separate', () async {
      final item1 = CartItem(
        productId: 'test-product',
        productName: 'Test Product',
        color: 'Red',
        size: 'M',
        price: 10.0,
        quantity: 1,
        imageUrl: 'test.png',
      );

      final item2 = CartItem(
        productId: 'test-product',
        productName: 'Test Product',
        color: 'Blue',
        size: 'M',
        price: 10.0,
        quantity: 1,
        imageUrl: 'test.png',
      );

      await cartService.addToCart(item1);
      await cartService.addToCart(item2);

      expect(cartService.cartItems.length, 2);
      expect(cartService.subtotal, 20.0);
    });

    test('removeFromCart removes item', () async {
      final item = CartItem(
        productId: 'test-product',
        productName: 'Test Product',
        color: 'Red',
        size: 'M',
        price: 10.0,
        quantity: 1,
        imageUrl: 'test.png',
      );

      await cartService.addToCart(item);
      expect(cartService.cartItems.length, 1);

      await cartService.removeFromCart('test-product', color: 'Red', size: 'M');
      expect(cartService.cartItems.length, 0);
      expect(cartService.isEmpty, true);
    });

    test('updateQuantity updates item quantity', () async {
      final item = CartItem(
        productId: 'test-product',
        productName: 'Test Product',
        color: 'Red',
        size: 'M',
        price: 10.0,
        quantity: 1,
        imageUrl: 'test.png',
      );

      await cartService.addToCart(item);
      await cartService.updateQuantity('test-product', 5, color: 'Red', size: 'M');

      expect(cartService.cartItems[0].quantity, 5);
      expect(cartService.subtotal, 50.0);
    });

    test('updateQuantity removes item when quantity is 0', () async {
      final item = CartItem(
        productId: 'test-product',
        productName: 'Test Product',
        color: 'Red',
        size: 'M',
        price: 10.0,
        quantity: 1,
        imageUrl: 'test.png',
      );

      await cartService.addToCart(item);
      await cartService.updateQuantity('test-product', 0, color: 'Red', size: 'M');

      expect(cartService.cartItems.length, 0);
    });

    test('clearCart removes all items', () async {
      final item1 = CartItem(
        productId: 'test-product-1',
        productName: 'Test Product 1',
        color: 'Red',
        size: 'M',
        price: 10.0,
        quantity: 1,
        imageUrl: 'test1.png',
      );

      final item2 = CartItem(
        productId: 'test-product-2',
        productName: 'Test Product 2',
        color: 'Blue',
        size: 'L',
        price: 15.0,
        quantity: 2,
        imageUrl: 'test2.png',
      );

      await cartService.addToCart(item1);
      await cartService.addToCart(item2);
      expect(cartService.cartItems.length, 2);

      await cartService.clearCart();
      expect(cartService.cartItems.length, 0);
      expect(cartService.isEmpty, true);
      expect(cartService.subtotal, 0.0);
    });

    test('itemCount returns total quantity of all items', () async {
      final item1 = CartItem(
        productId: 'test-product-1',
        productName: 'Test Product 1',
        color: 'Red',
        size: 'M',
        price: 10.0,
        quantity: 2,
        imageUrl: 'test1.png',
      );

      final item2 = CartItem(
        productId: 'test-product-2',
        productName: 'Test Product 2',
        color: 'Blue',
        size: 'L',
        price: 15.0,
        quantity: 3,
        imageUrl: 'test2.png',
      );

      await cartService.addToCart(item1);
      await cartService.addToCart(item2);

      expect(cartService.itemCount, 5);
    });

    test('subtotal calculates correct total', () async {
      final item1 = CartItem(
        productId: 'test-product-1',
        productName: 'Test Product 1',
        color: 'Red',
        size: 'M',
        price: 10.0,
        quantity: 2,
        imageUrl: 'test1.png',
      );

      final item2 = CartItem(
        productId: 'test-product-2',
        productName: 'Test Product 2',
        color: 'Blue',
        size: 'L',
        price: 15.0,
        quantity: 3,
        imageUrl: 'test2.png',
      );

      await cartService.addToCart(item1);
      await cartService.addToCart(item2);

      expect(cartService.subtotal, 65.0); // (10*2) + (15*3)
    });

    test('getItemQuantity returns correct quantity', () async {
      final item = CartItem(
        productId: 'test-product',
        productName: 'Test Product',
        color: 'Red',
        size: 'M',
        price: 10.0,
        quantity: 3,
        imageUrl: 'test.png',
      );

      await cartService.addToCart(item);

      expect(cartService.getItemQuantity('test-product', color: 'Red', size: 'M'), 3);
      expect(cartService.getItemQuantity('test-product', color: 'Blue', size: 'M'), 0);
    });

    test('cart persists across instances', () async {
      final item = CartItem(
        productId: 'test-product',
        productName: 'Test Product',
        color: 'Red',
        size: 'M',
        price: 10.0,
        quantity: 1,
        imageUrl: 'test.png',
      );

      await cartService.addToCart(item);

      // Create new instance and load cart
      final newCartService = CartService();
      await newCartService.loadCart();

      expect(newCartService.cartItems.length, 1);
      expect(newCartService.cartItems[0].productId, 'test-product');
      expect(newCartService.subtotal, 10.0);
    });
  });
}
