# Union Shop - E-commerce Flutter Web Application

A modern, responsive e-commerce web application built with Flutter for the University of Portsmouth Students' Union shop. Features a complete shopping experience with authentication, shopping cart, order management, and intelligent product search - optimized for iPhone 12 Pro viewport (390px width) with a clean, professional design.

## 🚀 Project Overview

Union Shop is a full-featured online store offering clothing, merchandise, and graduation items. The application provides a seamless shopping experience from product discovery through checkout, with secure user authentication and comprehensive order tracking.

**Live Demo:** [Coming Soon]

## ✨ Features

### Core Features
- 🏠 **Home Page** - Hero carousel, featured products, category navigation
- 🛍️ **Product Pages** - Detailed product views with images, descriptions, variants (size/color), and pricing
- 📦 **Collections** - Browse products by category (Clothing, Merchandise, Graduation)
- 🏷️ **Sale Collection** - Dedicated sale page with promotional messaging
- 🔍 **Smart Search** - Intelligent product search with relevance scoring
- 🛒 **Shopping Cart** - Full cart management with persistence
- 📋 **Order Management** - Complete order tracking and history
- 👤 **Authentication System** - Secure user account management with Supabase
- 📱 **Responsive Design** - Mobile-first approach with desktop optimization

### Product Features
- Product cards with images and pricing
- Dynamic product pages with size and color selection
- Sale price display with original price strikethrough
- Sold out state indication (greyed out, unclickable)
- Product variants (sizes: XS, S, M, L, XL, 2XL; colors available)
- Stock management and availability tracking
- Category and collection filtering

### Shopping Cart Features
- Add to cart with variant selection (size/color)
- Cart badge showing item count
- Persistent cart storage (survives page refresh)
- Quantity adjustment (increase/decrease)
- Remove items from cart
- Real-time price calculations (subtotal)
- Variant merging (same product with same variants)
- Checkout process
- Empty cart state with "Start Shopping" CTA
- Responsive cart layout (mobile/desktop)

### Search System Features
- Intelligent search across product names, descriptions, categories, and collections
- Relevance-based scoring and sorting
- Case-insensitive search
- Partial and multi-word query support
- Search from navbar and footer
- Dedicated search results page with query parameters
- Responsive grid layout (2-col mobile, 3-4 col desktop)
- Empty state with browse collections CTA
- Real-time result count display

### Order Management Features
- Create orders from cart checkout
- Order history display on account page
- Order details (items, variants, prices, totals)
- Order status tracking (Pending, Processing, Shipped, Delivered, Cancelled)
- Tax calculation (20% VAT)
- Customer notes support
- Pull-to-refresh order list
- Secure database storage with RLS policies
- Order timestamps (created/updated)

### Authentication Features
- Email/Password authentication
- User signup with validation
- User login
- Password reset flow
- Google OAuth integration
- GitHub OAuth integration
- User profile management (auto-created on signup)
- Account dashboard with Orders and Profile tabs
- Sign out functionality
- Account deletion
- Secure session management with JWT tokens
- Row Level Security (RLS) with Supabase
- No email verification required (instant signup)

## 🛠️ Tech Stack

### Frontend
- **Framework:** Flutter 3.x (Web)
- **Language:** Dart 3.x
- **UI Components:** Material Design
- **State Management:** ChangeNotifier pattern with StatefulWidget
- **Routing:** Named routes with dynamic parameters

### Backend & Services
- **Backend:** Supabase (PostgreSQL + Authentication)
- **Authentication:** Supabase Auth with OAuth 2.0 support
- **Database:** PostgreSQL with Row Level Security (RLS)
- **Storage:** SharedPreferences for cart persistence
- **Real-time:** StreamBuilder for reactive updates

### Key Packages
- `supabase_flutter: ^2.3.4` - Backend integration
- `shared_preferences: ^2.2.2` - Local storage
- `web: ^1.0.0` - Web-specific functionality
- `flutter_test` - Testing framework

### Development Tools
- Chrome DevTools for debugging
- Flutter Analyzer for code quality
- Git for version control
- VS Code / Android Studio

## 📋 Prerequisites

- Flutter SDK (3.0 or higher)
- Dart SDK (3.0 or higher)
- Chrome browser (for web development)
- Supabase account (free tier available)

