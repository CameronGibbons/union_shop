# Union Shop - E-commerce Flutter Web Application

A modern, responsive e-commerce web application built with Flutter for the University of Portsmouth Students' Union shop. Optimized for iPhone 12 Pro viewport (390px width) with a clean, professional design.

## 🚀 Project Overview

Union Shop is a full-featured online store offering clothing, merchandise, and graduation items. The application provides a seamless shopping experience with product browsing, collections, sales, and a complete authentication system.

**Live Demo:** [Coming Soon]

## ✨ Features

### Core Features
- 🏠 **Home Page** - Hero carousel, featured products, category navigation
- 🛍️ **Product Pages** - Detailed product views with images, descriptions, and pricing
- 📦 **Collections** - Browse products by category (Clothing, Merchandise, Graduation)
- 🏷️ **Sale Collection** - Dedicated sale page with promotional messaging
- 👤 **Authentication System** - Complete user account management with Supabase
- 📱 **Responsive Design** - Optimized for mobile-first experience

### Product Features
- Product cards with images and pricing
- Sale price display with original price strikethrough
- Sold out state indication (greyed out, unclickable)
- Product pagination
- Category filtering
- Sort functionality

### Authentication Features (NEW! ✅)
- ✅ Email/Password authentication
- ✅ User signup with validation
- ✅ User login
- ✅ Password reset flow
- ✅ Google OAuth integration (configurable)
- ✅ Facebook OAuth integration (configurable)
- ✅ User profile management
- ✅ Account dashboard with Orders and Profile tabs
- ✅ Sign out functionality
- ✅ Account deletion
- ✅ Secure session management with JWT tokens
- ✅ Row Level Security (RLS) with Supabase

## 🛠️ Tech Stack

- **Framework:** Flutter 3.x (Web)
- **Language:** Dart
- **Backend:** Supabase (PostgreSQL + Authentication)
- **State Management:** StatefulWidget, StreamBuilder
- **Authentication:** Supabase Auth with OAuth support
- **Storage:** Browser Local Storage (via Supabase)
- **Testing:** Flutter Test Framework

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
- `profiles` table for user data
- Row Level Security (RLS) policies
- Auto-creation triggers for new users
- Timestamp management

#### Configure Authentication
1. Go to Authentication > Providers
2. Enable "Email" provider
3. Set Site URL: `http://localhost:8080`
4. Add Redirect URLs:
   - `http://localhost:8080`
   - `http://localhost:8080/#/`

