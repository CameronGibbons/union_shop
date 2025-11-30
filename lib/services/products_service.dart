import 'package:union_shop/models/product.dart';

class ProductsService {
  // Singleton pattern
  static final ProductsService _instance = ProductsService._internal();
  factory ProductsService() => _instance;
  ProductsService._internal();

  // Mock product data for autumn-favourites collection
  final List<Product> _products = [
    Product(
      id: 'classic-sweatshirt',
      name: 'Classic Sweatshirts',
      price: 23.00,
      imageUrl: 'assets/images/signature_hoodie.png',
      category: 'Clothing',
      sizes: ['S', 'M', 'L', 'XL'],
      colors: ['Green', 'Black', 'Purple'],
      stock: 45,
      collectionId: 'autumn-favourites',
      description: 'Comfortable classic sweatshirt',
    ),
    Product(
      id: 'classic-t-shirt',
      name: 'Classic T-Shirts',
      price: 11.00,
      imageUrl: 'assets/images/signature_tshirt.png',
      category: 'Clothing',
      sizes: ['S', 'M', 'L', 'XL'],
      colors: ['Black', 'White', 'Grey'],
      stock: 60,
      collectionId: 'autumn-favourites',
      description: 'Essential classic t-shirt',
    ),
    Product(
      id: 'classic-hoodie',
      name: 'Classic Hoodies',
      price: 25.00,
      imageUrl: 'assets/images/essential_hoodie.png',
      category: 'Clothing',
      sizes: ['S', 'M', 'L', 'XL', 'XXL'],
      colors: ['Purple', 'Black', 'Navy'],
      stock: 38,
      collectionId: 'autumn-favourites',
      description: 'Warm and cozy hoodie',
    ),
    Product(
      id: 'classic-beanie',
      name: 'Classic Beanie Hat',
      price: 12.00,
      imageUrl: 'assets/images/category_merchandise.png',
      category: 'Accessories',
      sizes: ['One Size'],
      colors: ['Black', 'Purple', 'Grey'],
      stock: 72,
      collectionId: 'autumn-favourites',
      description: 'Keep warm with our beanie',
    ),
    Product(
      id: 'lanyard',
      name: 'Lanyards',
      price: 2.75,
      imageUrl: 'assets/images/category_merchandise.png',
      category: 'Accessories',
      sizes: ['One Size'],
      colors: ['Purple'],
      stock: 150,
      collectionId: 'autumn-favourites',
      description: 'Practical lanyard',
    ),
    Product(
      id: 'keep-cup',
      name: 'Keep Cups',
      price: 6.50,
      imageUrl: 'assets/images/category_merchandise.png',
      category: 'Merchandise',
      sizes: ['One Size'],
      colors: ['Black'],
      stock: 25,
      collectionId: 'autumn-favourites',
      description: 'Reusable coffee cup',
    ),
    Product(
      id: 'a5-notepad',
      name: 'A5 Notepad',
      price: 3.50,
      imageUrl: 'assets/images/category_merchandise.png',
      category: 'Stationery',
      sizes: ['A5'],
      colors: ['Purple'],
      stock: 0,
      collectionId: 'autumn-favourites',
      description: 'Perfect for notes',
    ),
    Product(
      id: 'pen',
      name: 'Pen',
      price: 1.00,
      imageUrl: 'assets/images/category_merchandise.png',
      category: 'Stationery',
      sizes: ['One Size'],
      colors: ['Purple', 'White'],
      stock: 200,
      collectionId: 'autumn-favourites',
      description: 'Quality pen',
    ),
    Product(
      id: 'classic-sweatshirt-neutral',
      name: 'Classic Sweatshirts - Neutral',
      price: 17.00,
      salePrice: 10.99,
      imageUrl: 'assets/images/signature_hoodie.png',
      category: 'Clothing',
      sizes: ['S', 'M', 'L', 'XL'],
      colors: ['Cream', 'Beige'],
      stock: 22,
      isSale: true,
      collectionId: 'autumn-favourites',
      description: 'Neutral colored sweatshirt on sale',
    ),
    Product(
      id: 'signature-hoodie',
      name: 'Signature Hoodie',
      price: 28.00,
      imageUrl: 'assets/images/signature_hoodie.png',
      category: 'Clothing',
      sizes: ['S', 'M', 'L', 'XL'],
      colors: ['Purple', 'Black'],
      stock: 32,
      collectionId: 'autumn-favourites',
      description: 'Premium signature hoodie',
    ),
    // Add products for other collections
    Product(
      id: 'essential-tshirt-1',
      name: 'Essential T-Shirt',
      price: 12.00,
      imageUrl: 'assets/images/essential_tshirt.png',
      category: 'Clothing',
      sizes: ['S', 'M', 'L', 'XL'],
      colors: ['White', 'Black', 'Grey'],
      stock: 85,
      collectionId: 'essential-range',
      description: 'Basic essential t-shirt',
    ),
    Product(
      id: 'essential-hoodie-1',
      name: 'Essential Hoodie',
      price: 22.00,
      imageUrl: 'assets/images/essential_hoodie.png',
      category: 'Clothing',
      sizes: ['S', 'M', 'L', 'XL'],
      colors: ['Black', 'Navy'],
      stock: 48,
      collectionId: 'essential-range',
      description: 'Comfortable essential hoodie',
    ),
    Product(
      id: 'sale-item-1',
      name: 'Discounted Hoodie',
      price: 30.00,
      salePrice: 19.99,
      imageUrl: 'assets/images/signature_hoodie.png',
      category: 'Clothing',
      sizes: ['M', 'L', 'XL'],
      colors: ['Green'],
      stock: 15,
      isSale: true,
      collectionId: 'sale',
      description: 'Great deal on this hoodie',
    ),
    Product(
      id: 'sale-item-2',
      name: 'Clearance T-Shirt',
      price: 15.00,
      salePrice: 8.99,
      imageUrl: 'assets/images/essential_tshirt.png',
      category: 'Clothing',
      sizes: ['S', 'M'],
      colors: ['Grey'],
      stock: 8,
      isSale: true,
      collectionId: 'sale',
      description: 'Final clearance item',
    ),
  ];

