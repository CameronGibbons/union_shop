# Dynamic Product Page Requirements

## Overview
Implement a fully functional product detail page that displays individual product information with working color selector, size selector, quantity counter, image carousel, and dynamic pricing. This page must load products dynamically by ID from the ProductsService, not use hardcoded data.

## Reference
- Live Example: https://shop.upsu.net/products/signature-hoodie
- Target Viewport: iPhone 12 Pro (390px width)
- Framework: Flutter for Web

## Prerequisites
Before implementing this feature, you must have:
1. ✅ Product data model (`lib/models/product.dart`)
2. ✅ ProductsService with `getProductById()` method (`lib/services/products_service.dart`)
3. ✅ Dynamic routing configured in `main.dart`
4. ✅ ProductCard widget with navigation support

## Data Model Requirements

### Product Model
**File:** `lib/models/product.dart`

Must include the following properties:
```dart
class Product {
  final String id;                    // Unique identifier for routing
  final String name;                  // Product display name
  final double price;                 // Regular price
  final double? salePrice;            // Optional sale price
  final String imageUrl;              // Primary product image
  final String? category;             // Product category
  final List<String> sizes;           // Available size options (e.g., ['S', 'M', 'L', 'XL'])
  final List<String> colors;          // Available color options (e.g., ['Black', 'Navy', 'Grey'])
  final int stock;                    // Current stock quantity
  final bool isSale;                  // Sale status flag
  final String? description;          // Product description text
  final String collectionId;          // Parent collection reference
}
```

**Required computed properties:**
- `isInStock` - Returns `stock > 0`
- `isOnSale` - Returns `isSale && salePrice != null && salePrice < price`
- `displayPrice` - Returns `salePrice` if on sale, otherwise `price`

**Additional image support:**
While the current implementation uses a single `imageUrl`, the product page should support multiple images through an image carousel. For now, display the same image 4 times with thumbnail navigation.

## Service Layer Requirements

### ProductsService
**File:** `lib/services/products_service.dart`

Must implement singleton pattern and provide:

**Get Product by ID:**
```dart
Future<Product?> getProductById(String id) async {
  await Future.delayed(const Duration(milliseconds: 200));
  try {
    return _products.firstWhere((p) => p.id == id);
  } catch (e) {
    return null;
  }
}
```

**Behavior:**
- Returns `null` if product ID not found
- Simulates network delay (200ms)
- Searches through entire product catalog

### Mock Data Requirements
ProductsService must contain diverse products including:
- Products with multiple color options (minimum 2 colors)
- Products with multiple size options (minimum 3 sizes)
- Products with sale prices
- Products with varying stock levels
- Products from different collections
- Products with detailed descriptions

**Example Product:**
```dart
Product(
  id: 'signature-hoodie',
  name: 'Signature Hoodie',
  price: 32.99,
  salePrice: null,
  imageUrl: 'assets/images/signature_hoodie.png',
  category: 'Clothing',
  sizes: ['S', 'M', 'L', 'XL'],
  colors: ['Black', 'Navy', 'Purple'],
  stock: 50,
  isSale: false,
  collectionId: 'signature-range',
  description: 'Premium quality hoodie featuring the UPSU logo...',
)
```

## UI Implementation Requirements

### File Structure
**Main File:** `lib/screens/product_page.dart`

### Widget Architecture
```dart
class ProductPage extends StatefulWidget {
  final String productId;
  
  const ProductPage({
    super.key,
    required this.productId,
  });
  
  @override
  State<ProductPage> createState() => _ProductPageState();
}
```

### State Management
The page must maintain:
- `Product? _product` - Current product data loaded from service
- `bool _isLoading` - Loading state during async fetch
- `String? _errorMessage` - Error message if product not found
- `String? _selectedColor` - Currently selected color option
- `String? _selectedSize` - Currently selected size option
- `int _quantity` - Selected quantity (default: 1, minimum: 1)
- `int _selectedImageIndex` - Currently displayed image (default: 0)

### Lifecycle Methods

