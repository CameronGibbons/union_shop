import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/services/search_service.dart';
import 'package:union_shop/models/product.dart';

void main() {
  group('SearchService', () {
    late SearchService searchService;

    setUp(() {
      searchService = SearchService();
    });

    test('searchProducts returns empty list for empty query', () async {
      final results = await searchService.searchProducts('');
      expect(results, isEmpty);
    });

    test('searchProducts returns empty list for whitespace query', () async {
      final results = await searchService.searchProducts('   ');
      expect(results, isEmpty);
    });

    test('searchProducts returns results for valid query', () async {
      final results = await searchService.searchProducts('hoodie');
      expect(results, isNotEmpty);
      // Verify all results contain 'hoodie' in name, description, or category
      for (final product in results) {
        final nameLower = product.name.toLowerCase();
        final descriptionLower = product.description?.toLowerCase() ?? '';
        final categoryLower = product.category?.toLowerCase() ?? '';
        final collectionLower = product.collectionId.toLowerCase();
        
        expect(
          nameLower.contains('hoodie') ||
          descriptionLower.contains('hoodie') ||
          categoryLower.contains('hoodie') ||
          collectionLower.contains('hoodie'),
          isTrue,
          reason: 'Product ${product.name} does not contain search term',
        );
      }
    });

    test('searchProducts is case-insensitive', () async {
      final lowerResults = await searchService.searchProducts('hoodie');
      final upperResults = await searchService.searchProducts('HOODIE');
      final mixedResults = await searchService.searchProducts('HoOdIe');
      
      expect(lowerResults.length, equals(upperResults.length));
      expect(lowerResults.length, equals(mixedResults.length));
    });

    test('searchProducts sorts by relevance', () async {
      final results = await searchService.searchProducts('essential');
      
      if (results.length > 1) {
        // Check if results are sorted (exact matches should come first)
        final firstProduct = results.first;
        final nameLower = firstProduct.name.toLowerCase();
        
        // First result should have high relevance (exact match or starts with)
        expect(
          nameLower == 'essential' || nameLower.startsWith('essential'),
          isTrue,
          reason: 'First result should be most relevant',
        );
      }
    });

    test('searchProducts handles special characters', () async {
      final results = await searchService.searchProducts('t-shirt');
      expect(results, isNotEmpty);
    });

    test('searchProducts finds products by category', () async {
      final results = await searchService.searchProducts('clothing');
      expect(results, isNotEmpty);
    });

    test('searchProducts handles multi-word queries', () async {
      final results = await searchService.searchProducts('essential hoodie');
      
      if (results.isNotEmpty) {
        // Verify results contain at least one of the words
        for (final product in results) {
          final nameLower = product.name.toLowerCase();
          final descriptionLower = product.description?.toLowerCase() ?? '';
          
          expect(
            nameLower.contains('essential') || 
            nameLower.contains('hoodie') ||
            descriptionLower.contains('essential') ||
            descriptionLower.contains('hoodie'),
            isTrue,
            reason: 'Product should contain at least one search term',
          );
        }
      }
    });

    test('searchProducts returns no results for nonsense query', () async {
      final results = await searchService.searchProducts('xyzabc123456');
      expect(results, isEmpty);
    });

    test('searchProducts handles partial matches', () async {
      final results = await searchService.searchProducts('shirt');
      expect(results, isNotEmpty);
      
      // Should find t-shirts, sweatshirts, etc.
      for (final product in results) {
        final nameLower = product.name.toLowerCase();
        final descriptionLower = product.description?.toLowerCase() ?? '';
        
        expect(
          nameLower.contains('shirt') || descriptionLower.contains('shirt'),
          isTrue,
          reason: 'Product should contain "shirt"',
        );
      }
    });
  });
}
