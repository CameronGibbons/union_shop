# Orders System - Requirements & Implementation

## Overview
Implement a complete order management system that allows authenticated users to place orders, view order history, and track order status. Orders are stored in Supabase PostgreSQL database with full security policies.

## Functional Requirements

### FR-1: Order Creation
- **Description**: Users must be able to convert their shopping cart into a placed order
- **Acceptance Criteria**:
  - Only authenticated users can place orders
  - Order captures all cart items with variants (color, size)
  - Order calculates subtotal, tax (20% VAT), and total
  - Users can add optional order notes
  - Cart is cleared after successful order placement
  - Order confirmation is displayed with unique order ID

### FR-2: Order History
- **Description**: Users can view all their past orders
- **Acceptance Criteria**:
  - Orders displayed in reverse chronological order (newest first)
  - Each order shows: order ID, date, status, items, and totals
  - Pull-to-refresh capability to reload orders
  - Empty state shown for users with no orders
  - "Start Shopping" button navigates to home page

### FR-3: Order Details Display
- **Description**: Each order displays comprehensive information
- **Acceptance Criteria**:
  - Order ID (first 8 characters of UUID, uppercase)
  - Order creation date (formatted as "MMM DD, YYYY")
  - Status badge with color coding
  - List of all items with:
    - Product image (50x50px thumbnail)
    - Product name
    - Variant description (color/size)
    - Quantity
    - Individual item price
    - Item total (price × quantity)
  - Order totals breakdown:
    - Subtotal
    - Tax (20%)
    - Total
  - Customer note (if provided)

### FR-4: Order Status Management
- **Description**: Orders have status tracking throughout lifecycle
- **Acceptance Criteria**:
  - Status values: pending, processing, shipped, delivered, cancelled
  - Color-coded status badges:
    - Pending: Orange
    - Processing: Blue
    - Shipped: Purple
    - Delivered: Green
    - Cancelled: Red
  - Default status is "pending" on order creation

### FR-5: Navigation Integration
- **Description**: Profile icon works consistently across all pages
- **Acceptance Criteria**:
  - Profile icon on all page headers navigates to:
    - `/account` if user is signed in
    - `/login` if user is not signed in
  - Shopping bag icon navigates to `/cart`
  - Fixed on pages: Collections, Collection Detail, Sale Collection

## Technical Requirements

### TR-1: Database Schema
```sql
Table: public.orders
- id: UUID (primary key, auto-generated)
- user_id: UUID (foreign key to auth.users, cascade delete)
- items: JSONB (array of order items)
- subtotal: DECIMAL(10, 2)
- tax: DECIMAL(10, 2)
- total: DECIMAL(10, 2)
- status: TEXT (default 'pending')
- note: TEXT (nullable)
- created_at: TIMESTAMP WITH TIME ZONE (default NOW())
- updated_at: TIMESTAMP WITH TIME ZONE (default NOW())

Indexes:
- idx_orders_user_id on user_id
- idx_orders_created_at on created_at DESC
```

### TR-2: Row Level Security Policies
- **View Orders**: Users can only SELECT their own orders (WHERE auth.uid() = user_id)
- **Create Orders**: Authenticated users can INSERT orders for themselves
- **Update Orders**: Users can UPDATE their own orders (for status changes/cancellation)
- **Triggers**: Auto-update updated_at timestamp on any UPDATE

### TR-3: Data Models

**OrderItem Class**:
```dart
- productId: String
- productName: String
- color: String? (optional)
- size: String? (optional)
- price: double
- quantity: int
- imageUrl: String? (optional)
- totalPrice: double (computed: price × quantity)
- variantDescription: String (computed: "color / size")
- toJson() / fromJson() methods
```

**Order Class**:
```dart
- id: String
- userId: String
- items: List<OrderItem>
- subtotal: double
- tax: double
- total: double
- status: String
- note: String? (optional)
- createdAt: DateTime
- updatedAt: DateTime? (optional)
- itemCount: int (computed: sum of item quantities)
- toJson() / fromJson() methods
```

### TR-4: Service Layer