**initState:**
```dart
@override
void initState() {
  super.initState();
  _loadProduct();
}
```

**_loadProduct:**
```dart
Future<void> _loadProduct() async {
  setState(() {
    _isLoading = true;
    _errorMessage = null;
  });

  try {
    final product = await ProductsService().getProductById(widget.productId);
    
    if (product == null) {
      setState(() {
        _errorMessage = 'Product not found';
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _product = product;
      _selectedColor = product.colors.isNotEmpty ? product.colors.first : null;
      _selectedSize = product.sizes.isNotEmpty ? product.sizes.first : null;
      _isLoading = false;
    });
  } catch (e) {
    setState(() {
      _errorMessage = 'Failed to load product: $e';
      _isLoading = false;
    });
  }
}
```

### Page Layout Structure

The page must render components in this order:
1. Header (announcement bar + navigation)
2. Loading indicator OR error state OR product content
3. Product content (if loaded):
   - Image carousel
   - Product title and price
   - Color selector
   - Size selector
   - Quantity selector
   - Add to cart button
   - Product description
   - Additional information
   - Social sharing buttons
   - Back to collection button
4. Footer

### 1. Header Component
**Method:** `_buildHeader(BuildContext context)`

Must include:
- **Announcement Bar:**
  - Background: `Color(0xFF4d2963)` (UPSU purple)
  - Text: "BIG SALE! OUR ESSENTIAL RANGE HAS DROPPED IN PRICE! OVER 20% OFF! COME GRAB YOURS WHILE STOCK LASTS!"
  - White text, centered, 12px, bold, 0.5 letter spacing
  - Vertical padding: 12px

- **Navigation Bar:**
  - Logo: "The UNION" - tappable, navigates to home
  - Four icon buttons: search, account, cart, menu (placeholders)
  - Logo style: 22px, bold, UPSU purple, cursive font
  - Background: White
  - Horizontal padding: 16px, vertical: 12px

### 2. Image Carousel
**Method:** `_buildImageCarousel()`

**Main Image Display:**
- Full-width container
- Aspect ratio: 1:1 (square)
- Display image at `_selectedImageIndex`
- Tap to cycle through images (or use PageView for swipe support)
- Background: Light grey (`Colors.grey[200]`)

**Thumbnail Navigation:**
- Row of 4 thumbnail images below main image
- Each thumbnail: 60px × 60px
- 8px spacing between thumbnails
- Selected thumbnail: 2px black border
- Unselected: No border or grey border
- Tap thumbnail to update `_selectedImageIndex`
- Horizontal scrolling if more than 4 images

**Implementation:**
```dart
Widget _buildImageCarousel() {
  final images = List.generate(4, (_) => _product!.imageUrl);
  
  return Column(
    children: [
      // Main image
      GestureDetector(
        onTap: () {
          setState(() {
            _selectedImageIndex = (_selectedImageIndex + 1) % images.length;
          });
        },
        child: Container(
          width: double.infinity,
          height: 390,
          color: Colors.grey[200],
          child: Image.asset(
            images[_selectedImageIndex],
            fit: BoxFit.cover,
          ),
        ),
      ),
      const SizedBox(height: 12),
      // Thumbnails
      SizedBox(
        height: 60,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: images.length,
          itemBuilder: (context, index) {
            final isSelected = index == _selectedImageIndex;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedImageIndex = index;
                });
              },
              child: Container(
                width: 60,
                height: 60,
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isSelected ? Colors.black : Colors.grey.shade300,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Image.asset(
                  images[index],
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        ),
      ),
    ],
  );
}
```

### 3. Product Title and Price
**Method:** Part of main content

**Layout:**
- Product name: 24px, bold, black
- Price section:
  - If on sale:
    - Sale price: 28px, bold, red
    - Original price: 20px, grey, line-through, next to sale price
  - If not on sale:
    - Regular price: 28px, bold, UPSU purple
- "Tax included" message: 14px, grey, italic
- Padding: 16px all sides
- White background

