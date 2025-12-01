# Shopping Cart System Requirements

## Overview
Implement a complete shopping cart system with add to cart functionality, cart page with item management, quantity editing, price calculations, and basic checkout flow. Cart should persist across sessions and require authentication for checkout.

## Reference
- Live Example: https://shop.upsu.net/cart
- Target Viewport: iPhone 12 Pro (390px width) + Desktop responsive
- Framework: Flutter for Web
- State Management: Provider or similar

## Feature Requirements

### 1. Cart Data Model
**File:** `lib/models/cart_item.dart`

```dart
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
  
  Map<String, dynamic> toJson();
  factory CartItem.fromJson(Map<String, dynamic> json);
}
```

### 2. Cart Service
**File:** `lib/services/cart_service.dart`

Must implement singleton pattern with:

**Methods:**
- `Future<void> addToCart(CartItem item)` - Add item or increment quantity if exists
- `Future<void> removeFromCart(String productId, {String? color, String? size})` - Remove item
- `Future<void> updateQuantity(String productId, int quantity, {String? color, String? size})` - Update item quantity
- `Future<void> clearCart()` - Empty cart
- `List<CartItem> getCartItems()` - Get all cart items
- `int getItemCount()` - Total number of items (sum of quantities)
- `double getSubtotal()` - Sum of all item totals
- `Stream<int> get itemCountStream` - Stream for cart badge updates
- `Future<void> loadCart()` - Load persisted cart from storage
- `Future<void> saveCart()` - Persist cart to local storage

**Storage:**
- Use `shared_preferences` package for persistence
- Store cart as JSON array
- Load on app startup

### 3. Cart Page
**File:** `lib/screens/cart_page.dart`

**Layout Structure (Mobile):**
1. Header: "Your cart"
2. "Continue shopping" link
3. Cart items table/list:
   - Product column (image + name + variant details)
   - Price column
   - Quantity column (with +/- buttons or input)
   - Total column
   - Remove link per item
4. "Add a note to your order" textarea
5. Subtotal display
6. "Tax included and shipping calculated at checkout" text
7. UPDATE button (updates quantities)
8. CHECK OUT button (purple, prominent)
9. Alternative payment buttons (Shop Pay, Google Pay)

**Layout Structure (Desktop):**
- Same as mobile but wider layout
- Table format with columns: Product | Price | Quantity | Total
- Right-aligned checkout section

**Empty Cart State:**
- "Your cart is currently empty." message
- "CONTINUE SHOPPING" button linking to collections

**Authentication Check:**
- If not logged in: Show message "You need to log in to checkout"
- Show "Sign In" button linking to login page
- Disable checkout buttons until logged in

**Functionality:**
- Display all cart items
- Update quantity with +/- buttons
- Remove individual items with "Remove" link
- Calculate and display subtotal
- UPDATE button saves quantity changes
- CHECK OUT button proceeds to checkout (simulated)
- Shop Pay / Google Pay buttons show "Coming soon" message

### 4. Add to Cart Flow

**Product Page Integration:**
Update `lib/screens/product_page.dart`:

```dart
// Add to cart button
ElevatedButton(
  onPressed: () async {
    final cartService = CartService();
    await cartService.addToCart(CartItem(
      productId: widget.productId,
      productName: productName,
      color: selectedColor,
      size: selectedSize,
      price: productPrice,
      quantity: quantity,
      imageUrl: productImage,
    ));
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Added to cart')),
    );
  },
  child: Text('ADD TO CART'),
)
```

**Cart Badge:**
Update navbar to show cart item count:

```dart
Stack(
  children: [
    IconButton(
      icon: Icon(Icons.shopping_bag_outlined),
      onPressed: () => Navigator.pushNamed(context, '/cart'),
    ),
    if (itemCount > 0)
      Positioned(
        right: 0,
        top: 0,
        child: Container(
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Color(0xFF4d2963),
            shape: BoxShape.circle,
          ),
          child: Text(
            '$itemCount',
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
  ],
)
```

### 5. Checkout Flow (Simulated)

**File:** `lib/screens/checkout_page.dart` (basic implementation)

When CHECK OUT is clicked:
1. Check if user is authenticated
2. If not authenticated: Show login prompt
3. If authenticated: Navigate to checkout page
4. Checkout page shows:
   - Order summary
   - Cart items
   - Total amount
   - "PLACE ORDER" button
5. When PLACE ORDER clicked:
   - Show success dialog: "Order placed successfully!"
   - Clear cart
   - Navigate to home or orders page

**No Real Payments:**
- No actual payment processing
- No credit card fields
- Just simulate order placement
- Could show fake order confirmation number

### 6. Cart Persistence

Use `shared_preferences` to save cart:

```dart
Future<void> saveCart() async {
  final prefs = await SharedPreferences.getInstance();
  final cartJson = _cartItems.map((item) => item.toJson()).toList();
  await prefs.setString('cart', jsonEncode(cartJson));
}

Future<void> loadCart() async {
  final prefs = await SharedPreferences.getInstance();
  final cartString = prefs.getString('cart');
  if (cartString != null) {
    final cartJson = jsonDecode(cartString) as List;
    _cartItems = cartJson.map((item) => CartItem.fromJson(item)).toList();
    notifyListeners();
  }
}
```

Load cart on app startup in `main.dart`:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Supabase
  await Supabase.initialize(...);
  
  // Load cart
  await CartService().loadCart();
  
  runApp(const UnionShopApp());
}
```

### 7. Variant Handling

Cart items with same product but different variants (color/size) are separate items:

```dart
// Check if item exists in cart
bool _itemExists(CartItem newItem) {
  return _cartItems.any((item) =>
    item.productId == newItem.productId &&
    item.color == newItem.color &&
    item.size == newItem.size
  );
}

