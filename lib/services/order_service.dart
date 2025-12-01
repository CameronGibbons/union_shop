import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:union_shop/models/order.dart';
import 'package:union_shop/models/cart_item.dart';

class OrderService {
  final _supabase = Supabase.instance.client;

  // Create a new order from cart items
  Future<Order> createOrder({
    required List<CartItem> items,
    String? note,
  }) async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      throw Exception('User must be authenticated to create an order');
    }

    // Calculate totals
    final subtotal = items.fold<double>(0.0, (sum, item) => sum + item.totalPrice);
    final tax = subtotal * 0.20; // 20% VAT
    final total = subtotal + tax;

    // Convert cart items to order items
    final orderItems = items
        .map((item) => OrderItem(
              productId: item.productId,
              productName: item.productName,
              color: item.color,
              size: item.size,
              price: item.price,
              quantity: item.quantity,
              imageUrl: item.imageUrl,
            ))
        .toList();

    // Create order in database
    final orderData = {
      'user_id': user.id,
      'items': orderItems.map((item) => item.toJson()).toList(),
      'subtotal': subtotal,
      'tax': tax,
      'total': total,
      'status': 'pending',
      'note': note,
    };

    final response = await _supabase
        .from('orders')
        .insert(orderData)
        .select()
        .single();

    return Order.fromJson(response);
  }

  // Get all orders for the current user
  Future<List<Order>> getUserOrders() async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      throw Exception('User must be authenticated to view orders');
    }

    final response = await _supabase
        .from('orders')
        .select()
        .eq('user_id', user.id)
        .order('created_at', ascending: false);

    return (response as List<dynamic>)
        .map((json) => Order.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  // Get a specific order by ID
  Future<Order?> getOrderById(String orderId) async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      throw Exception('User must be authenticated to view orders');
    }

    final response = await _supabase
        .from('orders')
        .select()
        .eq('id', orderId)
        .eq('user_id', user.id)
        .maybeSingle();

    if (response == null) return null;

    return Order.fromJson(response);
  }

  // Update order status (for admin/testing purposes)
  Future<void> updateOrderStatus(String orderId, String status) async {
    await _supabase
        .from('orders')
        .update({'status': status, 'updated_at': DateTime.now().toIso8601String()})
        .eq('id', orderId);
  }

  // Cancel an order
  Future<void> cancelOrder(String orderId) async {
    await updateOrderStatus(orderId, 'cancelled');
  }
}