**Example:**
```dart
Text(
  _product!.name,
  style: const TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  ),
),
const SizedBox(height: 8),
if (_product!.isOnSale) ...[
  Row(
    children: [
      Text(
        '£${_product!.salePrice!.toStringAsFixed(2)}',
        style: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.red,
        ),
      ),
      const SizedBox(width: 12),
      Text(
        '£${_product!.price.toStringAsFixed(2)}',
        style: const TextStyle(
          fontSize: 20,
          color: Colors.grey,
          decoration: TextDecoration.lineThrough,
        ),
      ),
    ],
  ),
] else ...[
  Text(
    '£${_product!.displayPrice.toStringAsFixed(2)}',
    style: const TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: Color(0xFF4d2963),
    ),
  ),
],
const SizedBox(height: 4),
const Text(
  'Tax included',
  style: TextStyle(
    fontSize: 14,
    color: Colors.grey,
    fontStyle: FontStyle.italic,
  ),
),
```

### 4. Color Selector
**Method:** `_buildColorSelector()`

**Requirements:**
- Only display if `_product!.colors.isNotEmpty`
- Label: "COLOR" (14px, bold, uppercase)
- Dropdown with all available colors
- Selected value: `_selectedColor`
- onChange: Updates `_selectedColor` in state
- Full-width dropdown
- 12px horizontal padding
- Grey border, 4px rounded corners

**Implementation:**
```dart
Widget _buildColorSelector() {
  if (_product!.colors.isEmpty) return const SizedBox();
  
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'COLOR',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
      const SizedBox(height: 8),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(4),
        ),
        child: DropdownButton<String>(
          value: _selectedColor,
          isExpanded: true,
          underline: const SizedBox(),
          items: _product!.colors.map((color) {
            return DropdownMenuItem(
              value: color,
              child: Text(color),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedColor = value;
            });
          },
        ),
      ),
    ],
  );
}
```

### 5. Size Selector
**Method:** `_buildSizeSelector()`

**Requirements:**
- Only display if `_product!.sizes.isNotEmpty`
- Label: "SIZE" (14px, bold, uppercase)
- Dropdown with all available sizes
- Selected value: `_selectedSize`
- onChange: Updates `_selectedSize` in state
- Same styling as color selector

**Implementation:**
```dart
Widget _buildSizeSelector() {
  if (_product!.sizes.isEmpty) return const SizedBox();
  
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'SIZE',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
      const SizedBox(height: 8),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(4),
        ),
        child: DropdownButton<String>(
          value: _selectedSize,
          isExpanded: true,
          underline: const SizedBox(),
          items: _product!.sizes.map((size) {
            return DropdownMenuItem(
              value: size,
              child: Text(size),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedSize = value;
            });
          },
        ),
      ),
    ],
  );
}
```

### 6. Quantity Selector
**Method:** `_buildQuantitySelector()`

**Requirements:**
- Label: "QUANTITY" (14px, bold, uppercase)
- Layout: Row with minus button, quantity display, plus button
- Minus button:
  - Icon: `Icons.remove`
  - Enabled when `_quantity > 1`
  - Disabled: Grey, no action
  - Enabled: Black icon, decrements quantity
- Quantity display:
  - Text: Current `_quantity` value
  - 18px, bold, centered
  - Min width: 50px
- Plus button:
  - Icon: `Icons.add`
  - Always enabled
  - Increments quantity
- Both buttons: 40px × 40px, grey border, rounded corners

**Implementation:**
```dart
Widget _buildQuantitySelector() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'QUANTITY',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
      const SizedBox(height: 8),
      Row(
        children: [
          // Minus button
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              border: Border.all(
                color: _quantity > 1 ? Colors.black : Colors.grey.shade300,
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            child: IconButton(
              icon: const Icon(Icons.remove, size: 20),
              onPressed: _quantity > 1
                  ? () {
                      setState(() {
                        _quantity--;
                      });
                    }
                  : null,
              padding: EdgeInsets.zero,
            ),
          ),
          const SizedBox(width: 16),
          // Quantity display
          SizedBox(
            width: 50,
            child: Text(
              '$_quantity',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Plus button
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(4),
            ),
            child: IconButton(
              icon: const Icon(Icons.add, size: 20),
              onPressed: () {
                setState(() {
                  _quantity++;
                });
              },
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    ],
  );
}
```

