# Authentication System Requirements

## Overview
Implement a full user authentication and account management system using Supabase (PostgreSQL database) with support for email/password authentication and social login (Google, GitHub). This system includes user registration, login, account dashboard, and session management with instant signup (no email verification required).

## Reference
- Live Example: https://shop.upsu.net/account (authentication flow)
- Target Viewport: iPhone 12 Pro (390px width)
- Framework: Flutter for Web
- Backend: Supabase (PostgreSQL + Authentication)

## Prerequisites
Before implementing this feature, you must have:
1. ✅ Existing Flutter web application structure
2. ✅ Navigation system in place
3. ✅ Header with account icon button
4. ✅ Supabase account configured
5. ✅ Email confirmation disabled in Supabase
6. ⚠️ Google OAuth credentials (optional)
7. ⚠️ GitHub OAuth credentials (optional)

## External Service Requirements

### Supabase Setup

**1. Create Supabase Project:**
- Go to https://supabase.com
- Sign up for free account
- Create new project
- Note down:
  - Project URL
  - Anon/Public API Key
  - Service Role Key (keep secret)

**2. Database Schema:**

**Users Table** (Auto-created by Supabase Auth):
```sql
-- Supabase automatically creates auth.users table
-- We'll extend it with a public.profiles table

CREATE TABLE public.profiles (
  id UUID REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
  email TEXT UNIQUE NOT NULL,
  full_name TEXT,
  avatar_url TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable Row Level Security
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- Users can view their own profile
CREATE POLICY "Users can view own profile"
  ON public.profiles FOR SELECT
  USING (auth.uid() = id);

-- Users can update their own profile
CREATE POLICY "Users can update own profile"
  ON public.profiles FOR UPDATE
  USING (auth.uid() = id);

-- Create profile on user signup (trigger)
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, email, full_name, avatar_url)
  VALUES (
    NEW.id,
    NEW.email,
    NEW.raw_user_meta_data->>'full_name',
    NEW.raw_user_meta_data->>'avatar_url'
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();
```

**Sessions Table** (Auto-managed by Supabase):
- Supabase handles session tokens automatically
- Sessions stored in browser local storage
- Auto-refresh on expiry

**3. Authentication Providers:**

**Email/Password:**
- Enabled by default in Supabase
- Requires email confirmation (can be disabled for testing)
- Password requirements: minimum 6 characters

**Google OAuth:**
1. Go to Google Cloud Console (console.cloud.google.com)
2. Create new project or select existing
3. Enable Google+ API
4. Create OAuth 2.0 credentials
5. Add authorized redirect URI: `https://[PROJECT_ID].supabase.co/auth/v1/callback`
6. Copy Client ID and Client Secret
7. Add to Supabase Dashboard → Authentication → Providers → Google

**GitHub OAuth:**
1. Go to GitHub Settings → Developer settings → OAuth Apps
2. Create new OAuth App
3. Set Authorization callback URL: `https://[PROJECT_ID].supabase.co/auth/v1/callback`
4. Copy Client ID and Client Secret
5. Add to Supabase Dashboard → Authentication → Providers → GitHub

**4. Email Templates (Optional):**
- Customize email confirmation template
- Customize password reset template
- Add UPSU branding

**5. Security Settings:**
- **Disable email confirmation** (allows instant signup)
- Configure JWT expiry (default: 1 hour)
- Configure session refresh (default: 7 days)
- Enable RLS policies on all tables

## Flutter Dependencies

### Required Packages
Add to `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  supabase_flutter: ^2.3.4
  google_sign_in: ^6.2.1
  flutter_facebook_auth: ^6.2.0
  shared_preferences: ^2.2.2
  
dev_dependencies:
  flutter_test:
    sdk: flutter
  mockito: ^5.4.4
```

### Environment Configuration
Create `.env` file (add to `.gitignore`):

```env
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key-here
GOOGLE_CLIENT_ID=your-google-client-id
FACEBOOK_APP_ID=your-facebook-app-id
```

**CRITICAL:** Never commit API keys to git!

## Data Model Requirements

### User Model
**File:** `lib/models/user.dart`

