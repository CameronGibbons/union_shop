import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/models/order.dart';

void main() {
  group('OrderItem', () {
    test('creates order item with all properties', () {
      final item = OrderItem(
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
      final item = OrderItem(
        productId: 'test-123',
        productName: 'Test Product',
        color: 'Red',
        size: 'M',
        price: 10.0,
        quantity: 3,
      );

      expect(item.totalPrice, 30.0);
    });

    test('variantDescription formats correctly', () {
      final item = OrderItem(
        productId: 'test-123',
        productName: 'Test Product',
        color: 'Red',
        size: 'M',
        price: 10.0,
        quantity: 1,
      );

      expect(item.variantDescription, 'Red / M');
    });

    test('toJson serializes correctly', () {
      final item = OrderItem(
        productId: 'test-123',
        productName: 'Test Product',
        color: 'Red',
        size: 'M',
        price: 19.99,
        quantity: 2,
        imageUrl: 'test.png',
      );

      final json = item.toJson();

      expect(json['product_id'], 'test-123');
      expect(json['product_name'], 'Test Product');
      expect(json['color'], 'Red');
      expect(json['size'], 'M');
      expect(json['price'], 19.99);
      expect(json['quantity'], 2);
      expect(json['image_url'], 'test.png');
    });

    test('fromJson deserializes correctly', () {
      final json = {
        'product_id': 'test-123',
        'product_name': 'Test Product',
        'color': 'Red',
        'size': 'M',
        'price': 19.99,
        'quantity': 2,
        'image_url': 'test.png',
      };

      final item = OrderItem.fromJson(json);

      expect(item.productId, 'test-123');
      expect(item.productName, 'Test Product');
      expect(item.color, 'Red');
      expect(item.size, 'M');
      expect(item.price, 19.99);
      expect(item.quantity, 2);
      expect(item.imageUrl, 'test.png');
    });
  });

  group('Order', () {
    test('creates order with all properties', () {
      final items = [
        OrderItem(
          productId: 'test-123',
          productName: 'Test Product',
          color: 'Red',
          size: 'M',
          price: 10.0,
          quantity: 2,
        ),
      ];

      final order = Order(
        id: 'order-123',
        userId: 'user-456',
        items: items,
        subtotal: 20.0,
        tax: 4.0,
        total: 24.0,
        status: 'pending',
        note: 'Test note',
        createdAt: DateTime(2025, 1, 1),
        updatedAt: DateTime(2025, 1, 2),
      );

      expect(order.id, 'order-123');
      expect(order.userId, 'user-456');
      expect(order.items.length, 1);
      expect(order.subtotal, 20.0);
      expect(order.tax, 4.0);
      expect(order.total, 24.0);
      expect(order.status, 'pending');
      expect(order.note, 'Test note');
      expect(order.createdAt, DateTime(2025, 1, 1));
      expect(order.updatedAt, DateTime(2025, 1, 2));
    });

    test('toJson serializes correctly', () {
      final items = [
        OrderItem(
          productId: 'test-123',
          productName: 'Test Product',
          color: 'Red',
          size: 'M',
          price: 10.0,
          quantity: 2,
        ),
      ];

      final order = Order(
        id: 'order-123',
        userId: 'user-456',
        items: items,
        subtotal: 20.0,
        tax: 4.0,
        total: 24.0,
        status: 'pending',
        note: 'Test note',
        createdAt: DateTime(2025, 1, 1),
        updatedAt: DateTime(2025, 1, 2),
      );

      final json = order.toJson();

      expect(json['id'], 'order-123');
      expect(json['user_id'], 'user-456');
      expect(json['items'], isList);
      expect(json['subtotal'], 20.0);
      expect(json['tax'], 4.0);
      expect(json['total'], 24.0);
      expect(json['status'], 'pending');
      expect(json['note'], 'Test note');
    });

    test('fromJson deserializes correctly', () {
      final json = {
        'id': 'order-123',
        'user_id': 'user-456',
        'items': [
          {
            'product_id': 'test-123',
            'product_name': 'Test Product',
            'color': 'Red',
            'size': 'M',
            'price': 10.0,
            'quantity': 2,
            'image_url': 'test.png',
          }
        ],
        'subtotal': 20.0,
        'tax': 4.0,
        'total': 24.0,
        'status': 'pending',
        'note': 'Test note',
        'created_at': '2025-01-01T00:00:00.000',
        'updated_at': '2025-01-02T00:00:00.000',
      };

      final order = Order.fromJson(json);

      expect(order.id, 'order-123');
      expect(order.userId, 'user-456');
      expect(order.items.length, 1);
      expect(order.items[0].productId, 'test-123');
      expect(order.subtotal, 20.0);
      expect(order.tax, 4.0);
      expect(order.total, 24.0);
      expect(order.status, 'pending');
      expect(order.note, 'Test note');
    });

    test('handles null note', () {
      final order = Order(
        id: 'order-123',
        userId: 'user-456',
        items: [],
        subtotal: 0.0,
        tax: 0.0,
        total: 0.0,
        status: 'pending',
        note: null,
        createdAt: DateTime(2025, 1, 1),
      );

      expect(order.note, null);
    });

    test('handles null updatedAt', () {
      final order = Order(
        id: 'order-123',
        userId: 'user-456',
        items: [],
        subtotal: 0.0,
        tax: 0.0,
        total: 0.0,
        status: 'pending',
        createdAt: DateTime(2025, 1, 1),
        updatedAt: null,
      );

      expect(order.updatedAt, null);
    });
  });
}