### 7. Add to Cart Button
**Method:** `_buildAddToCartButton()`

**Requirements:**
- Full-width button
- Text: "ADD TO CART" (16px, bold, white, letter spacing)
- Background: UPSU purple `Color(0xFF4d2963)`
- Height: 56px
- Rounded corners: 4px
- onPressed: Placeholder function (shows snackbar or does nothing)
- Disabled state if out of stock (grey background)

**Implementation:**
```dart
Widget _buildAddToCartButton() {
  final isInStock = _product!.isInStock;
  
  return SizedBox(
    width: double.infinity,
    height: 56,
    child: ElevatedButton(
      onPressed: isInStock
          ? () {
              // Placeholder - cart functionality not yet implemented
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Add to cart - Coming soon!'),
                  duration: Duration(seconds: 2),
                ),
              );
            }
          : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF4d2963),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        disabledBackgroundColor: Colors.grey,
      ),
      child: Text(
        isInStock ? 'ADD TO CART' : 'OUT OF STOCK',
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
    ),
  );
}
```

### 8. Product Description
**Method:** `_buildProductDescription()`

**Requirements:**
- Only display if `_product!.description != null`
- Section title: "DESCRIPTION" (16px, bold, uppercase)
- Description text: 15px, grey, line height 1.6
- Padding: 16px all sides
- Light grey background (`Colors.grey[50]`)

**Implementation:**
```dart
Widget _buildProductDescription() {
  if (_product!.description == null) return const SizedBox();
  
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    color: Colors.grey[50],
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'DESCRIPTION',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          _product!.description!,
          style: const TextStyle(
            fontSize: 15,
            color: Colors.grey,
            height: 1.6,
          ),
        ),
      ],
    ),
  );
}
```

### 9. Additional Information
**Method:** `_buildAdditionalInfo()`

**Requirements:**
- Display product metadata in card format
- Include:
  - SKU/Product ID
  - Category
  - Stock status
  - Collection reference
- Light background with borders
- 14px text, grey color

**Example:**
```dart
Widget _buildAdditionalInfo() {
  return Container(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'PRODUCT DETAILS',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),
        _buildInfoRow('Product ID', _product!.id),
        if (_product!.category != null)
          _buildInfoRow('Category', _product!.category!),
        _buildInfoRow(
          'Stock Status',
          _product!.isInStock ? 'In Stock' : 'Out of Stock',
        ),
        _buildInfoRow('Collection', _product!.collectionId),
      ],
    ),
  );
}

Widget _buildInfoRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      children: [
        Text(
          '$label: ',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ],
    ),
  );
}
```

### 10. Social Sharing Buttons
**Method:** `_buildSocialSharing()`

**Requirements:**
- Label: "SHARE" (14px, bold)
- Row of social icons: Facebook, Twitter, Pinterest
- Icons: 40px × 40px, circular, grey background
- Placeholder actions (do nothing for now)
- 16px spacing between icons

**Implementation:**
```dart
Widget _buildSocialSharing() {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'SHARE',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildSocialIcon(Icons.facebook, 'Facebook'),
            const SizedBox(width: 16),
            _buildSocialIcon(Icons.flutter_dash, 'Twitter'),
            const SizedBox(width: 16),
            _buildSocialIcon(Icons.pin, 'Pinterest'),
          ],
        ),
      ],
    ),
  );
}

Widget _buildSocialIcon(IconData icon, String label) {
  return GestureDetector(
    onTap: () {
      // Placeholder - social sharing not implemented
    },
    child: Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        size: 20,
        color: Colors.grey.shade700,
      ),
    ),
  );
}
```

### 11. Back to Collection Button
**Method:** `_buildBackButton()`

