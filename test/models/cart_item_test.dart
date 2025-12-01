import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/models/cart_item.dart';

void main() {
  group('CartItem', () {
    test('creates cart item with all properties', () {
      final item = CartItem(
        productId: 'test-123',
        productName: 'Test Product',
        color: 'Red',
        size: 'M',
        price: 19.99,
        quantity: 2,
        imageUrl: 'test.png',
      );

      expect(item.productId, 'test-123');
      expect(item.productName, 'Test Product');
      expect(item.color, 'Red');
      expect(item.size, 'M');
      expect(item.price, 19.99);
      expect(item.quantity, 2);
      expect(item.imageUrl, 'test.png');
    });

    test('totalPrice calculates correctly', () {
      final item = CartItem(
        productId: 'test-123',
        productName: 'Test Product',
        color: 'Red',
        size: 'M',
        price: 10.0,
        quantity: 3,
        imageUrl: 'test.png',
      );

      expect(item.totalPrice, 30.0);
    });

    test('matches returns true for identical variants', () {
      final item1 = CartItem(
        productId: 'test-123',
        productName: 'Test Product',
        color: 'Red',
        size: 'M',
        price: 10.0,
        quantity: 1,
        imageUrl: 'test.png',
      );

      final item2 = CartItem(
        productId: 'test-123',
        productName: 'Test Product',
        color: 'Red',
        size: 'M',
        price: 10.0,
        quantity: 2,
        imageUrl: 'test.png',
      );

      expect(item1.matches(item2), true);
    });

    test('matches returns false for different product IDs', () {
      final item1 = CartItem(
        productId: 'test-123',
        productName: 'Test Product',
        color: 'Red',
        size: 'M',
        price: 10.0,
        quantity: 1,
        imageUrl: 'test.png',
      );

      final item2 = CartItem(
        productId: 'test-456',
        productName: 'Test Product',
        color: 'Red',
        size: 'M',
        price: 10.0,
        quantity: 1,
        imageUrl: 'test.png',
      );

      expect(item1.matches(item2), false);
    });

    test('matches returns false for different colors', () {
      final item1 = CartItem(
        productId: 'test-123',
        productName: 'Test Product',
        color: 'Red',
        size: 'M',
        price: 10.0,
        quantity: 1,
        imageUrl: 'test.png',
      );

      final item2 = CartItem(
        productId: 'test-123',
        productName: 'Test Product',
        color: 'Blue',
        size: 'M',
        price: 10.0,
        quantity: 1,
        imageUrl: 'test.png',
      );

      expect(item1.matches(item2), false);
    });

    test('matches returns false for different sizes', () {
      final item1 = CartItem(
        productId: 'test-123',
        productName: 'Test Product',
        color: 'Red',
        size: 'M',
        price: 10.0,
        quantity: 1,
        imageUrl: 'test.png',
      );

      final item2 = CartItem(
        productId: 'test-123',
        productName: 'Test Product',
        color: 'Red',
        size: 'L',
        price: 10.0,
        quantity: 1,
        imageUrl: 'test.png',
      );

      expect(item1.matches(item2), false);
    });

    test('copyWith creates new instance with updated values', () {
      final item = CartItem(
        productId: 'test-123',
        productName: 'Test Product',
        color: 'Red',
        size: 'M',
        price: 10.0,
        quantity: 1,
        imageUrl: 'test.png',
      );

      final updated = item.copyWith(quantity: 5);

      expect(updated.productId, 'test-123');
      expect(updated.quantity, 5);
      expect(updated.color, 'Red');
    });

    test('toJson serializes correctly', () {
      final item = CartItem(
        productId: 'test-123',
        productName: 'Test Product',
        color: 'Red',
        size: 'M',
        price: 19.99,
        quantity: 2,
        imageUrl: 'test.png',
      );

      final json = item.toJson();

      expect(json['productId'], 'test-123');
      expect(json['productName'], 'Test Product');
      expect(json['color'], 'Red');
      expect(json['size'], 'M');
      expect(json['price'], 19.99);
      expect(json['quantity'], 2);
      expect(json['imageUrl'], 'test.png');
    });

    test('fromJson deserializes correctly', () {
      final json = {
        'productId': 'test-123',
        'productName': 'Test Product',
        'color': 'Red',
        'size': 'M',
        'price': 19.99,
        'quantity': 2,
        'imageUrl': 'test.png',
      };

      final item = CartItem.fromJson(json);

      expect(item.productId, 'test-123');
      expect(item.productName, 'Test Product');
      expect(item.color, 'Red');
      expect(item.size, 'M');
      expect(item.price, 19.99);
      expect(item.quantity, 2);
      expect(item.imageUrl, 'test.png');
    });

    test('variantDescription formats correctly', () {
      final item = CartItem(
        productId: 'test-123',
        productName: 'Test Product',
        color: 'Red',
        size: 'M',
        price: 10.0,
        quantity: 1,
        imageUrl: 'test.png',
      );

      expect(item.variantDescription, 'Color: Red / Size: M');
    });

    test('variantDescription with empty color', () {
      final item = CartItem(
        productId: 'test-123',
        productName: 'Test Product',
        color: '',
        size: 'M',
        price: 10.0,
        quantity: 1,
        imageUrl: 'test.png',
      );

      expect(item.variantDescription, 'Size: M');
    });

    test('variantDescription with empty size', () {
      final item = CartItem(
        productId: 'test-123',
        productName: 'Test Product',
        color: 'Red',
        size: '',
        price: 10.0,
        quantity: 1,
        imageUrl: 'test.png',
      );

      expect(item.variantDescription, 'Color: Red');
    });
  });
}