**OrderService** (`lib/services/order_service.dart`):
- `createOrder({items, note})`: Create new order from cart items
  - Validates user authentication
  - Calculates subtotal, tax (20%), and total
  - Converts CartItems to OrderItems
  - Inserts into database
  - Returns created Order object
- `getUserOrders()`: Fetch all orders for current user
  - Returns List<Order> sorted by created_at DESC
- `getOrderById(orderId)`: Get specific order
  - Validates user owns the order
  - Returns Order or null
- `updateOrderStatus(orderId, status)`: Update order status
- `cancelOrder(orderId)`: Cancel an order (sets status to 'cancelled')

### TR-5: UI Implementation

**Cart Page Updates** (`lib/screens/cart_page.dart`):
- Add OrderService instance
- Add `_isProcessingOrder` flag to prevent duplicate submissions
- Update `_handleCheckout()`:
  - Check authentication (redirect to login if not signed in)
  - Show loading state during order creation
  - Call `orderService.createOrder()` with cart items and note
  - Clear cart on success
  - Show success dialog with order ID
  - Offer "View Orders" and "Continue Shopping" actions
  - Handle errors with user feedback

**Account Page Updates** (`lib/screens/account_page.dart`):
- Add OrderService instance
- Add `_orders` list and `_isLoadingOrders` flag
- Load orders on page init
- Implement `_buildOrdersTab()`:
  - Show loading spinner while fetching
  - Show empty state if no orders
  - Show order list with RefreshIndicator
- Implement `_buildOrderCard(Order)`:
  - Display all order information per FR-3
  - Responsive card layout
- Implement `_buildStatusChip(String)`:
  - Return colored badge based on status

## Non-Functional Requirements

### NFR-1: Performance
- Order list pagination (future enhancement)
- Efficient JSONB queries with proper indexing
- Lazy loading of order details

### NFR-2: Security
- All database operations use RLS policies
- Users cannot access other users' orders
- User ID validation on all operations
- SQL injection prevention (parameterized queries via Supabase client)

### NFR-3: Error Handling
- Graceful handling of network errors
- User-friendly error messages
- Loading states during async operations
- Retry mechanisms for failed operations

### NFR-4: User Experience
- Pull-to-refresh on orders list
- Clear visual feedback for order status
- Responsive design for mobile and desktop
- Accessible color contrasts for status badges

## Implementation Checklist

- [x] Create Order and OrderItem models with JSON serialization
- [x] Create OrderService with CRUD operations
- [x] Update supabase_setup.sql with orders table schema
- [x] Add RLS policies for orders table
- [x] Update cart_page.dart to create orders on checkout
- [x] Update account_page.dart to display order history
- [x] Implement order card UI with all details
- [x] Implement status badge with color coding
- [x] Add pull-to-refresh for orders
- [x] Fix profile icon navigation on all pages
- [x] Fix shopping bag icon navigation on all pages
- [x] Test order creation flow
- [x] Test order display and refresh
- [x] Verify RLS policies work correctly
- [x] Run flutter analyze (no errors)

## Database Migration Steps

1. Open Supabase SQL Editor
2. Run the orders table creation script (lines 99-160 in supabase_setup.sql)
3. Verify table exists in Table Editor
4. Test RLS policies by creating test order
5. Verify indexes are created

## Testing Scenarios

1. **Order Creation**:
   - Add items to cart
   - Go to checkout
   - Verify authentication check
   - Place order with note
   - Verify order appears in account page

2. **Order Display**:
   - Navigate to account page
   - Verify orders tab shows all orders
   - Verify order details are correct
   - Pull to refresh and verify update

3. **Navigation**:
   - Test profile icon on each page (logged in)
   - Test profile icon on each page (logged out)
   - Test cart icon navigation

4. **Security**:
   - Verify users cannot see other users' orders
   - Verify unauthenticated users cannot access orders
   - Verify users can only update their own orders

## Future Enhancements

- Order cancellation UI
- Order search and filtering
- Email notifications on order placement
- Admin dashboard for order management
- Order tracking with shipping information
- Export orders to CSV/PDF
- Order status change history
- Refund/return functionality