**Requirements:**
- Full-width outlined button
- Text: "← BACK TO COLLECTION" with left arrow
- Border: 2px black
- Text: Black, 14px, bold
- Height: 48px
- onPressed: Navigate back or to collection page
- Padding: 16px all sides

**Implementation:**
```dart
Widget _buildBackButton() {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton(
        onPressed: () {
          Navigator.pop(context);
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.black,
          side: const BorderSide(color: Colors.black, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.arrow_back, size: 18),
            SizedBox(width: 8),
            Text(
              'BACK TO COLLECTION',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
```

### 12. Loading State
**Method:** `_buildLoadingState()`

Must show:
- `CircularProgressIndicator` with UPSU purple color
- Centered in full-screen container
- Padding: 64px all sides
- White background

```dart
Widget _buildLoadingState() {
  return Container(
    color: Colors.white,
    padding: const EdgeInsets.all(64),
    child: const Center(
      child: CircularProgressIndicator(
        color: Color(0xFF4d2963),
      ),
    ),
  );
}
```

### 13. Error State
**Method:** `_buildErrorState()`

Must display:
- Error icon (64px, red)
- Error message text (18px, red, centered)
- "Try Again" button (UPSU purple)
- "Go Home" button (outlined)
- All centered vertically
- 24px spacing between elements

```dart
Widget _buildErrorState() {
  return Container(
    color: Colors.white,
    padding: const EdgeInsets.all(32),
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 24),
          Text(
            _errorMessage ?? 'Something went wrong',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.red,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: _loadProduct,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4d2963),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 16,
              ),
            ),
            child: const Text('Try Again'),
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF4d2963),
              side: const BorderSide(color: Color(0xFF4d2963)),
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 16,
              ),
            ),
            child: const Text('Go Home'),
          ),
        ],
      ),
    ),
  );
}
```

### Main Build Method Structure

```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    body: SingleChildScrollView(
      child: Column(
        children: [
          _buildHeader(context),
          if (_isLoading)
            _buildLoadingState()
          else if (_errorMessage != null)
            _buildErrorState()
          else if (_product != null) ...[
            _buildImageCarousel(),
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitleAndPrice(),
                  const SizedBox(height: 24),
                  _buildColorSelector(),
                  const SizedBox(height: 16),
                  _buildSizeSelector(),
                  const SizedBox(height: 16),
                  _buildQuantitySelector(),
                  const SizedBox(height: 24),
                  _buildAddToCartButton(),
                ],
              ),
            ),
            _buildProductDescription(),
            _buildAdditionalInfo(),
            _buildSocialSharing(),
            _buildBackButton(),
          ],
          const FooterWidget(),
        ],
      ),
    ),
  );
}
```

## Routing Configuration

### Dynamic Product Routes
**File:** `lib/main.dart`

Add dynamic route handling:

```dart
class UnionShopApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Union Shop',
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        // Handle dynamic product routes
        if (settings.name != null && settings.name!.startsWith('/product/')) {
          final productId = settings.name!.substring('/product/'.length);
          return MaterialPageRoute(
            builder: (context) => ProductPage(productId: productId),
            settings: settings,
          );
        }
        
        // Handle dynamic collection routes
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
        '/about': (context) => const AboutPage(),
        '/collections': (context) => const CollectionsPage(),
        '/sale': (context) => const SaleCollectionPage(),
      },
    );
  }
}
```

### Navigation from Product Cards
Update ProductCard widget:

```dart
class ProductCard extends StatelessWidget {
  final String? productId;
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isSoldOut
          ? null
          : () {
              if (productId != null) {
                Navigator.pushNamed(context, '/product/$productId');
              }
            },
      child: // ... product card UI
    );
  }
}
```

## Testing Requirements

### Test File
**Location:** `test/product_test.dart`

### Required Test Cases

1. **Page Loading**
   - ✅ Should display loading indicator initially
   - ✅ Should load product data asynchronously
   - ✅ Should display product name after loading
   - ✅ Should display product price
   - ✅ Should handle product not found error
   - ✅ Should display error message for invalid product ID

