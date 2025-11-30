class Collection {
  final String id;
  final String name;
  final String imageUrl;
  final String? description;
  final int productCount;
  final bool isFeatured;
  final List<String> tags;

  Collection({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.description,
    this.productCount = 0,
    this.isFeatured = false,
    this.tags = const [],
  });

  factory Collection.fromJson(Map<String, dynamic> json) {
    return Collection(
      id: json['id'] as String,
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String,
      description: json['description'] as String?,
      productCount: json['productCount'] as int? ?? 0,
      isFeatured: json['isFeatured'] as bool? ?? false,
      tags: (json['tags'] as List<dynamic>?)?.cast<String>() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'description': description,
      'productCount': productCount,
      'isFeatured': isFeatured,
      'tags': tags,
    };
  }
}
