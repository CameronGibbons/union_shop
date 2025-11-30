class Product {
  final String id;
  final String name;
  final double price;
  final double? salePrice;
  final String imageUrl;
  final String? category;
  final List<String> sizes;
  final List<String> colors;
  final int stock;
  final bool isSale;
  final String? description;
  final String collectionId;

  Product({
    required this.id,
    required this.name,
    required this.price,
    this.salePrice,
    required this.imageUrl,
    this.category,
    this.sizes = const [],
    this.colors = const [],
    this.stock = 0,
    this.isSale = false,
    this.description,
    required this.collectionId,
  });

  bool get isInStock => stock > 0;
  bool get isOnSale => isSale && salePrice != null && salePrice! < price;
  double get displayPrice => isOnSale ? salePrice! : price;

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      salePrice: json['salePrice'] != null
          ? (json['salePrice'] as num).toDouble()
          : null,
      imageUrl: json['imageUrl'] as String,
      category: json['category'] as String?,
      sizes: (json['sizes'] as List<dynamic>?)?.cast<String>() ?? [],
      colors: (json['colors'] as List<dynamic>?)?.cast<String>() ?? [],
      stock: json['stock'] as int? ?? 0,
      isSale: json['isSale'] as bool? ?? false,
      description: json['description'] as String?,
      collectionId: json['collectionId'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'salePrice': salePrice,
      'imageUrl': imageUrl,
      'category': category,
      'sizes': sizes,
      'colors': colors,
      'stock': stock,
      'isSale': isSale,
      'description': description,
      'collectionId': collectionId,
    };
  }
}