## 🔧 Installation

### 1. Clone the Repository
```bash
git clone https://github.com/CameronGibbons/union_shop.git
cd union_shop
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Configure Supabase

#### Create Supabase Project
1. Go to [Supabase](https://supabase.com)
2. Create a new project
3. Get your project URL and anon key

#### Create Configuration File
Create `lib/config/supabase_config.dart`:
```dart
class SupabaseConfig {
  static const String supabaseUrl = 'YOUR_SUPABASE_URL';
  static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
}
```

**Note:** This file is gitignored and should never be committed.

#### Setup Database
1. Go to your Supabase project dashboard
2. Click "SQL Editor" in the sidebar
3. Copy the content of `supabase_setup.sql`
4. Paste and run in the SQL editor

This creates:
- `profiles` table for user data with RLS policies
- `orders` table for order storage with RLS policies
- Auto-creation triggers for new user profiles
- Timestamp management (created_at, updated_at)
- Indexes for performance optimization

#### Configure Authentication
1. Go to Authentication > Settings
2. Enable "Email" provider
3. **Disable "Confirm email"** (allows instant signup without email verification)
4. Set Site URL: `http://localhost:8080`
5. Add Redirect URLs:
   - `http://localhost:8080`
   - `http://localhost:8080/#/`
   - `http://localhost:8080/account`