```dart
class UserProfile {
  final String id;
  final String email;
  final String? fullName;
  final String? avatarUrl;
  final DateTime createdAt;
  final DateTime? updatedAt;
  
  const UserProfile({
    required this.id,
    required this.email,
    this.fullName,
    this.avatarUrl,
    required this.createdAt,
    this.updatedAt,
  });
  
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['full_name'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at'] as String) 
          : null,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
      'avatar_url': avatarUrl,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
  
  String get displayName => fullName ?? email.split('@')[0];
  String get initials {
    if (fullName != null && fullName!.isNotEmpty) {
      final parts = fullName!.split(' ');
      if (parts.length >= 2) {
        return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
      }
      return fullName![0].toUpperCase();
    }
    return email[0].toUpperCase();
  }
}
```

## Service Layer Requirements

### Authentication Service
**File:** `lib/services/auth_service.dart`

Must implement singleton pattern and provide:

**1. Initialize Supabase:**
```dart
class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();
  
  final SupabaseClient _supabase = Supabase.instance.client;
  
  // Stream of auth state changes
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;
  
  // Current user
  User? get currentUser => _supabase.auth.currentUser;
  
  // Is user signed in
  bool get isSignedIn => currentUser != null;
}
```

**2. Sign Up with Email:**
```dart
Future<AuthResponse> signUpWithEmail({
  required String email,
  required String password,
  String? fullName,
}) async {
  try {
    final response = await _supabase.auth.signUp(
      email: email,
      password: password,
      data: {
        'full_name': fullName,
      },
    );
    return response;
  } catch (e) {
    throw AuthException('Sign up failed: $e');
  }
}
```

**3. Sign In with Email:**
```dart
Future<AuthResponse> signInWithEmail({
  required String email,
  required String password,
}) async {
  try {
    final response = await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
    return response;
  } catch (e) {
    throw AuthException('Sign in failed: $e');
  }
}
```

**4. Sign In with Google:**
```dart
Future<bool> signInWithGoogle() async {
  try {
    final response = await _supabase.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: 'io.supabase.flutterquickstart://login-callback/',
    );
    return response;
  } catch (e) {
    throw AuthException('Google sign in failed: $e');
  }
}
```

**5. Sign In with Facebook:**
```dart
Future<bool> signInWithFacebook() async {
  try {
    final response = await _supabase.auth.signInWithOAuth(
      OAuthProvider.facebook,
      redirectTo: 'io.supabase.flutterquickstart://login-callback/',
    );
    return response;
  } catch (e) {
    throw AuthException('Facebook sign in failed: $e');
  }
}
```

**6. Sign Out:**
```dart
Future<void> signOut() async {
  try {
    await _supabase.auth.signOut();
  } catch (e) {
    throw AuthException('Sign out failed: $e');
  }
}
```

**7. Get User Profile:**
```dart
Future<UserProfile?> getUserProfile() async {
  try {
    final user = currentUser;
    if (user == null) return null;
    
    final response = await _supabase
        .from('profiles')
        .select()
        .eq('id', user.id)
        .single();
    
    return UserProfile.fromJson(response);
  } catch (e) {
    throw AuthException('Failed to get profile: $e');
  }
}
```

**8. Update User Profile:**
```dart
Future<void> updateUserProfile({
  String? fullName,
  String? avatarUrl,
}) async {
  try {
    final user = currentUser;
    if (user == null) throw AuthException('No user signed in');
    
    await _supabase.from('profiles').update({
      'full_name': fullName,
      'avatar_url': avatarUrl,
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', user.id);
  } catch (e) {
    throw AuthException('Failed to update profile: $e');
  }
}
```

**9. Reset Password:**
```dart
Future<void> resetPassword(String email) async {
  try {
    await _supabase.auth.resetPasswordForEmail(email);
  } catch (e) {
    throw AuthException('Password reset failed: $e');
  }
}
```

**10. Delete Account:**
```dart
Future<void> deleteAccount() async {
  try {
    final user = currentUser;
    if (user == null) throw AuthException('No user signed in');
    
    // Delete profile (cascades to user)
    await _supabase.from('profiles').delete().eq('id', user.id);
  } catch (e) {
    throw AuthException('Account deletion failed: $e');
  }
}
```