  // Get products by collection ID
  Future<List<Product>> getProductsByCollection(String collectionId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _products.where((p) => p.collectionId == collectionId).toList();
  }

  // Get all products
  Future<List<Product>> getAllProducts() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_products);
  }

  // Filter products
  Future<List<Product>> filterProducts({
    String? collectionId,
    String? category,
    bool? onSale,
    bool? inStock,
    double? minPrice,
    double? maxPrice,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));

    var filtered = List<Product>.from(_products);

    if (collectionId != null) {
      filtered = filtered.where((p) => p.collectionId == collectionId).toList();
    }

    if (category != null) {
      filtered = filtered.where((p) => p.category == category).toList();
    }

    if (onSale == true) {
      filtered = filtered.where((p) => p.isOnSale).toList();
    }

    if (inStock == true) {
      filtered = filtered.where((p) => p.isInStock).toList();
    }

    if (minPrice != null) {
      filtered = filtered.where((p) => p.displayPrice >= minPrice).toList();
    }

    if (maxPrice != null) {
      filtered = filtered.where((p) => p.displayPrice <= maxPrice).toList();
    }

    return filtered;
  }

  // Sort products
  List<Product> sortProducts(List<Product> products, String sortBy) {
    final sorted = List<Product>.from(products);

    switch (sortBy) {
      case 'price-asc':
        sorted.sort((a, b) => a.displayPrice.compareTo(b.displayPrice));
        break;
      case 'price-desc':
        sorted.sort((a, b) => b.displayPrice.compareTo(a.displayPrice));
        break;
      case 'name-asc':
        sorted.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'name-desc':
        sorted.sort((a, b) => b.name.compareTo(a.name));
        break;
      case 'featured':
      default:
        // Keep original order for featured
        break;
    }

    return sorted;
  }

  // Get unique categories from products
  Set<String> getCategories(List<Product> products) {
    return products
        .map((p) => p.category)
        .where((c) => c != null)
        .cast<String>()
        .toSet();
  }

  // Paginate products
  List<Product> paginateProducts(
      List<Product> products, int page, int itemsPerPage) {
    final startIndex = page * itemsPerPage;
    final endIndex = (startIndex + itemsPerPage).clamp(0, products.length);

    if (startIndex >= products.length) {
      return [];
    }

    return products.sublist(startIndex, endIndex);
  }

  // Get total pages
  int getTotalPages(int totalItems, int itemsPerPage) {
    return (totalItems / itemsPerPage).ceil();
  }
}
