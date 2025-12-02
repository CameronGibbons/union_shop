# Code Refactoring and Structure Improvements Task

## Overview
This document outlines the refactoring tasks needed to improve code quality, reduce duplication, and enhance maintainability of the Union Shop Flutter application. These improvements align with the Software Development Practices requirements (25% of grade), particularly code quality standards.

## Current Issues Identified

### 1. **Color Constants Duplication** 🔴 HIGH PRIORITY
**Issue**: The UPSU brand color `Color(0xFF4d2963)` appears hardcoded in 50+ locations across the codebase.

**Impact**:
- Difficult to maintain consistent branding
- Error-prone if colors need to change
- Violates DRY (Don't Repeat Yourself) principle

**Solution**: Create a centralized theme/constants file

**Files Affected** (partial list):
- `lib/main.dart` (8+ occurrences)
- `lib/widgets/navbar.dart` (5+ occurrences)
- `lib/screens/product_page.dart` (10+ occurrences)
- `lib/screens/cart_page.dart` (5+ occurrences)
- `lib/screens/account_page.dart` (3+ occurrences)
- `lib/screens/about_page.dart` (5+ occurrences)
- `lib/screens/print_shack_page.dart` (4+ occurrences)
- `lib/widgets/product_card.dart` (1 occurrence)
- `lib/widgets/hero_carousel.dart` (4 occurrences)

**Refactoring Steps**:
1. Create `lib/constants/app_colors.dart`:
   ```dart
   import 'package:flutter/material.dart';

   class AppColors {
     // Brand Colors
     static const Color primary = Color(0xFF4d2963);  // UPSU Purple
     static const Color secondary = Color(0xFF2c2c2c); // Dark grey (footer)
     
     // Accent Colors
     static const Color error = Colors.red;
     static const Color success = Colors.green;
     
     // Neutral Colors
     static const Color textPrimary = Colors.black87;
     static const Color textSecondary = Colors.grey;
     static const Color backgroundLight = Colors.white;
     static const Color backgroundGrey = Color(0xFFF5F5F5);
     
     // Opacity Variants
     static Color primaryLight = primary.withValues(alpha: 0.1);
     static Color primaryMedium = primary.withValues(alpha: 0.5);
   }
   ```

2. Replace all hardcoded color values:
   - Find: `Color(0xFF4d2963)`
   - Replace: `AppColors.primary`
   - Find: `Color(0xFF2c2c2c)`
   - Replace: `AppColors.secondary`

3. Update theme in `main.dart`:
   ```dart
   theme: ThemeData(
     colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
     useMaterial3: true,
   ),
   ```

### 2. **Logo/Brand Text Duplication** 🟡 MEDIUM PRIORITY
**Issue**: The logo fallback text appears identically in multiple locations:
- `lib/widgets/navbar.dart` (2 times - desktop and mobile)
- Other pages that may have headers

**Current Code** (repeated):
```dart
Image.asset(
  'assets/images/logo.png',
  height: 50,
  errorBuilder: (context, error, stackTrace) {
    return const Text(
      'The UNION',
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Color(0xFF4d2963),
        fontFamily: 'Brush Script MT',
      ),
    );
  },
)
```

**Solution**: Create a reusable `LogoWidget`

**Refactoring Steps**:
1. Create `lib/widgets/logo_widget.dart`:
   ```dart
   import 'package:flutter/material.dart';
   import 'package:union_shop/constants/app_colors.dart';

   class LogoWidget extends StatelessWidget {
     final double height;
     final bool tappable;
     
     const LogoWidget({
       super.key,
       this.height = 50,
       this.tappable = true,
     });

     @override
     Widget build(BuildContext context) {
       final logo = Image.asset(
         'assets/images/logo.png',
         height: height,
         errorBuilder: (context, error, stackTrace) {
           return Text(
             'The UNION',
             style: TextStyle(
               fontSize: height * 0.56, // Proportional to height
               fontWeight: FontWeight.bold,
               color: AppColors.primary,
               fontFamily: 'Brush Script MT',
             ),
           );
         },
       );

       if (!tappable) return logo;

       return GestureDetector(
         onTap: () => Navigator.pushNamed(context, '/'),
         child: logo,
       );
     }
   }
   ```

2. Replace in `navbar.dart` (both desktop and mobile):
   ```dart
   const LogoWidget(height: 50)
   ```

### 3. **Announcement Bar Duplication** 🟡 MEDIUM PRIORITY
**Issue**: Announcement bar code is duplicated in:
- `lib/widgets/navbar.dart` (desktop)
- `lib/widgets/navbar.dart` (mobile menu)

**Current Code** (repeated twice):
```dart
Container(
  width: double.infinity,
  padding: const EdgeInsets.symmetric(vertical: 12),
  color: const Color(0xFF4d2963),
  child: const Text(
    'BIG SALE! OUR ESSENTIAL RANGE HAS DROPPED IN PRICE! OVER 20% OFF!',
    textAlign: TextAlign.center,
    style: TextStyle(
      color: Colors.white,
      fontSize: 12,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.5,
    ),
  ),
)
```

**Solution**: Extract to private method in `Navbar` class or separate widget

**Refactoring Steps**:
1. Option A - Private method in `Navbar`:
   ```dart
   Widget _buildAnnouncementBar() {
     return Container(
       width: double.infinity,
       padding: const EdgeInsets.symmetric(vertical: 12),
       color: AppColors.primary,
       child: const Text(
         'BIG SALE! OUR ESSENTIAL RANGE HAS DROPPED IN PRICE! OVER 20% OFF!',
         textAlign: TextAlign.center,
         style: TextStyle(
           color: Colors.white,
           fontSize: 12,
           fontWeight: FontWeight.w600,
           letterSpacing: 0.5,
         ),
       ),
     );
   }
   ```

2. Replace both occurrences with `_buildAnnouncementBar()`

### 4. **Icon Button Navigation Pattern** 🟡 MEDIUM PRIORITY
**Issue**: Icon buttons (search, account, cart) are duplicated in:
- Desktop navbar
- Mobile drawer header

**Current Pattern** (repeated):
```dart
IconButton(
  icon: const Icon(Icons.search, size: 24),
  onPressed: () {
    Navigator.pushNamed(context, '/search');
  },
),
IconButton(
  icon: const Icon(Icons.person_outline, size: 24),
  onPressed: () {
    final authService = AuthService();
    if (authService.isSignedIn) {
      Navigator.pushNamed(context, '/account');
    } else {
      Navigator.pushNamed(context, '/login');
    }
  },
),
// ... cart icon with badge
```

**Solution**: Create reusable icon button widgets

**Refactoring Steps**:
1. Create private methods in `Navbar` class:
   ```dart
   List<Widget> _buildNavIcons(BuildContext context, {bool closeMobileMenu = false}) {
     return [
       IconButton(
         icon: const Icon(Icons.search, size: 24),
         onPressed: () {
           if (closeMobileMenu) Navigator.pop(context);
           Navigator.pushNamed(context, '/search');
         },
       ),
       IconButton(
         icon: const Icon(Icons.person_outline, size: 24),
         onPressed: () {
           if (closeMobileMenu) Navigator.pop(context);
           final authService = AuthService();
           if (authService.isSignedIn) {
             Navigator.pushNamed(context, '/account');
           } else {
             Navigator.pushNamed(context, '/login');
           }
         },
       ),
       _buildCartIcon(context, closeMobileMenu: closeMobileMenu),
     ];
   }

   Widget _buildCartIcon(BuildContext context, {bool closeMobileMenu = false}) {
     return IconButton(
       icon: Stack(
         clipBehavior: Clip.none,
         children: [
           const Icon(Icons.shopping_bag_outlined, size: 24),
           ListenableBuilder(
             listenable: CartService(),
             builder: (context, _) {
               final itemCount = CartService().itemCount;
               if (itemCount == 0) return const SizedBox.shrink();
               
               return Positioned(
                 right: -6,
                 top: -6,
                 child: Container(
                   padding: const EdgeInsets.all(4),
                   decoration: const BoxDecoration(
                     color: AppColors.primary,
                     shape: BoxShape.circle,
                   ),
                   constraints: const BoxConstraints(
                     minWidth: 18,
                     minHeight: 18,
                   ),
                   child: Text(
                     itemCount > 99 ? '99+' : itemCount.toString(),
                     style: const TextStyle(
                       color: Colors.white,
                       fontSize: 10,
                       fontWeight: FontWeight.bold,
                     ),
                     textAlign: TextAlign.center,
                   ),
                 ),
               );
             },
           ),
         ],
       ),
       onPressed: () {
         if (closeMobileMenu) Navigator.pop(context);
         Navigator.pushNamed(context, '/cart');
       },
     );
   }
   ```

2. Use in both desktop and mobile contexts:
   ```dart
   // Desktop
   Row(children: _buildNavIcons(context))
   
   // Mobile
   Row(children: [
     ..._buildNavIcons(context, closeMobileMenu: true),
     // Close button
   ])
   ```

### 5. **Footer Links Pattern** 🟢 LOW PRIORITY
**Issue**: Footer link navigation uses repetitive if-else chains

**Current Code**:
```dart
GestureDetector(
  onTap: () {
    if (link.route == '/') {
      Navigator.pushNamed(context, '/');
    } else if (link.route == '/about') {
      Navigator.pushNamed(context, '/about');
    } else if (link.route == '/collections') {
      Navigator.pushNamed(context, '/collections');
    } // ... etc
  },
  child: Text(link.title, ...),
)
```

**Solution**: Simplify navigation logic

**Refactoring Steps**:
```dart
GestureDetector(
  onTap: () => Navigator.pushNamed(context, link.route),
  child: Text(
    link.title,
    style: const TextStyle(
      color: Colors.grey,
      fontSize: 14,
    ),
  ),
)
```

### 6. **Button Styles Duplication** 🟡 MEDIUM PRIORITY
**Issue**: Button styles are repeated across pages:
- Primary button (purple background)
- Secondary/outline button (purple border)

**Examples**:
```dart
// Primary button (repeated 10+ times)
ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFF4d2963),
    foregroundColor: Colors.white,
    // ... padding, shape, etc.
  ),
  child: Text('Button Text'),
)

// Outline button (repeated 5+ times)
OutlinedButton(
  style: OutlinedButton.styleFrom(
    foregroundColor: const Color(0xFF4d2963),
    side: const BorderSide(color: Color(0xFF4d2963)),
    // ... padding, shape, etc.
  ),
  child: Text('Button Text'),
)
```

**Solution**: Create custom button widgets or style constants

**Refactoring Steps**:
1. Create `lib/constants/button_styles.dart`:
   ```dart
   import 'package:flutter/material.dart';
   import 'package:union_shop/constants/app_colors.dart';

   class AppButtonStyles {
     static ButtonStyle primary = ElevatedButton.styleFrom(
       backgroundColor: AppColors.primary,
       foregroundColor: Colors.white,
       padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
       shape: RoundedRectangleBorder(
         borderRadius: BorderRadius.circular(4),
       ),
     );

     static ButtonStyle secondary = OutlinedButton.styleFrom(
       foregroundColor: AppColors.primary,
       side: const BorderSide(color: AppColors.primary),
       padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
       shape: RoundedRectangleBorder(
         borderRadius: BorderRadius.circular(4),
       ),
     );
   }
   ```

2. Or create custom widgets `lib/widgets/primary_button.dart` and `lib/widgets/secondary_button.dart`:
   ```dart
   class PrimaryButton extends StatelessWidget {
     final String text;
     final VoidCallback? onPressed;
     final bool isLoading;
     
     const PrimaryButton({
       super.key,
       required this.text,
       required this.onPressed,
       this.isLoading = false,
     });

     @override
     Widget build(BuildContext context) {
       return ElevatedButton(
         style: AppButtonStyles.primary,
         onPressed: isLoading ? null : onPressed,
         child: isLoading
             ? const SizedBox(
                 height: 20,
                 width: 20,
                 child: CircularProgressIndicator(
                   strokeWidth: 2,
                   valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                 ),
               )
             : Text(text),
       );
     }
   }
   ```

### 7. **Loading and Error States** 🟡 MEDIUM PRIORITY
**Issue**: Loading indicators and error states are implemented differently across pages

**Current Patterns**:
```dart
// Product page loading
Container(
  color: Colors.white,
  padding: const EdgeInsets.all(64),
  child: const Center(
    child: CircularProgressIndicator(
      color: Color(0xFF4d2963),
    ),
  ),
)

// Collection page loading
const Center(
  child: CircularProgressIndicator(),
)

// Error states vary in structure
```

**Solution**: Create reusable loading and error widgets

**Refactoring Steps**:
1. Create `lib/widgets/loading_widget.dart`:
   ```dart
   import 'package:flutter/material.dart';
   import 'package:union_shop/constants/app_colors.dart';

   class LoadingWidget extends StatelessWidget {
     final double padding;
     
     const LoadingWidget({
       super.key,
       this.padding = 64,
     });

     @override
     Widget build(BuildContext context) {
       return Container(
         color: Colors.white,
         padding: EdgeInsets.all(padding),
         child: const Center(
           child: CircularProgressIndicator(
             color: AppColors.primary,
           ),
         ),
       );
     }
   }
   ```

2. Create `lib/widgets/error_widget.dart`:
   ```dart
   import 'package:flutter/material.dart';
   import 'package:union_shop/constants/app_colors.dart';

   class ErrorDisplayWidget extends StatelessWidget {
     final String message;
     final VoidCallback? onRetry;
     
     const ErrorDisplayWidget({
       super.key,
       required this.message,
       this.onRetry,
     });

     @override
     Widget build(BuildContext context) {
       return Container(
         color: Colors.white,
         padding: const EdgeInsets.all(32),
         child: Center(
           child: Column(
             mainAxisSize: MainAxisSize.min,
             children: [
               const Icon(Icons.error_outline, size: 48, color: Colors.red),
               const SizedBox(height: 16),
               Text(
                 message,
                 textAlign: TextAlign.center,
                 style: const TextStyle(color: Colors.red),
               ),
               if (onRetry != null) ...[
                 const SizedBox(height: 16),
                 ElevatedButton(
                   onPressed: onRetry,
                   style: ElevatedButton.styleFrom(
                     backgroundColor: AppColors.primary,
                     foregroundColor: Colors.white,
                   ),
                   child: const Text('Retry'),
                 ),
               ],
             ],
           ),
         ),
       );
     }
   }
   ```

## Implementation Priority

### Phase 1: Critical Refactors (Do First)
1. ✅ **Color Constants** - Impacts entire codebase
2. ✅ **Button Styles** - Used frequently across many pages

### Phase 2: Medium Priority
3. ✅ **Logo Widget** - Improve navbar maintainability
4. ✅ **Announcement Bar** - Reduce navbar duplication
5. ✅ **Icon Buttons** - Simplify navbar code
6. ✅ **Loading/Error Widgets** - Standardize UX

### Phase 3: Nice to Have
7. ✅ **Footer Links** - Minor improvement
8. ✅ **Text Styles** - If time permits, centralize typography

## Testing Strategy

After each refactoring:
1. Run `flutter analyze` - ensure no new warnings
2. Run `flutter test` - all existing tests must pass
3. Visual regression check - app should look identical
4. Test on both mobile and desktop viewports

## Commit Strategy

Make separate commits for each refactoring phase:

1. **"add color constants and update all hardcoded colors"**
   - Create `app_colors.dart`
   - Replace all color values

2. **"add button style constants and refactor buttons"**
   - Create `button_styles.dart` or button widgets
   - Update all buttons

3. **"extract logo widget to reduce duplication"**
   - Create `logo_widget.dart`
   - Update navbar

4. **"refactor navbar announcement bar and icons"**
   - Extract methods in navbar
   - Clean up duplication

5. **"add reusable loading and error widgets"**
   - Create widgets
   - Replace existing implementations

6. **"simplify footer navigation logic"**
   - Update footer widget

## Expected Benefits

### Code Quality
- ✅ Reduced code duplication (DRY principle)
- ✅ Improved maintainability
- ✅ Easier to make design changes
- ✅ Consistent styling across app

### Assessment Impact
- **Addresses "Refactored" requirement** in code quality standards
- **Demonstrates professional practices** for software development grade
- **Shows understanding** of code organization
- **Makes future changes easier** for demo questions

### Maintainability
- One place to update brand colors
- Consistent button/widget behavior
- Easier to test components
- Better code documentation

## Notes

- This refactoring should NOT change any functionality
- All existing tests must continue to pass
- Visual appearance should remain identical
- Focus on improving code structure, not adding features
- Document any breaking changes in commit messages

## Additional Opportunities (Future)

If time permits after core refactoring:

1. **Text Styles**: Create `lib/constants/text_styles.dart` for typography
2. **Spacing Constants**: Centralize common padding/margin values
3. **Form Validation**: Extract common validation logic
4. **API Error Handling**: Standardize error responses
5. **Navigation Helper**: Create navigation utility methods

---

**Target Completion**: Complete Phase 1-2 before final submission
**Estimated Time**: 2-3 hours for full refactoring
**Risk**: Low - no functional changes, only structural improvements