## UI Implementation Requirements

### 1. Login Page
**File:** `lib/screens/login_page.dart`

**Layout Structure:**
1. Header with logo (centered)
2. "Sign in" heading (24px, bold)
3. Subheading: "Choose how you'd like to sign in"
4. Social auth buttons section:
   - "Sign in with Shop" button (purple, full-width)
   - "or" divider
5. Email/password form:
   - Email text field
   - Password text field (with show/hide toggle)
   - "Continue" button
6. Link to sign up: "Don't have an account? Sign up"
7. "Forgot password?" link

**Visual Design:**
- Background: White or light grey
- Logo: "The UNION" in UPSU purple, cursive font
- Purple accent color: `Color(0xFF4d2963)`
- Centered card layout (max width: 400px on desktop)
- 16px padding all around
- Rounded corners: 8px for card
- Button height: 48px

**Sign in with Shop Button:**
```dart
ElevatedButton(
  onPressed: () async {
    // For now, show email sign in as Shop uses email
    // Or implement Shopify OAuth if credentials available
  },
  style: ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFF5B44E4), // Shop purple
    minimumSize: const Size(double.infinity, 48),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(4),
    ),
  ),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      // Shop logo icon (if available)
      Text(
        'Sign in with shop',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ],
  ),
)
```

**Email Field:**
```dart
TextField(
  controller: _emailController,
  keyboardType: TextInputType.emailAddress,
  decoration: InputDecoration(
    labelText: 'Email',
    border: OutlineInputBorder(),
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  ),
)
```

**Password Field:**
```dart
TextField(
  controller: _passwordController,
  obscureText: _obscurePassword,
  decoration: InputDecoration(
    labelText: 'Password',
    border: OutlineInputBorder(),
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    suffixIcon: IconButton(
      icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
      onPressed: () {
        setState(() {
          _obscurePassword = !_obscurePassword;
        });
      },
    ),
  ),
)
```

**Continue Button:**
```dart
ElevatedButton(
  onPressed: _isLoading ? null : _handleEmailSignIn,
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.grey.shade200,
    foregroundColor: Colors.grey.shade700,
    minimumSize: const Size(double.infinity, 48),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(4),
    ),
  ),
  child: _isLoading
      ? SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        )
      : Text('Continue'),
)
```

**Sign In Handler:**
```dart
Future<void> _handleEmailSignIn() async {
  if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
    _showError('Please enter email and password');
    return;
  }
  
  setState(() {
    _isLoading = true;
    _errorMessage = null;
  });
  
  try {
    await AuthService().signInWithEmail(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
    
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/account');
    }
  } catch (e) {
    setState(() {
      _errorMessage = e.toString();
    });
  } finally {
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
```

### 2. Sign Up Page
**File:** `lib/screens/signup_page.dart`

**Layout Structure:**
1. Header with logo
2. "Create account" heading
3. Form fields:
   - Full name (optional)
   - Email
   - Password (with requirements)
   - Confirm password
4. "Create account" button
5. Link to login: "Already have an account? Sign in"

**Password Requirements:**
- Display validation criteria:
  - Minimum 6 characters
  - At least one uppercase letter (optional)
  - At least one number (optional)
- Show green checkmarks as requirements are met

**Validation:**
```dart
String? _validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'Email is required';
  }
  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  if (!emailRegex.hasMatch(value)) {
    return 'Enter a valid email';
  }
  return null;
}

String? _validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'Password is required';
  }
  if (value.length < 6) {
    return 'Password must be at least 6 characters';
  }
  return null;
}

String? _validateConfirmPassword(String? value) {
  if (value != _passwordController.text) {
    return 'Passwords do not match';
  }
  return null;
}
```

**Sign Up Handler:**
```dart
Future<void> _handleSignUp() async {
  if (!_formKey.currentState!.validate()) {
    return;
  }
  
  setState(() {
    _isLoading = true;
    _errorMessage = null;
  });
  
  try {
    await AuthService().signUpWithEmail(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      fullName: _nameController.text.trim().isNotEmpty 
          ? _nameController.text.trim() 
          : null,
    );
    
    if (mounted) {
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account created! Please check your email to verify.'),
          backgroundColor: Colors.green,
        ),
      );
      
      // Navigate to login
      Navigator.pushReplacementNamed(context, '/login');
    }
  } catch (e) {
    setState(() {
      _errorMessage = e.toString();
    });
  } finally {
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
```