#### (Optional) Configure OAuth
For Google/GitHub login:
1. Go to Authentication > Sign In / Providers in Supabase
2. Enable Google or GitHub provider
3. Get OAuth credentials from [Google Cloud Console](https://console.cloud.google.com) or [GitHub OAuth Apps](https://github.com/settings/developers)
4. Add redirect URI: `https://YOUR_PROJECT.supabase.co/auth/v1/callback`
5. Enter credentials in Supabase

**Note:** OAuth is optional - email/password authentication works without it.

### 4. Run the Application
```bash
flutter run -d chrome --web-port=8080
```

**Important:** Always use `--web-port=8080` to ensure the app runs on the correct port configured in Supabase.

## 📁 Project Structure

```
lib/
├── config/
│   └── supabase_config.dart          # Supabase credentials (gitignored)
├── models/
│   ├── cart_item.dart                # Shopping cart item model
│   ├── order.dart                    # Order and OrderItem models
│   ├── product.dart                  # Product data model
│   └── user.dart                     # User profile model
├── services/
│   ├── auth_service.dart             # Authentication service
│   ├── cart_service.dart             # Shopping cart state management
│   ├── order_service.dart            # Order CRUD operations
│   ├── products_service.dart         # Product data service
│   └── search_service.dart           # Search and filtering service
├── screens/
│   ├── about_page.dart               # About page
│   ├── account_page.dart             # Account dashboard (Orders + Profile)
│   ├── cart_page.dart                # Shopping cart page
│   ├── collection_detail_page.dart   # Collection detail view
│   ├── collections_page.dart         # Collections listing
│   ├── forgot_password_page.dart     # Password reset
│   ├── login_page.dart               # Login page
│   ├── print_shack_page.dart         # Print customization page
│   ├── product_page.dart             # Product detail with add to cart
│   ├── sale_collection_page.dart     # Sale products page
│   ├── search_results_page.dart      # Search results display
│   └── signup_page.dart              # User registration
├── utils/
│   └── snackbar_utils.dart           # Standardized user feedback
├── widgets/
│   ├── category_list_item.dart       # Category navigation item
│   ├── collection_card.dart          # Collection card component
│   ├── footer_widget.dart            # Footer with search link
│   ├── hero_carousel.dart            # Homepage carousel
│   ├── navbar.dart                   # Navigation bar with cart badge
│   └── product_card.dart             # Product card component
└── main.dart                         # App entry point and routing

prompts/
├── authentication_system_requirements.md   # Auth specs
## 🧪 Testing

### Run All Tests
```bash
flutter test
```

### Run Specific Test File
```bash
flutter test test/home_test.dart
flutter test test/search_test.dart
```

### Run Tests with Coverage
```bash
flutter test --coverage
```

### Test Coverage
- ✅ 106+ tests passing
- **Search System** (10 tests)
  - Empty query handling
  - Case-insensitive search
  - Relevance scoring
  - Multi-word queries
  - Partial matching
  - Special characters
  - Category search
## 🔐 Authentication & Security

### User Authentication Flows

#### Signup Flow
1. Click account icon (when not signed in)
2. Navigate to signup page
3. Fill in name, email, password
4. Password requirements:
   - Minimum 8 characters
   - At least 1 uppercase letter
   - At least 1 lowercase letter
   - At least 1 number
5. Submit → Account created instantly (no email verification)
6. Auto-redirect to account page

#### Login Flow
1. Click account icon
2. Enter email and password
3. Submit → Authenticate with Supabase
4. Success → Redirect to account page
5. OAuth URL cleanup (removes code parameter)

#### Password Reset Flow
1. Click "Forgot password?" on login page
2. Enter registered email address
3. Receive password reset link via email
4. Click link → Opens reset page
5. Enter and confirm new password
6. Submit → Password updated
7. Redirect to login page

#### OAuth Login Flow
1. Click "Continue with Google" or "Continue with GitHub"
2. Redirected to OAuth provider
3. Authorize application access
4. Return to app with auth code
5. Supabase processes authentication
6. User profile auto-created if new user
7. Redirect to account page
8. URL cleaned (code parameter removed)
## 📱 Application Routes

| Route | Page | Auth Required | Description |
|-------|------|---------------|-------------|
| `/` | Home | No | Landing page with carousel and featured products |
| `/about` | About | No | About the Students' Union shop |
| `/collections` | Collections | No | Browse all product collections |
| `/collection/:id` | Collection Detail | No | View products in specific collection |
| `/product/:id` | Product Detail | No | Product details with add to cart |
| `/sale` | Sale Collection | No | Discounted products |
| `/print-shack` | Print Shack | No | Custom print services |
| `/cart` | Shopping Cart | No | View and manage cart items |
| `/search` | Search Results | No | Product search with query parameter `?q=` |
| `/login` | Login | No | User login page |
| `/signup` | Signup | No | New user registration |
| `/forgot-password` | Password Reset | No | Reset forgotten password |
| `/account` | Account Dashboard | **Yes** | Orders history and user profile |

## 🚧 Development Status

### ✅ Completed Features (v0.4.0)
- [x] Home page with hero carousel
- [x] Product cards and listings
- [x] Dynamic product pages with variants
- [x] Collection pages (Clothing, Merchandise, Graduation)
- [x] Sale collection with filters and sorting
- [x] Sold out product state handling
- [x] Navigation and routing (13 routes)
- [x] Responsive navbar with cart badge
- [x] Footer component with search link
- [x] **Authentication system** (email/password + OAuth)
- [x] **User profiles** (auto-created, editable)
- [x] **Account dashboard** (Orders + Profile tabs)
- [x] **Shopping cart** (full CRUD with persistence)
- [x] **Checkout process** (order creation from cart)
- [x] **Order management** (history, tracking, status)
- [x] **Product search** (intelligent relevance scoring)
- [x] Password reset flow
- [x] Print Shack page
- [x] Comprehensive testing (106+ tests)

### 🔜 Upcoming Features
- [ ] Payment integration (Stripe/PayPal)
- [ ] Order status updates (admin)
- [ ] Product reviews and ratings
- [ ] Wishlist functionality
- [ ] Email notifications (order confirmation)
- [ ] Admin dashboard
- [ ] Inventory management
- [ ] Analytics and reporting
- [ ] Product recommendations
- [ ] Loyalty program

## 🔄 Version History

### v0.4.0 - Shopping & Search (Dec 1, 2025)
- Shopping cart system with variant selection
- Cart persistence with SharedPreferences
- Order management with database storage
- Order status tracking (Pending, Processing, Shipped, Delivered, Cancelled)
- Tax calculation (20% VAT)
- Intelligent product search with relevance scoring
- Search from navbar and footer
- Standardized snackbar utilities
- Comprehensive test coverage (106+ tests)

### v0.3.0 - Authentication System (Nov 2025)
- Complete authentication with Supabase
- Email/password authentication
- OAuth support (Google, GitHub)
- User profile management
- Account dashboard with tabs
- Password reset flow
- Row Level Security (RLS)

### v0.2.0 - Sale Collection (Nov 2025)
- Sale collection page with promotional messaging
- Sold out product state
- Product filtering and sorting
- Pagination support
- Dynamic routing

### v0.1.0 - Initial Release (Nov 2025)
- Basic e-commerce structure
- Product and collection pages
- Homepage with carousel
- Responsive mobile design
- Navigation system

## 🐛 Known Issues & Limitations

### Current Limitations
- **Payment Processing** - Not yet integrated (planned feature)
- **Email Notifications** - No order confirmation emails (planned)
- **Admin Panel** - No admin interface for order management (planned)
- **Product Reviews** - Rating system not implemented (planned)
- **Inventory Sync** - Manual stock management required
- **Image Upload** - Products use static assets (no user uploads)

### Browser Compatibility
- **Chrome/Edge** - Fully supported (recommended)
- **Safari** - Fully supported
- **Firefox** - Fully supported
- **Mobile Browsers** - Optimized for mobile but OAuth may vary

### Performance Notes
- First load may take 2-3 seconds (Flutter web initialization)
- Images are optimized but could benefit from lazy loading
- Search performs best with 3+ character queries

## 🎯 Project Goals & Achievements

### Primary Goals
1. **User Experience** ✅
   - Seamless shopping flow from browse to checkout
   - Intuitive navigation and search
   - Responsive design (mobile-first, desktop-ready)
   - Clear feedback with standardized snackbars
   
2. **Performance** ✅
   - Fast page loads with optimized assets
   - Smooth interactions and animations
   - Efficient state management
   - Search results under 500ms
   
3. **Security** ✅
   - Robust authentication with Supabase
   - Row Level Security on all data
   - Secure session management
   - OAuth 2.0 integration
   - Protected sensitive routes
   
4. **Scalability** ✅
   - Modular architecture
   - Reusable components
   - Service-based business logic
   - Database indexes for performance
   - Cloud-native backend (Supabase)
   
5. **Maintainability** ✅
   - Clean, documented code
   - Comprehensive test coverage (106+ tests)
   - Detailed requirements docs (1,500+ lines)
   - Git commit best practices
   - Consistent code formatting

### Academic Excellence
- **Complete E-commerce Platform** - All core features implemented
- **Advanced Features** - Search, cart persistence, order tracking
- **Professional Documentation** - README, requirements, code comments
- **Quality Assurance** - Extensive testing, no analysis errors
- **Modern Tech Stack** - Flutter 3.x, Supabase, OAuth 2.0

## 📚 Additional Documentation

Comprehensive requirements documentation for all major features:

- **`prompts/developer_requirements.md`** - Original coursework requirements
- **`prompts/authentication_system_requirements.md`** - Auth system specs
- **`prompts/dynamic_product_page_requirements.md`** - Product page specs  
- **`prompts/shopping_cart_requirements.md`** - Cart system specs (482 lines)
- **`prompts/orders_system_requirements.md`** - Order management specs (256 lines)
- **`prompts/search_system_requirements.md`** - Search functionality specs (390 lines)
- **`supabase_setup.sql`** - Complete database schema with RLS policies

Each requirements document includes:
- Functional requirements
- Technical specifications
- UI/UX mockups
- Implementation checklist
- Testing scenarios
- Future enhancements

## 📞 Support & Contact

### For Issues or Questions

1. **Setup Issues**
   - Review installation instructions above
   - Check Supabase configuration section
   - Verify port 8080 is available
   - Ensure Flutter SDK is up to date

2. **Feature Questions**
   - Check requirements docs in `prompts/` folder
   - Review test files for usage examples
   - See version history for feature timeline

3. **Bug Reports**
   - Check known issues section above
   - Run `flutter analyze` to check for errors
   - Review browser console for web errors

### Contact Information
- **Developer:** Cameron Gibbons
- **GitHub:** [@CameronGibbons](https://github.com/CameronGibbons)
- **Repository:** [union_shop](https://github.com/CameronGibbons/union_shop)

## 🤝 Contributing

This is a private project for the University of Portsmouth Students' Union. For contributions or suggestions, please contact the development team.

## 📄 License

Copyright © 2025 University of Portsmouth Students' Union. All rights reserved.

## 🌟 Acknowledgments

- Flutter team for the amazing framework
- Supabase for backend infrastructure
- University of Portsmouth Students' Union for the opportunity

---

**Made with ❤️ using Flutter and Supabase**
