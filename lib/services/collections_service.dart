import 'package:union_shop/models/collection.dart';

class CollectionsService {
  // Singleton pattern
  static final CollectionsService _instance = CollectionsService._internal();
  factory CollectionsService() => _instance;
  CollectionsService._internal();

  // Mock data - in a real app, this would come from an API or database
  final List<Collection> _collections = [
    Collection(
      id: 'autumn-favourites',
      name: 'Autumn Favourites',
      imageUrl: 'assets/images/category_clothing.png',
      description: 'Cozy essentials for the autumn season',
      productCount: 15,
      isFeatured: true,
      tags: ['seasonal', 'clothing'],
    ),
    Collection(
      id: 'black-friday',
      name: 'Black Friday',
      imageUrl: 'assets/images/category_sale.png',
      description: 'Special Black Friday deals and discounts',
      productCount: 42,
      isFeatured: true,
      tags: ['sale', 'special'],
    ),
    Collection(
      id: 'clothing',
      name: 'Clothing',
      imageUrl: 'assets/images/signature_hoodie.png',
      description: 'All clothing items',
      productCount: 78,
      tags: ['clothing'],
    ),
    Collection(
      id: 'clothing-original',
      name: 'Clothing - Original',
      imageUrl: 'assets/images/signature_hoodie.png',
      description: 'Original clothing collection',
      productCount: 45,
      tags: ['clothing', 'original'],
    ),
    Collection(
      id: 'elections-discounts',
      name: 'Elections Discounts',
      imageUrl: 'assets/images/essential_hoodie.png',
      description: 'Special election period discounts',
      productCount: 12,
      tags: ['sale', 'special'],
    ),
    Collection(
      id: 'essential-range',
      name: 'Essential Range',
      imageUrl: 'assets/images/essential_hoodie.png',
      description: 'Our core essential products',
      productCount: 24,
      isFeatured: true,
      tags: ['essential', 'popular'],
    ),
    Collection(
      id: 'graduation',
      name: 'Graduation',
      imageUrl: 'assets/images/category_graduation.png',
      description: 'Celebrate your achievement',
      productCount: 18,
      tags: ['graduation', 'special'],
    ),
    Collection(
      id: 'limited-edition-hoodies',
      name: 'Limited Edition Essential Zip Hoodies',
      imageUrl: 'assets/images/essential_hoodie.png',
      description: 'Limited stock available',
      productCount: 8,
      isFeatured: true,
      tags: ['limited', 'clothing'],
    ),
    Collection(
      id: 'merchandise',
      name: 'Merchandise',
      imageUrl: 'assets/images/category_merchandise.png',
      description: 'Official UPSU merchandise',
      productCount: 56,
      tags: ['merchandise'],
    ),
    Collection(
      id: 'nike-final-chance',
      name: 'Nike Final Chance',
      imageUrl: 'assets/images/category_sale.png',
      description: 'Last chance Nike products',
      productCount: 9,
      tags: ['sale', 'nike', 'limited'],
    ),
    Collection(
      id: 'personalisation',
      name: 'Personalisation',
      imageUrl: 'assets/images/personalization_banner.png',
      description: 'Add your personal touch',
      productCount: 32,
      tags: ['personalisation', 'custom'],
    ),
    Collection(
      id: 'popular',
      name: 'Popular',
      imageUrl: 'assets/images/signature_tshirt.png',
      description: 'Most popular items',
      productCount: 28,
      isFeatured: true,
      tags: ['popular'],
    ),
    Collection(
      id: 'portsmouth-city',
      name: 'Portsmouth City Collection',
      imageUrl: 'assets/images/portsmouth_postcard.png',
      description: 'Portsmouth themed gifts and souvenirs',
      productCount: 16,
      isFeatured: true,
      tags: ['portsmouth', 'gifts'],
    ),
    Collection(
      id: 'pride-collection',
      name: 'Pride Collection',
      imageUrl: 'assets/images/signature_tshirt.png',
      description: 'Show your pride',
      productCount: 11,
      tags: ['pride', 'special'],
    ),
    Collection(
      id: 'sale',
      name: 'SALE',
      imageUrl: 'assets/images/category_sale.png',
      description: 'All sale items',
      productCount: 67,
      isFeatured: true,
      tags: ['sale'],
    ),
    Collection(
      id: 'signature-essential',
      name: 'Signature & Essential Range',
      imageUrl: 'assets/images/signature_hoodie.png',
      description: 'Combined signature and essential products',
      productCount: 48,
      tags: ['signature', 'essential'],
    ),
    Collection(
      id: 'signature-range',
      name: 'Signature Range',
      imageUrl: 'assets/images/signature_hoodie.png',
      description: 'Premium signature collection',
      productCount: 29,
      isFeatured: true,
      tags: ['signature', 'premium'],
    ),
    Collection(
      id: 'sports-clubs',
      name: 'Sports Clubs',
      imageUrl: 'assets/images/signature_hoodie.png',
      description: 'Sports club merchandise',
      productCount: 34,
      tags: ['sports', 'clubs'],
    ),
    Collection(
      id: 'spring-favourites',
      name: 'Spring Favourites',
      imageUrl: 'assets/images/essential_tshirt.png',
      description: 'Fresh picks for spring',
      productCount: 21,
      tags: ['seasonal', 'spring'],
    ),
    Collection(
      id: 'student-essentials',
      name: 'Student Essentials',
      imageUrl: 'assets/images/essential_tshirt.png',
      description: 'Must-have items for students',
      productCount: 38,
      tags: ['student', 'essential'],
    ),
    Collection(
      id: 'student-groups',
      name: 'Student Groups',
      imageUrl: 'assets/images/signature_hoodie.png',
      description: 'Student group merchandise',
      productCount: 25,
      tags: ['student', 'groups'],
    ),
    Collection(
      id: 'summer-essentials',
      name: 'Summer Essentials',
      imageUrl: 'assets/images/essential_tshirt.png',
      description: 'Beat the heat in style',
      productCount: 19,
      tags: ['seasonal', 'summer'],
    ),
    Collection(
      id: 'summer-favourites',
      name: 'Summer Favourites',
      imageUrl: 'assets/images/essential_tshirt.png',
      description: 'Summer must-haves',
      productCount: 22,
      tags: ['seasonal', 'summer'],
    ),
    Collection(
      id: 'university-clothing',
      name: 'University Clothing',
      imageUrl: 'assets/images/signature_hoodie.png',
      description: 'Official university apparel',
      productCount: 44,
      tags: ['university', 'clothing'],
    ),
    Collection(
      id: 'university-merchandise',
      name: 'University Merchandise',
      imageUrl: 'assets/images/category_merchandise.png',
      description: 'Official university products',
      productCount: 52,
      tags: ['university', 'merchandise'],
    ),
    Collection(
      id: 'upsu-bears',
      name: 'UPSU Bears',
      imageUrl: 'assets/images/logo.png',
      description: 'Adorable UPSU teddy bears',
      productCount: 6,
      tags: ['bears', 'gifts'],
    ),
    Collection(
      id: 'winter-favourites',
      name: 'Winter Favourites',
      imageUrl: 'assets/images/essential_hoodie.png',
      description: 'Stay warm this winter',
      productCount: 31,
      tags: ['seasonal', 'winter'],
    ),
  ];

  // Get all collections
  Future<List<Collection>> getAllCollections() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_collections);
  }

  // Get featured collections
  Future<List<Collection>> getFeaturedCollections() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _collections.where((c) => c.isFeatured).toList();
  }

  // Get collection by ID
  Future<Collection?> getCollectionById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _collections.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }

  // Search collections by name
  Future<List<Collection>> searchCollections(String query) async {
    await Future.delayed(const Duration(milliseconds: 200));
    if (query.isEmpty) return List.from(_collections);

    final lowerQuery = query.toLowerCase();
    return _collections
        .where((c) =>
            c.name.toLowerCase().contains(lowerQuery) ||
            (c.description?.toLowerCase().contains(lowerQuery) ?? false))
        .toList();
  }

  // Filter collections by tag
  Future<List<Collection>> getCollectionsByTag(String tag) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _collections.where((c) => c.tags.contains(tag)).toList();
  }

  // Get collections sorted by product count
  Future<List<Collection>> getCollectionsSortedByProductCount({
    bool descending = true,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final sorted = List<Collection>.from(_collections);
    sorted.sort((a, b) => descending
        ? b.productCount.compareTo(a.productCount)
        : a.productCount.compareTo(b.productCount));
    return sorted;
  }
}