### 3. Account Dashboard Page
**File:** `lib/screens/account_page.dart`

**Layout Structure:**
1. Header with logo and user menu dropdown
2. Page title: "Orders" or "Profile"
3. Tabs/Navigation:
   - Shop
   - Orders (active by default)
4. Content area based on selected tab:
   - **Orders Tab:** List of user orders or "No orders yet" message
   - **Profile Tab:** User profile information and settings
5. User menu dropdown (top right):
   - User email/name
   - Profile
   - Settings
   - Sign out

**User Menu Dropdown:**
```dart
PopupMenuButton<String>(
  icon: const Icon(Icons.person_outline),
  offset: const Offset(0, 50),
  itemBuilder: (context) => [
    PopupMenuItem(
      enabled: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Color(0xFF4d2963),
            child: Text(
              _userProfile?.initials ?? 'U',
              style: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(height: 8),
          Text(
            _userProfile?.email ?? '',
            style: TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ],
      ),
    ),
    PopupMenuItem(
      value: 'profile',
      child: Text('Profile'),
    ),
    PopupMenuItem(
      value: 'settings',
      child: Text('Settings'),
    ),
    PopupMenuItemDivider(),
    PopupMenuItem(
      value: 'signout',
      child: Text(
        'Sign out',
        style: TextStyle(color: Colors.red),
      ),
    ),
  ],
  onSelected: (value) async {
    switch (value) {
      case 'profile':
        // Navigate to profile edit
        break;
      case 'settings':
        // Navigate to settings
        break;
      case 'signout':
        await _handleSignOut();
        break;
    }
  },
)
```

**Orders Tab Content:**
```dart
Widget _buildOrdersTab() {
  // TODO: Integrate with orders system when implemented
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'No orders yet',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Go to store to place an order.',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 32),
        ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4d2963),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: 32,
              vertical: 16,
            ),
          ),
          child: const Text('Go to Store'),
        ),
      ],
    ),
  );
}
```

**Sign Out Handler:**
```dart
Future<void> _handleSignOut() async {
  final confirm = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Sign Out'),
      content: const Text('Are you sure you want to sign out?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text(
            'Sign Out',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    ),
  );
  
  if (confirm == true) {
    await AuthService().signOut();
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/');
    }
  }
}
```

### 4. Profile Settings Page
**File:** `lib/screens/profile_settings_page.dart`

**Layout:**
1. Profile picture section (avatar with edit button)
2. Form fields:
   - Full name
   - Email (read-only)
3. "Save Changes" button
4. Danger zone:
   - "Delete Account" button (red)

**Profile Update Handler:**
```dart
Future<void> _handleUpdateProfile() async {
  setState(() {
    _isLoading = true;
  });
  
  try {
    await AuthService().updateUserProfile(
      fullName: _nameController.text.trim(),
    );
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully'),
          backgroundColor: Colors.green,
        ),
      );
    }
  } catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update profile: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  } finally {
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
```

### 5. Forgot Password Page
**File:** `lib/screens/forgot_password_page.dart`

**Layout:**
1. Header with logo
2. "Reset password" heading
3. Instructions text
4. Email field
5. "Send reset link" button
6. Link back to login

**Reset Handler:**
```dart
Future<void> _handlePasswordReset() async {
  if (_emailController.text.isEmpty) {
    _showError('Please enter your email');
    return;
  }
  
  setState(() {
    _isLoading = true;
  });
  
  try {
    await AuthService().resetPassword(_emailController.text.trim());
    
    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Check Your Email'),
          content: const Text(
            'We\'ve sent a password reset link to your email address.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context); // Go back to login
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  } catch (e) {
    _showError('Failed to send reset link: $e');
  } finally {
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
```

## Routing and Navigation

### Update main.dart
**File:** `lib/main.dart`

Add authentication routes:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Supabase
  await Supabase.initialize(
    url: 'YOUR_SUPABASE_URL',
    anonKey: 'YOUR_SUPABASE_ANON_KEY',
  );
  
  runApp(const UnionShopApp());
}

class UnionShopApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Union Shop',
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignUpPage(),
        '/account': (context) => const AccountPage(),
        '/profile': (context) => const ProfileSettingsPage(),
        '/forgot-password': (context) => const ForgotPasswordPage(),
        '/about': (context) => const AboutPage(),
        '/collections': (context) => const CollectionsPage(),
        '/sale': (context) => const SaleCollectionPage(),
      },
      onGenerateRoute: (settings) {
        // Handle dynamic routes...
      },
    );
  }
}
```

### Auth State Wrapper
**File:** `lib/widgets/auth_wrapper.dart`

```dart
class AuthWrapper extends StatelessWidget {
  final Widget child;
  final bool requireAuth;
  
  const AuthWrapper({
    super.key,
    required this.child,
    this.requireAuth = false,
  });
  
  @override
  Widget build(BuildContext context) {
    if (!requireAuth) return child;
    
    return StreamBuilder<AuthState>(
      stream: AuthService().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        
        final session = snapshot.data?.session;
        
        if (session == null) {
          // Not authenticated - redirect to login
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacementNamed(context, '/login');
          });
          return const SizedBox();
        }
        
        // Authenticated - show content
        return child;
      },
    );
  }
}
```

### Update Header Account Button

Update the account icon in header to navigate based on auth state:

```dart
StreamBuilder<AuthState>(
  stream: AuthService().authStateChanges,
  builder: (context, snapshot) {
    final isSignedIn = snapshot.data?.session != null;
    
    return IconButton(
      icon: const Icon(Icons.person_outline, size: 24),
      onPressed: () {
        Navigator.pushNamed(
          context,
          isSignedIn ? '/account' : '/login',
        );
      },
    );
  },
)
```

## Testing Requirements

### Test File
**Location:** `test/auth_test.dart`

### Required Test Cases

**1. Authentication Service Tests:**
- ✅ Should initialize Supabase client
- ✅ Should sign up new user with email
- ✅ Should sign in existing user with email
- ✅ Should handle invalid credentials
- ✅ Should sign out user
- ✅ Should get current user profile
- ✅ Should update user profile
- ✅ Should send password reset email

**2. Login Page Tests:**
- ✅ Should display login form
- ✅ Should display social auth buttons
- ✅ Should validate email format
- ✅ Should validate password presence
- ✅ Should show/hide password
- ✅ Should navigate to signup page
- ✅ Should navigate to forgot password
- ✅ Should handle successful login
- ✅ Should display error on failed login

**3. Sign Up Page Tests:**
- ✅ Should display signup form
- ✅ Should validate all fields
- ✅ Should check password match
- ✅ Should create new account
- ✅ Should navigate to login after signup
- ✅ Should display error messages

**4. Account Page Tests:**
- ✅ Should display user email
- ✅ Should display orders tab
- ✅ Should display user menu
- ✅ Should sign out user
- ✅ Should navigate to profile settings
- ✅ Should show empty orders state

**5. Profile Settings Tests:**
- ✅ Should display profile form
- ✅ Should update profile name
- ✅ Should show success message
- ✅ Should handle update errors

### Mock Testing Setup
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:union_shop/services/auth_service.dart';

class MockAuthService extends Mock implements AuthService {}

void main() {
  group('Authentication Tests', () {
    late MockAuthService mockAuthService;
    
    setUp(() {
      mockAuthService = MockAuthService();
    });
    
    testWidgets('login page displays correctly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LoginPage(),
        ),
      );
      
      expect(find.text('Sign in'), findsOneWidget);
      expect(find.text('Sign in with shop'), findsOneWidget);
      expect(find.byType(TextField), findsNWidgets(2));
    });
    
    // More tests...
  });
}
```

## Security Best Practices

### 1. Environment Variables
- Never commit API keys
- Use `.env` file (gitignored)
- Use `flutter_dotenv` package for loading

### 2. Row Level Security (RLS)
- Enable RLS on all tables
- Write policies for user data access
- Test policies thoroughly

### 3. Password Security
- Minimum 6 characters
- Supabase handles hashing automatically
- Never store passwords in plain text

