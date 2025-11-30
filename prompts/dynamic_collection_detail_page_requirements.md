# Dynamic Collection Detail Page Requirements

## Overview
Implement a fully functional collection detail page that displays products from a specific collection with working filtering, sorting, and pagination controls. This page must be populated from data models and services, not hardcoded data.

## Reference
- Live Example: https://shop.upsu.net/collections/autumn-favourites
- Target Viewport: iPhone 12 Pro (390px width)
- Framework: Flutter for Web

## Prerequisites
Before implementing this feature, you must have:
1. ✅ Product data model (`lib/models/product.dart`)
2. ✅ Collection data model (`lib/models/collection.dart`)
3. ✅ ProductsService (`lib/services/products_service.dart`)
4. ✅ CollectionsService (`lib/services/collections_service.dart`)
5. ✅ Collections listing page with navigation

## Data Model Requirements

### Product Model
**File:** `lib/models/product.dart`

Must include the following properties:
```dart
class Product {
  final String id;                    // Unique identifier
  final String name;                  // Product name
  final double price;                 // Regular price
  final double? salePrice;            // Optional sale price
  final String imageUrl;              // Asset path or URL
  final String? category;             // Product category (for filtering)
  final List<String> sizes;           // Available sizes
  final List<String> colors;          // Available colors
  final int stock;                    // Stock quantity
  final bool isSale;                  // Sale flag
  final String? description;          // Product description
  final String collectionId;          // Parent collection ID
}
```

**Required computed properties:**
- `isInStock` - Returns true if stock > 0
- `isOnSale` - Returns true if isSale && salePrice != null && salePrice < price
- `displayPrice` - Returns salePrice if on sale, otherwise price

**Required methods:**
- `fromJson(Map<String, dynamic> json)` - Deserialize from JSON
- `toJson()` - Serialize to JSON

### Collection Model
**File:** `lib/models/collection.dart`

Must include:
```dart
class Collection {
  final String id;
  final String name;
  final String imageUrl;
  final String? description;
  final int productCount;
  final bool isFeatured;
  final List<String> tags;
}
```

## Service Layer Requirements

### ProductsService
**File:** `lib/services/products_service.dart`

Must implement singleton pattern and provide:

1. **Get Products by Collection**
   ```dart
   Future<List<Product>> getProductsByCollection(String collectionId)
   ```
   - Returns all products for a specific collection
   - Simulates async network delay (200-300ms)

2. **Filter Products**
   ```dart
   Future<List<Product>> filterProducts({
     String? collectionId,
     String? category,
     bool? onSale,
     bool? inStock,
     double? minPrice,
     double? maxPrice,
   })
   ```
   - Supports multiple filter criteria
   - All parameters are optional

3. **Sort Products**
   ```dart
   List<Product> sortProducts(List<Product> products, String sortBy)
   ```
   - Sort options:
     - `'featured'` - Default order
     - `'price-asc'` - Price low to high
     - `'price-desc'` - Price high to low
     - `'name-asc'` - Alphabetically A-Z
     - `'name-desc'` - Alphabetically Z-A

4. **Pagination**
   ```dart
   List<Product> paginateProducts(List<Product> products, int page, int itemsPerPage)
   int getTotalPages(int totalItems, int itemsPerPage)
   ```

5. **Get Categories**
   ```dart
   Set<String> getCategories(List<Product> products)
   ```
   - Returns unique categories from product list

### Mock Data Requirements
ProductsService must contain at least 10 products for the 'autumn-favourites' collection including:
- Mix of clothing, accessories, merchandise, and stationery
- At least 2 products with sale prices
- At least 1 out-of-stock product (stock: 0)
- Variety of price points (£1.00 to £30.00)
- Multiple categories for filter testing

## UI Implementation Requirements

### File Structure
**Main File:** `lib/screens/collection_detail_page.dart`

### Widget Architecture
```dart
class CollectionDetailPage extends StatefulWidget {
  final String collectionId;
  
  const CollectionDetailPage({
    super.key,
    required this.collectionId,
  });
}
```

### State Management
The page must maintain:
- `Collection? _collection` - Current collection data
- `List<Product> _allProducts` - All products in collection
- `List<Product> _displayedProducts` - Filtered, sorted, paginated products
- `bool _isLoading` - Loading state
- `String _errorMessage` - Error message if any
- `String _selectedCategory` - Current filter selection (default: 'All products')
- `String _selectedSort` - Current sort selection (default: 'Featured')
- `int _currentPage` - Current page number (0-indexed)
- `const int _itemsPerPage = 10` - Products per page