// Find existing item
CartItem? _findItem(String productId, {String? color, String? size}) {
  return _cartItems.firstWhereOrNull((item) =>
    item.productId == productId &&
    item.color == color &&
    item.size == size
  );
}
```

## Visual Design

### Cart Page Styling

**Colors:**
- Background: `#F5F5F3` (light grey)
- Card background: White
- Primary button: `#4d2963` (purple)
- Secondary button: White with border
- Text: Black/Grey shades

**Typography:**
- Page title: 32px bold
- Product name: 16px
- Variant details: 14px grey italic
- Prices: 16px medium
- Subtotal: 20px bold

**Layout:**
- Mobile: Single column, full width
- Desktop: Centered max-width 1200px
- Padding: 16px mobile, 32px desktop
- Item spacing: 16px between items
- Dividers between cart items

**Buttons:**
- UPDATE: Outlined, secondary style
- CHECK OUT: Filled, purple background
- Remove: Text link, red color on hover
- Continue Shopping: Text link with arrow

**Cart Item Row:**
```
[Product Image] Product Name              £14.99    [- 1 +]    £14.99
                Color: Baby Pink                                Remove
                Size: L
```

### Empty Cart State

```
        Your cart

  Your cart is currently empty.

    [CONTINUE SHOPPING →]
```

### Cart with Items

```
        Your cart
      Continue shopping

Product              Price    Quantity    Total
────────────────────────────────────────────────
[img] Product Name   £14.99   [- 1 +]    £14.99
      Color: Pink                         Remove
      Size: L

Add a note to your order
[________________________________]

                    Subtotal      £14.99
    Tax included and shipping calculated at checkout

              [UPDATE]  [CHECK OUT]

           [Shop Pay]  [Google Pay]
```

## Dependencies

Add to `pubspec.yaml`:

```yaml
dependencies:
  shared_preferences: ^2.2.2  # Already added for auth
  provider: ^6.1.1            # State management (optional)
```

## Routes

Update `lib/main.dart`:

```dart
routes: {
  '/': (context) => const HomeScreen(),
  '/cart': (context) => const CartPage(),
  '/checkout': (context) => const CheckoutPage(),
  // ... other routes
}
```

## Testing Requirements

**Test File:** `test/cart_test.dart`

Required tests:
- ✅ Cart service adds items correctly
- ✅ Cart service increments quantity for existing items
- ✅ Cart service removes items
- ✅ Cart service calculates subtotal correctly
- ✅ Cart service persists to storage
- ✅ Cart service loads from storage
- ✅ Cart page displays items
- ✅ Cart page shows empty state
- ✅ Cart page updates quantities
- ✅ Cart badge shows correct count
- ✅ Authentication check before checkout

## Implementation Steps

1. **Create cart data model** (`lib/models/cart_item.dart`)
   - CartItem class with all properties
   - JSON serialization methods
   - Total price calculation

2. **Create cart service** (`lib/services/cart_service.dart`)
   - Singleton pattern
   - In-memory cart items list
   - Add/remove/update methods
   - Persistence logic
   - Stream for updates

3. **Update navbar** (`lib/widgets/navbar.dart`)
   - Add cart badge with count
   - Listen to cart stream
   - Navigate to cart page

4. **Create cart page** (`lib/screens/cart_page.dart`)
   - Empty state UI
   - Cart items list
   - Quantity controls
   - Subtotal calculation
   - Checkout button with auth check

5. **Update product pages**
   - Add "ADD TO CART" button
   - Integrate with cart service
   - Show success message

6. **Create basic checkout page** (`lib/screens/checkout_page.dart`)
   - Order summary
   - Place order simulation
   - Success message
   - Clear cart on completion

7. **Add cart initialization**
   - Load cart in main()
   - Initialize cart service

8. **Write tests**
   - Unit tests for cart service
   - Widget tests for cart page

## Authentication Integration

Cart requires authentication for checkout:

```dart
Future<void> _handleCheckout() async {
  final authService = AuthService();
  
  if (!authService.isSignedIn) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Sign In Required'),
        content: Text('You need to log in to checkout'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/login');
            },
            child: Text('Sign In'),
          ),
        ],
      ),
    );
    return;
  }
  
  // Proceed to checkout
  Navigator.pushNamed(context, '/checkout');
}
```

## Success Criteria

Feature is complete when:
1. ✅ Users can add products to cart from product pages
2. ✅ Cart badge shows correct item count
3. ✅ Cart page displays all items with details
4. ✅ Users can update quantities
5. ✅ Users can remove items
6. ✅ Subtotal calculates correctly
7. ✅ Cart persists across app restarts
8. ✅ Empty cart shows appropriate message
9. ✅ Authentication required for checkout
10. ✅ Checkout simulates order placement
11. ✅ All tests pass
12. ✅ No errors or warnings
13. ✅ Responsive on mobile and desktop

## Notes

- This is a simulated cart - no real payments
- Cart data stored locally (not in database)
- When user signs out, cart persists in local storage
- Could enhance later with:
  - Saving cart to user's account (database)
  - Product stock validation
  - Promo codes
  - Shipping calculations
  - Real payment integration

---

**Last Updated:** 1 December 2025  
**Status:** Ready for Implementation  
**Estimated Complexity:** Medium (6% of marks)