### 4. Session Management
- Sessions auto-refresh via Supabase
- Tokens stored securely in browser
- Clear session on logout

### 5. Input Validation
- Validate all form inputs
- Sanitize user inputs
- Use email regex validation
- Check password strength

### 6. Error Handling
- Don't expose sensitive error details
- Log errors securely
- Show user-friendly messages

## Validation Checklist

Before considering this feature complete:

- [ ] Supabase project created and configured
- [ ] Database tables created with RLS policies
- [ ] Google OAuth configured (optional but recommended)
- [ ] Facebook OAuth configured (optional but recommended)
- [ ] Supabase Flutter package installed
- [ ] Environment variables configured
- [ ] User model created
- [ ] AuthService implemented with all methods
- [ ] Login page created and functional
- [ ] Sign up page created with validation
- [ ] Account dashboard page created
- [ ] Profile settings page created
- [ ] Forgot password flow implemented
- [ ] Header account button updates based on auth state
- [ ] Auth state stream listener working
- [ ] Protected routes redirect to login
- [ ] Sign out functionality working
- [ ] Error handling implemented
- [ ] Loading states display correctly
- [ ] All tests passing
- [ ] `flutter analyze` shows no issues
- [ ] Code formatted with `dart format .`
- [ ] README updated with Supabase setup instructions

## Commit Strategy

Make separate commits for each major component:

1. **Supabase Setup:**
   ```
   Add Supabase configuration and dependencies
   ```

2. **User Model:**
   ```
   Add UserProfile data model with JSON serialization
   ```

3. **Auth Service:**
   ```
   Add AuthService with email and social authentication
   ```

4. **Login Page:**
   ```
   Add login page with email and social auth options
   ```

5. **Sign Up Page:**
   ```
   Add signup page with form validation
   ```

6. **Account Dashboard:**
   ```
   Add account dashboard with orders and profile tabs
   ```

7. **Profile Settings:**
   ```
   Add profile settings page with update functionality
   ```

8. **Forgot Password:**
   ```
   Add forgot password flow
   ```

9. **Navigation:**
   ```
   Add authentication routing and protected routes
   ```

10. **Header Integration:**
    ```
    Update header account button with auth state
    ```

11. **Tests:**
    ```
    Add comprehensive authentication tests
    ```

12. **Documentation:**
    ```
    Update README with Supabase setup and auth features
    ```

## Success Criteria

The feature is complete when:
1. ✅ User can sign up with email/password
2. ✅ User can sign in with email/password
3. ✅ User can sign in with Google (if configured)
4. ✅ User can sign in with Facebook (if configured)
5. ✅ User session persists across page reloads
6. ✅ User can view account dashboard
7. ✅ User can update profile information
8. ✅ User can sign out
9. ✅ User can reset password
10. ✅ Protected routes redirect to login
11. ✅ Account icon shows correct state
12. ✅ All tests pass
13. ✅ No analysis errors or warnings
14. ✅ Code is properly formatted
15. ✅ README documents setup and usage

## Performance Considerations

- Use `StreamBuilder` for auth state instead of polling
- Cache user profile to reduce database calls
- Implement debouncing on form inputs
- Use connection pooling (handled by Supabase)
- Lazy load user data on account page
- Optimize profile image uploads (if implemented)

## Accessibility Notes

- All form fields have labels
- Error messages are clear and actionable
- Keyboard navigation works throughout
- Focus states visible
- Color contrast meets WCAG standards
- Screen reader compatible

## Future Enhancements (Not Required for Initial Implementation)

- Two-factor authentication (2FA)
- OAuth with additional providers (Twitter, GitHub)
- User avatar upload to Supabase Storage
- Email verification enforcement
- Password strength meter
- Account activity log
- Session management (view active sessions)
- Privacy settings
- Marketing preferences
- Account linking (merge multiple auth methods)
- Admin dashboard for user management
- Analytics integration
- GDPR compliance features
- Account export functionality

---

**Last Updated:** 1 December 2025  
**Status:** ⚠️ Ready for Implementation  
**External Services:** Supabase (PostgreSQL + Auth)  
**Points Value:** 8% (Authentication) + 6% (External Services) = 14% total