### Page Layout Structure

The page must render components in this order:
1. Header (announcement bar + navigation)
2. Loading indicator OR error state OR content
3. Collection header (if loaded)
4. Filter and sort dropdowns (if loaded)
5. Product count (if loaded)
6. Product grid (if loaded)
7. Pagination controls (if loaded)
8. Footer

### 1. Header Component
**Method:** `_buildHeader(BuildContext context)`

Must include:
- **Announcement Bar:**
  - Background: `Color(0xFF4d2963)` (UPSU purple)
  - Text: "BIG SALE! OUR ESSENTIAL RANGE HAS DROPPED IN PRICE! OVER 20% OFF!"
  - White text, centered, 12px, bold, 0.5 letter spacing
  - Vertical padding: 12px

- **Navigation Bar:**
  - Logo: "upsu-store" - tappable, navigates to home
  - Three icon buttons (search, account, cart) - placeholders
  - Logo style: 22px, bold, UPSU purple
  - Background: White
  - Horizontal padding: 16px, vertical: 12px

### 2. Collection Header
**Method:** `_buildCollectionHeader()`

Must display:
- Collection name: 32px, bold, black, centered
- Collection description (if exists): 16px, grey, centered
- White background
- Padding: 16px horizontal, 32px vertical

### 3. Filter and Sort Section
**Method:** `_buildFilterAndSort()`

Layout: Two dropdowns side by side

**Filter Dropdown:**
- Label: "FILTER BY" (12px, bold, 0.5 letter spacing)
- Options:
  - "All products" (default)
  - Dynamic categories from products (Clothing, Accessories, etc.)
- Border: 1px solid grey[300]
- Rounded corners: 4px
- Padding: 12px horizontal

**Sort Dropdown:**
- Label: "SORT BY" (12px, bold, 0.5 letter spacing)
- Options:
  - "Featured" (default)
  - "Price: Low to High"
  - "Price: High to Low"
  - "Alphabetically, A-Z"
  - "Alphabetically, Z-A"
- Same styling as filter dropdown

**Behavior:**
- When filter changes: Reset to page 0, update displayed products
- When sort changes: Update displayed products (maintain current page)
- Both dropdowns must be full-width on mobile

**Container:**
- White background
- Padding: 16px all sides
- Row layout with 16px gap

### 4. Product Count
**Method:** `_buildProductCount()`

Must display:
- Format: "X products" (where X is filtered count)
- Style: 14px, italic, grey
- Padding: 16px horizontal, 8px vertical
- White background

### 5. Product Grid
**Method:** `_buildProductGrid()`

**Grid Specifications:**
- `GridView.builder` with `shrinkWrap: true`
- `physics: NeverScrollableScrollPhysics()`
- 2 columns (`crossAxisCount: 2`)
- 12px spacing (both cross and main)
- Aspect ratio: 0.7 (taller for product cards)

**Product Card Integration:**
Use existing `ProductCard` widget:
```dart
ProductCard(
  title: product.name,
  price: '£X.XX', // Formatted display price
  imageUrl: product.imageUrl,
  originalPrice: product.isOnSale ? '£X.XX' : null,
)
```

**Empty State:**
If no products after filtering:
- Display: "No products found"
- Style: 16px, grey, centered
- Padding: 32px all sides

### 6. Pagination Controls
**Method:** `_buildPagination()`

**CRITICAL:** Pagination must ALWAYS be visible, even with only one page.

**Layout:**
- Display: "Page X of Y" (16px, bold)
- Two buttons: PREVIOUS and NEXT PAGE
- Center aligned, 16px gap between buttons

**Previous Button:**
- Text: "PREVIOUS" with left arrow icon
- Enabled when: `_currentPage > 0`
- Disabled: Grey border, null onPressed
- Enabled: Black border, calls `_onPageChanged(_currentPage - 1)`
- Padding: 24px horizontal, 12px vertical

**Next Button:**
- Text: "NEXT PAGE" with right arrow icon
- Enabled when: `_currentPage < totalPages - 1`
- Disabled: Grey border, null onPressed
- Enabled: Black border, calls `_onPageChanged(_currentPage + 1)`
- Padding: 24px horizontal, 12px vertical

**Container:**
- White background
- Padding: 16px horizontal, 32px vertical

### 7. Loading State
**Method:** `_buildLoadingState()`