#### (Optional) Configure OAuth
For Google/Facebook login:
1. Go to Authentication > Sign In / Providers in Supabase
2. Enable Google or Facebook provider
3. Get OAuth credentials from [Google Cloud Console](https://console.cloud.google.com) or [Facebook Developers](https://developers.facebook.com)
4. Add redirect URI: `https://YOUR_PROJECT.supabase.co/auth/v1/callback`
5. Enter credentials in Supabase

**Note:** OAuth is optional - email/password authentication works without it.

### 4. Run the Application
```bash
flutter run -d chrome --web-port=8080
```

**Important:** Always use `--web-port=8080` to ensure the app runs on the correct port configured in Supabase.

The app will open at `http://localhost:8080`

## 📁 Project Structure

```
lib/
├── config/
│   └── supabase_config.dart       # Supabase credentials (gitignored)
├── models/
│   ├── product.dart               # Product data model
│   └── user.dart                  # User profile model
├── services/
│   ├── products_service.dart      # Product data service
│   └── auth_service.dart          # Authentication service
├── screens/
│   ├── about_page.dart            # About page
│   ├── account_page.dart          # Account dashboard
│   ├── collection_detail_page.dart # Collection detail view
│   ├── collections_page.dart      # Collections listing
│   ├── forgot_password_page.dart  # Password reset
│   ├── login_page.dart            # Login page
│   ├── product_page.dart          # Product detail view
│   ├── sale_collection_page.dart  # Sale products page
│   └── signup_page.dart           # User registration
├── widgets/
│   ├── category_list_item.dart    # Category navigation item
│   ├── collection_card.dart       # Collection card component
│   ├── footer_widget.dart         # Footer component
│   ├── hero_carousel.dart         # Homepage carousel
│   └── product_card.dart          # Product card component
└── main.dart                      # App entry point

prompts/
├── authentication_system_requirements.md  # Auth implementation guide
├── dynamic_product_page_requirements.md   # Product page guide
└── developer_requirements.md              # Original project requirements

test/
├── home_test.dart                 # Homepage tests
├── product_test.dart              # Product tests
├── sale_test.dart                 # Sale page tests
└── widgets/                       # Widget tests
```

## 🧪 Testing

### Run All Tests
```bash
flutter test
```

### Run Specific Test File
```bash
flutter test test/home_test.dart
```

### Test Coverage
- ✅ 96 tests passing
- Home page functionality
- Product card widgets
- Sale collection page
- Sold out state
- Navigation flows

## 🎨 Design Specifications

- **Viewport:** iPhone 12 Pro (390px width)
- **Primary Color:** #4d2963 (Purple)
- **Background:** #F5F5F3 (Off-white)
- **Typography:** System fonts (San Francisco on iOS/macOS)
- **Layout:** Mobile-first, responsive grid

## 🔐 Authentication System

### User Flows

#### Signup
1. Click account icon (not signed in)
2. Navigate to signup page
3. Fill in name, email, password
4. Password must meet requirements:
   - 8+ characters
   - 1 uppercase letter
   - 1 lowercase letter
   - 1 number
5. Submit → Email verification sent
6. Verify email → Login

#### Login
1. Click account icon
2. Enter email and password
3. Success → Redirect to account page

#### Password Reset
1. Click "Forgot password?" on login
2. Enter email
3. Receive reset link via email
4. Click link and set new password

#### OAuth Login
1. Click "Continue with Google" or "Continue with Facebook"
2. Authorize with provider
3. Auto-create profile → Redirect to account

### Security Features
- Row Level Security (RLS) on all database tables
- JWT token-based authentication
- Automatic session refresh
- Secure password hashing (handled by Supabase)
- OAuth 2.0 integration
- Protected routes for authenticated users

## 📱 Routes

| Route | Page | Auth Required |
|-------|------|---------------|
| `/` | Home | No |
| `/about` | About | No |
| `/collections` | Collections | No |
| `/collection/:id` | Collection Detail | No |
| `/product/:id` | Product Detail | No |
| `/sale` | Sale Collection | No |
| `/login` | Login | No |
| `/signup` | Signup | No |
| `/forgot-password` | Password Reset | No |
| `/account` | Account Dashboard | Yes |

## 🚧 Development Status

### ✅ Completed Features
- [x] Home page with carousel
- [x] Product cards and listings
- [x] Collection pages
- [x] Sale collection with filters
- [x] Sold out product state
- [x] Navigation and routing
- [x] Footer component
- [x] Authentication system (email/password)
- [x] User profiles
- [x] Account dashboard
- [x] OAuth integration setup
- [x] Password reset flow

### 🔜 Upcoming Features
- [ ] Shopping cart
- [ ] Checkout process
- [ ] Order management
- [ ] Payment integration
- [ ] Product search
- [ ] Product reviews
- [ ] Wishlist
- [ ] Email notifications
- [ ] Admin dashboard

## 🤝 Contributing

This is a private project for the University of Portsmouth Students' Union. For contributions or suggestions, please contact the development team.

## 📄 License

Copyright © 2025 University of Portsmouth Students' Union. All rights reserved.

## 👨‍💻 Developer

**Cameron Gibbons**
- GitHub: [@CameronGibbons](https://github.com/CameronGibbons)

## 📞 Support

For issues or questions:
1. Check the authentication setup section above
2. Review requirement docs in `prompts/` folder
3. Contact the development team

## 🔄 Version History

### v0.3.0 - Authentication System (Dec 1, 2025)
- Added complete authentication system with Supabase
- Email/password authentication
- OAuth support (Google, Facebook)
- User profile management
- Account dashboard
- Password reset flow
- Secure session management

### v0.2.0 - Sale Collection (Nov 2025)
- Sale collection page with promotional messaging
- Sold out product state
- Product filtering and sorting
- Pagination support

### v0.1.0 - Initial Release (Nov 2025)
- Basic e-commerce structure
- Product and collection pages
- Homepage with carousel
- Responsive mobile design

## 🎯 Project Goals

1. **User Experience:** Provide a seamless, intuitive shopping experience
2. **Performance:** Fast loading times and smooth interactions
3. **Security:** Robust authentication and data protection
4. **Scalability:** Built to handle growing product catalog and user base
5. **Maintainability:** Clean code, comprehensive tests, thorough documentation

## 📚 Additional Documentation

- `prompts/authentication_system_requirements.md` - Auth implementation specs
- `prompts/dynamic_product_page_requirements.md` - Product page specs
- `prompts/developer_requirements.md` - Original project requirements
- `supabase_setup.sql` - Database setup script

## 🌟 Acknowledgments

- Flutter team for the amazing framework
- Supabase for backend infrastructure
- University of Portsmouth Students' Union for the opportunity

---

**Made with ❤️ using Flutter and Supabase**