2. **Image Carousel**
   - ✅ Should display main product image
   - ✅ Should display 4 thumbnail images
   - ✅ Should highlight selected thumbnail
   - ✅ Should change main image when thumbnail tapped
   - ✅ Should cycle images when main image tapped

3. **Price Display**
   - ✅ Should display regular price for non-sale items
   - ✅ Should display sale price in red for sale items
   - ✅ Should show original price with strikethrough for sale items
   - ✅ Should display "Tax included" message

4. **Color Selector**
   - ✅ Should display color dropdown when colors available
   - ✅ Should not display color selector when no colors
   - ✅ Should select first color by default
   - ✅ Should update selected color when changed

5. **Size Selector**
   - ✅ Should display size dropdown when sizes available
   - ✅ Should not display size selector when no sizes
   - ✅ Should select first size by default
   - ✅ Should update selected size when changed

6. **Quantity Selector**
   - ✅ Should display quantity controls
   - ✅ Should default to quantity of 1
   - ✅ Should increment quantity when plus tapped
   - ✅ Should decrement quantity when minus tapped
   - ✅ Should not decrement quantity below 1
   - ✅ Should disable minus button when quantity is 1

7. **Add to Cart**
   - ✅ Should display "ADD TO CART" button
   - ✅ Should display "OUT OF STOCK" for unavailable products
   - ✅ Should disable button when out of stock
   - ✅ Should show placeholder action when tapped (in stock)

8. **Product Information**
   - ✅ Should display product description
   - ✅ Should display product details section
   - ✅ Should show stock status
   - ✅ Should show category if available

9. **Navigation**
   - ✅ Should display back button
   - ✅ Should navigate back when back button tapped
   - ✅ Should display social sharing buttons
   - ✅ Should navigate to home when logo tapped

10. **Footer**
    - ✅ Should display footer component

### Test Setup
```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/screens/product_page.dart';

void main() {
  group('Product Page Tests', () {
    testWidgets('should display loading indicator initially', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ProductPage(productId: 'signature-hoodie'),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should load product data', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ProductPage(productId: 'signature-hoodie'),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Signature Hoodie'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });
    
    // ... more tests
  });
}
```

## Visual Design Requirements

### Color Palette
- Primary Purple: `Color(0xFF4d2963)`
- Sale Red: `Colors.red`
- White: `Colors.white`
- Black: `Colors.black`
- Grey (borders): `Colors.grey.shade300`
- Grey (text): `Colors.grey`
- Light Grey (backgrounds): `Colors.grey[50]` or `Colors.grey[200]`

### Typography
- Product title: 24px, bold
- Price: 28px, bold (purple or red for sale)
- Original price: 20px, grey, line-through
- Section labels: 14-16px, bold, uppercase, 0.5 letter spacing
- Body text: 15px, grey
- Button text: 16px, bold, 1.0 letter spacing
- Small text: 12-14px, grey, italic

### Spacing
- Container padding: 16px
- Section spacing: 24px
- Element spacing: 8-16px
- Button height: 48-56px

### Borders
- Dropdown/Input borders: 1px solid grey[300]
- Button borders: 2px solid (for outlined buttons)
- Border radius: 4px (consistent throughout)

### Interactive Elements
- Dropdowns: Full-width, no underline, grey border
- Buttons: Hover states (web), ripple effects
- Disabled states: Grey color, no interaction
- Image thumbnails: Bold border when selected

## Edge Cases and Validation

### Handle Missing Data
- ✅ No colors → Hide color selector
- ✅ No sizes → Hide size selector
- ✅ No description → Hide description section
- ✅ Out of stock → Disable add to cart, show "OUT OF STOCK"
- ✅ Invalid product ID → Show error state with retry

### Input Validation
- ✅ Quantity minimum: 1 (cannot go below)
- ✅ Quantity maximum: None (unlimited for now)
- ✅ Product ID required: Error if missing