Must show:
- `CircularProgressIndicator` with UPSU purple color
- Centered in container
- Padding: 64px all sides
- White background

### 8. Error State
**Method:** `_buildErrorState()`

Must display:
- Error icon (48px, red)
- Error message text (red, centered)
- "Retry" button (UPSU purple, white text)
- All centered vertically
- 16px spacing between elements
- Padding: 32px all sides

## State Update Logic

### `_loadCollectionData()`
```dart
Future<void> _loadCollectionData() async {
  setState(() {
    _isLoading = true;
    _errorMessage = '';
  });
  
  try {
    final collection = await _collectionsService.getCollectionById(collectionId);
    final products = await _productsService.getProductsByCollection(collectionId);
    
    setState(() {
      _collection = collection;
      _allProducts = products;
      _updateDisplayedProducts();
      _isLoading = false;
    });
  } catch (e) {
    setState(() {
      _errorMessage = 'Failed to load collection: $e';
      _isLoading = false;
    });
  }
}
```

### `_updateDisplayedProducts()`
```dart
void _updateDisplayedProducts() {
  // 1. Start with all products
  var filtered = List<Product>.from(_allProducts);
  
  // 2. Apply category filter
  if (_selectedCategory != 'All products') {
    filtered = filtered.where((p) => p.category == _selectedCategory).toList();
  }
  
  // 3. Apply sorting
  filtered = _productsService.sortProducts(filtered, _getSortValue());
  
  // 4. Apply pagination
  _displayedProducts = _productsService.paginateProducts(
    filtered, 
    _currentPage, 
    _itemsPerPage
  );
}
```

### `_onCategoryChanged(String? value)`
```dart
void _onCategoryChanged(String? value) {
  if (value != null) {
    setState(() {
      _selectedCategory = value;
      _currentPage = 0;  // Reset to first page
      _updateDisplayedProducts();
    });
  }
}
```

### `_onSortChanged(String? value)`
```dart
void _onSortChanged(String? value) {
  if (value != null) {
    setState(() {
      _selectedSort = value;
      _updateDisplayedProducts();
    });
  }
}
```

### `_onPageChanged(int page)`
```dart
void _onPageChanged(int page) {
  setState(() {
    _currentPage = page;
    _updateDisplayedProducts();
  });
}
```

## Routing Configuration

### Update `main.dart`
Add dynamic route handling:

```dart
import 'package:union_shop/screens/collection_detail_page.dart';

class UnionShopApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // ... existing config ...
      onGenerateRoute: (settings) {
        if (settings.name != null && settings.name!.startsWith('/collection/')) {
          final collectionId = settings.name!.substring('/collection/'.length);
          return MaterialPageRoute(
            builder: (context) => CollectionDetailPage(collectionId: collectionId),
            settings: settings,
          );
        }
        return null;
      },
      routes: {
        // ... existing routes ...
      },
    );
  }
}
```

### Navigation from Collections Page
Update collection card tap handler:

```dart
GestureDetector(
  onTap: () {
    Navigator.pushNamed(context, '/collection/${collection.id}');
  },
  child: // ... collection card widget
)
```

## Testing Requirements

### Test File
**Location:** `test/screens/collection_detail_test.dart`

### Required Test Cases

1. **Basic Rendering**
   - ✅ Should display page title (upsu-store logo)
   - ✅ Should display loading indicator initially
   - ✅ Should display collection name after loading
   - ✅ Should display collection description
   - ✅ Should display announcement bar

2. **Filter and Sort**
   - ✅ Should display filter dropdown with "FILTER BY" label
   - ✅ Should display sort dropdown with "SORT BY" label
   - ✅ Should filter products by category
   - ✅ Should sort products by price (low to high)
   - ✅ Should sort products by price (high to low)
   - ✅ Should sort products alphabetically (A-Z)
   - ✅ Should sort products alphabetically (Z-A)
   - ✅ Should reset to page 1 when filter changes

3. **Product Display**
   - ✅ Should display product count
   - ✅ Should display product grid
   - ✅ Should display products from collection
   - ✅ Should show sale price for discounted items
   - ✅ Should show sold out status for out of stock items

4. **Pagination**
   - ✅ Should always display pagination controls
   - ✅ Should show current page and total pages
   - ✅ Should disable Previous button on first page
   - ✅ Should disable Next button on last page
   - ✅ Should navigate to next page when Next is clicked
   - ✅ Should navigate to previous page when Previous is clicked

