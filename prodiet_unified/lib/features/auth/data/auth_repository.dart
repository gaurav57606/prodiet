import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/models/app_user.dart';

class AuthRepository {
  final SupabaseClient _supabase;
  static const String _tag = 'AuthRepository';

  AuthRepository(this._supabase);

  Future<void> signUpWithEmail(String email, String password, String name) async {
    try {
      await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {'name': name},
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signInWithEmail(String email, String password) async {
    try {
      await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      await _supabase.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'com.prodiet.app://login-callback',
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> sendPasswordReset(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(email);
    } catch (e) {
      rethrow;
    }
  }

  Stream<AuthState> authStateChanges() {
    return _supabase.auth.onAuthStateChange;
  }

  Future<AppUser?> fetchProfile(String userId) async {
    try {
      final data = await _supabase
          .from('users')
          .select()
          .eq('id', userId)
          .maybeSingle();
      if (data == null) return null;
      return AppUser.fromJson(data);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateProfile(String userId, Map<String, dynamic> data) async {
    try {
      data['updated_at'] = DateTime.now().toIso8601String();
      await _supabase.from('users').update(data).eq('id', userId);
    } catch (e) {
      rethrow;
    }
  }
}
