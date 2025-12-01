import 'package:union_shop/models/product.dart';
import 'package:union_shop/services/products_service.dart';

class SearchService {
  final ProductsService _productsService = ProductsService();

  /// Search products by query across multiple fields
  Future<List<Product>> searchProducts(String query) async {
    if (query.trim().isEmpty) {
      return [];
    }

    // Get all products
    final allProducts = await _productsService.getAllProducts();

    // Filter and score products
    final results = _filterAndScoreProducts(allProducts, query.trim());

    return results;
  }

  /// Filter products and calculate relevance scores
  List<Product> _filterAndScoreProducts(List<Product> products, String query) {
    final queryLower = query.toLowerCase();
    final scoredProducts = <_ScoredProduct>[];

    for (final product in products) {
      final score = _calculateRelevance(product, queryLower);
      if (score > 0) {
        scoredProducts.add(_ScoredProduct(product, score));
      }
    }

    // Sort by score (descending), then by name (alphabetically)
    scoredProducts.sort((a, b) {
      final scoreCompare = b.score.compareTo(a.score);
      if (scoreCompare != 0) return scoreCompare;
      return a.product.name.compareTo(b.product.name);
    });

    return scoredProducts.map((sp) => sp.product).toList();
  }

  /// Calculate relevance score for a product
  int _calculateRelevance(Product product, String queryLower) {
    int score = 0;
    final nameLower = product.name.toLowerCase();
    final descriptionLower = product.description?.toLowerCase() ?? '';
    final categoryLower = product.category?.toLowerCase() ?? '';
    final collectionIdLower = product.collectionId.toLowerCase();

    // Exact match (product name == query)
    if (nameLower == queryLower) {
      score += 100;
    }

    // Name starts with query
    if (nameLower.startsWith(queryLower)) {
      score += 50;
    }

    // Name contains query
    if (nameLower.contains(queryLower)) {
      score += 25;
    }

    // Description contains query
    if (descriptionLower.contains(queryLower)) {
      score += 10;
    }

    // Category contains query
    if (categoryLower.contains(queryLower)) {
      score += 5;
    }

    // Collection contains query
    if (collectionIdLower.contains(queryLower)) {
      score += 5;
    }

    // Check for multi-word queries
    final queryWords = queryLower.split(' ');
    if (queryWords.length > 1) {
      int wordMatchScore = 0;
      for (final word in queryWords) {
        if (word.isEmpty) continue;
        if (nameLower.contains(word)) wordMatchScore += 5;
        if (descriptionLower.contains(word)) wordMatchScore += 2;
      }
      score += wordMatchScore;
    }

    return score;
  }
}

/// Internal class to hold product with relevance score
class _ScoredProduct {
  final Product product;
  final int score;

  _ScoredProduct(this.product, this.score);
}