5. **Navigation**
   - ✅ Should navigate to home when logo is clicked
   - ✅ Should display header icons (search, account, cart)

6. **Error Handling**
   - ✅ Should handle empty collection gracefully
   - ✅ Should display error state with retry button

7. **Footer**
   - ✅ Should display footer component

### Test Setup
All tests must:
- Use `pumpAndSettle()` after `pumpWidget()` to complete async operations
- Create test widget with MaterialApp wrapper
- Test against 'autumn-favourites' collection (known to have products)

### Test Helper
```dart
Widget createTestWidget() {
  return const MaterialApp(
    home: CollectionDetailPage(collectionId: 'autumn-favourites'),
  );
}
```

## Visual Design Requirements

### Color Palette
- Primary Purple: `Color(0xFF4d2963)`
- White: `Colors.white`
- Black: `Colors.black`
- Grey (borders): `Colors.grey.shade300`
- Grey (text): `Colors.grey`
- Red (sale/error): `Colors.red`

### Typography
- Page title: 32px, bold
- Section headers: 20px, bold
- Labels: 12px, bold, 0.5 letter spacing
- Product count: 14px, italic
- Pagination: 16px, bold
- Body text: 14-16px

### Spacing
- Container padding: 16px horizontal
- Section vertical spacing: 32px
- Element spacing: 8-16px
- Grid spacing: 12px

### Borders
- Dropdown borders: 1px solid grey[300]
- Border radius: 4px

## Validation Checklist

Before considering this feature complete:

- [ ] Product model created with all required fields
- [ ] ProductsService implements all required methods
- [ ] Collection detail page created as StatefulWidget
- [ ] Page loads collection data on init
- [ ] Filter dropdown populated with dynamic categories
- [ ] Sort dropdown has all 5 sort options
- [ ] Filtering updates displayed products
- [ ] Sorting updates displayed products
- [ ] Pagination always visible
- [ ] Pagination buttons enable/disable correctly
- [ ] Product grid displays 2 columns
- [ ] Product cards show sale prices correctly
- [ ] Loading state displays during data fetch
- [ ] Error state displays on failure
- [ ] Navigation from collections page works
- [ ] Dynamic routing configured in main.dart
- [ ] All 74 tests passing
- [ ] `flutter analyze` shows no issues
- [ ] Code formatted with `dart format .`

## Commit Strategy

Make separate commits for each major component:

1. **Product Model:**
   ```
   Add Product data model with properties and serialization
   ```

2. **Products Service:**
   ```
   Add ProductsService with filtering, sorting, and pagination
   ```

3. **Collection Detail Page:**
   ```
   Add dynamic collection detail page with filter, sort, and pagination
   ```

4. **Navigation:**
   ```
   Add navigation from collections to collection detail page
   ```

5. **Routing:**
   ```
   Add dynamic route handling for collection detail pages
   ```

6. **Tests:**
   ```
   Add comprehensive tests for collection detail page
   ```

## Success Criteria

The feature is complete when:
1. ✅ User can navigate from collections page to any collection detail page
2. ✅ Collection detail page loads products asynchronously
3. ✅ User can filter products by category
4. ✅ User can sort products by 5 different criteria
5. ✅ User can paginate through products (10 per page)
6. ✅ Pagination controls always visible
7. ✅ Sale prices display correctly
8. ✅ All tests pass
9. ✅ No analysis errors or warnings
10. ✅ Code is properly formatted

## Performance Considerations

- Async delays should simulate realistic network latency (200-300ms)
- Use `shrinkWrap: true` on GridView to prevent layout issues
- Use `NeverScrollableScrollPhysics()` on GridView (page handles scrolling)
- Reset to page 0 when filters change to avoid empty pages
- Maintain current page when only sort changes

## Accessibility Notes

- All interactive elements must be tappable
- Disabled buttons should be visually distinct (grey border)
- Loading state should be obvious (spinner)
- Error messages should be clear and actionable
- All text should have sufficient contrast

## Future Enhancements (Not Required for Initial Implementation)

- Search functionality within collection
- Price range slider filter
- Size/color filters
- Quick view product modal
- Add to cart from collection page
- Collection sharing
- URL state management (preserve filters in URL)
- Infinite scroll instead of pagination
- Product comparison
- Sort by popularity/rating

---

**Last Updated:** 30 November 2025  
**Status:** ✅ Implemented and Tested  
**Total Tests:** 74 passing