### Loading States
- ✅ Initial load: Show spinner
- ✅ Error: Show error message with retry
- ✅ Success: Hide spinner, show content

### Navigation
- ✅ Back button: Navigate to previous page
- ✅ Logo: Navigate to home
- ✅ Product not found: Show error with "Go Home" option

## Validation Checklist

Before considering this feature complete:

- [ ] ProductPage created as StatefulWidget
- [ ] Page loads product data by ID asynchronously
- [ ] Loading state displays during async fetch
- [ ] Error state displays for invalid product ID
- [ ] Image carousel with 4 thumbnails implemented
- [ ] Thumbnail selection updates main image
- [ ] Product title and price display correctly
- [ ] Sale prices shown in red with strikethrough original
- [ ] Color dropdown populates from product.colors
- [ ] Size dropdown populates from product.sizes
- [ ] Quantity counter increments and decrements
- [ ] Quantity cannot go below 1
- [ ] Minus button disabled at quantity 1
- [ ] Add to cart button displays
- [ ] Button disabled when out of stock
- [ ] Product description displays
- [ ] Additional info section displays
- [ ] Social sharing buttons render
- [ ] Back button navigates correctly
- [ ] Dynamic routing configured in main.dart
- [ ] ProductCard navigates to product page
- [ ] All tests passing
- [ ] `flutter analyze` shows no issues
- [ ] Code formatted with `dart format .`

## Commit Strategy

Make separate commits for each major component:

1. **Product Service Method:**
   ```
   Add getProductById method to ProductsService
   ```

2. **Product Page Widget:**
   ```
   Add ProductPage with async product loading
   ```

3. **Image Carousel:**
   ```
   Add image carousel with thumbnail navigation
   ```

4. **Product Options:**
   ```
   Add color and size selector dropdowns
   ```

5. **Quantity Controls:**
   ```
   Add quantity counter with increment/decrement
   ```

6. **Add to Cart:**
   ```
   Add to cart button with placeholder action
   ```

7. **Product Details:**
   ```
   Add product description and details sections
   ```

8. **Navigation:**
   ```
   Add dynamic product routing in main.dart
   ```

9. **Tests:**
   ```
   Add comprehensive tests for product page
   ```

## Success Criteria

The feature is complete when:
1. ✅ User can navigate to any product page by ID
2. ✅ Product page loads data asynchronously from service
3. ✅ User can select color from dropdown
4. ✅ User can select size from dropdown
5. ✅ User can adjust quantity with +/- buttons
6. ✅ Image carousel displays with thumbnail navigation
7. ✅ Sale prices display correctly with strikethrough
8. ✅ Add to cart button works (shows placeholder message)
9. ✅ Out of stock products disable cart button
10. ✅ All tests pass
11. ✅ No analysis errors or warnings
12. ✅ Code is properly formatted

## Performance Considerations

- Use `SingleChildScrollView` for page scroll
- Async product loading with 200ms simulated delay
- Efficient state updates (only rebuild affected widgets)
- Image caching for carousel performance
- Dropdown optimization (don't rebuild entire page on selection)

## Accessibility Notes

- All interactive elements tappable with sufficient size (48×48 minimum)
- Disabled buttons visually distinct (grey background)
- Loading state obvious (centered spinner)
- Error messages clear and actionable
- Color contrast meets WCAG standards
- Labels uppercase with letter spacing for clarity

## Future Enhancements (Not Required for Initial Implementation)

- Multiple product images (real carousel)
- Image zoom/lightbox
- Size guide modal
- Stock level indicator
- Product reviews section
- Related products carousel
- Wishlist/favorite functionality
- Color swatches instead of dropdown
- Size chart integration
- Shipping information
- Return policy
- Real add to cart with cart state management
- Product availability by size/color combination
- Real-time stock updates
- Product recommendations
- 360° product view
- Video demonstrations

---

**Last Updated:** 1 December 2025  
**Status:** ✅ Implemented and Tested  
**Total Tests:** 96 passing (10 product page tests)
