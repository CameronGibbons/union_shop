class CartItem {
  final String productId;
  final String productName;
  final String? color;
  final String? size;
  final double price;
  int quantity;
  final String? imageUrl;

  CartItem({
    required this.productId,
    required this.productName,
    this.color,
    this.size,
    required this.price,
    required this.quantity,
    this.imageUrl,
  });

  double get totalPrice => price * quantity;

  String get variantDescription {
    final parts = <String>[];
    if (color != null && color!.isNotEmpty) {
      parts.add('Color: $color');
    }
    if (size != null && size!.isNotEmpty) {
      parts.add('Size: $size');
    }
    return parts.join(' / ');
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'color': color,
      'size': size,
      'price': price,
      'quantity': quantity,
      'imageUrl': imageUrl,
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      productId: json['productId'] as String,
      productName: json['productName'] as String,
      color: json['color'] as String?,
      size: json['size'] as String?,
      price: (json['price'] as num).toDouble(),
      quantity: json['quantity'] as int,
      imageUrl: json['imageUrl'] as String?,
    );
  }

  // Check if this item matches another (same product and variants)
  bool matches(CartItem other) {
    return productId == other.productId &&
        color == other.color &&
        size == other.size;
  }

  CartItem copyWith({
    String? productId,
    String? productName,
    String? color,
    String? size,
    double? price,
    int? quantity,
    String? imageUrl,
  }) {
    return CartItem(
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      color: color ?? this.color,
      size: size ?? this.size,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
