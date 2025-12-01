import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:union_shop/models/user.dart';

class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() => message;
}

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  SupabaseClient get _supabase => Supabase.instance.client;

  // Stream of auth state changes
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  // Current user
  User? get currentUser => _supabase.auth.currentUser;

  // Is user signed in
  bool get isSignedIn => currentUser != null;

  // Sign up with email and password
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
        emailRedirectTo: null, // Disable email confirmation
      );

      // If email confirmation is disabled, user is auto-signed in
      // Create profile immediately if it doesn't exist
      if (response.user != null) {
        await _createProfile(response.user!);
      }

      return response;
    } on AuthException catch (e) {
      throw AuthException('Sign up failed: ${e.message}');
    } catch (e) {
      throw AuthException('Sign up failed: $e');
    }
  }

  // Sign in with email and password
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
    } on AuthException catch (e) {
      throw AuthException('Sign in failed: ${e.message}');
    } catch (e) {
      throw AuthException('Sign in failed: $e');
    }
  }

  // Sign in with Google (Web only for now)
  Future<bool> signInWithGoogle() async {
    try {
      await _supabase.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'http://localhost:8080/',
      );
      return true;
    } on AuthException catch (e) {
      throw AuthException('Google sign in failed: ${e.message}');
    } catch (e) {
      throw AuthException('Google sign in failed: $e');
    }
  }

  // Sign in with GitHub (Web only for now)
  Future<bool> signInWithGithub() async {
    try {
      await _supabase.auth.signInWithOAuth(
        OAuthProvider.github,
        redirectTo: 'http://localhost:8080/',
      );
      return true;
    } on AuthException catch (e) {
      throw AuthException('GitHub sign in failed: ${e.message}');
    } catch (e) {
      throw AuthException('GitHub sign in failed: $e');
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } on AuthException catch (e) {
      throw AuthException('Sign out failed: ${e.message}');
    } catch (e) {
      throw AuthException('Sign out failed: $e');
    }
  }

  // Get user profile from profiles table
  Future<UserProfile?> getUserProfile() async {
    try {
      final user = currentUser;
      if (user == null) return null;

      final response = await _supabase
          .from('profiles')
          .select()
          .eq('id', user.id)
          .maybeSingle();

      if (response == null) {
        // Create profile if it doesn't exist
        await _createProfile(user);
        return getUserProfile(); // Retry
      }

      return UserProfile.fromJson(response);
    } on PostgrestException catch (e) {
      throw AuthException('Failed to get profile: ${e.message}');
    } catch (e) {
      throw AuthException('Failed to get profile: $e');
    }
  }

  // Create profile for new user
  Future<void> _createProfile(User user) async {
    try {
      // First check if profile already exists
      final existing = await _supabase
          .from('profiles')
          .select()
          .eq('id', user.id)
          .maybeSingle();

      if (existing != null) {
        return; // Profile already exists
      }

      // Create new profile
      await _supabase.from('profiles').insert({
        'id': user.id,
        'email': user.email!,
        'full_name': user.userMetadata?['full_name'],
        'avatar_url': user.userMetadata?['avatar_url'],
        'created_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      // Log error but don't throw - profile creation can be retried later
      print('Error creating profile: $e');
    }
  }

  // Update user profile
  Future<void> updateUserProfile({
    String? fullName,
    String? avatarUrl,
  }) async {
    try {
      final user = currentUser;
      if (user == null) throw AuthException('No user signed in');

      await _supabase.from('profiles').update({
        if (fullName != null) 'full_name': fullName,
        if (avatarUrl != null) 'avatar_url': avatarUrl,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', user.id);
    } on PostgrestException catch (e) {
      throw AuthException('Failed to update profile: ${e.message}');
    } catch (e) {
      throw AuthException('Failed to update profile: $e');
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(email);
    } on AuthException catch (e) {
      throw AuthException('Password reset failed: ${e.message}');
    } catch (e) {
      throw AuthException('Password reset failed: $e');
    }
  }

  // Delete account
  Future<void> deleteAccount() async {
    try {
      final user = currentUser;
      if (user == null) throw AuthException('No user signed in');

      // Delete profile (this should cascade to auth.users if configured)
      await _supabase.from('profiles').delete().eq('id', user.id);

      // Sign out
      await signOut();
    } on PostgrestException catch (e) {
      throw AuthException('Account deletion failed: ${e.message}');
    } catch (e) {
      throw AuthException('Account deletion failed: $e');
    }
  }
}
