import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/models/app_user.dart';

class AuthRepository {
  final SupabaseClient _supabase;

  AuthRepository(this._supabase);

  Future<void> signUpWithEmail(String email, String password, String name) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {'name': name},
      );

      final userId = response.user?.id;
      if (userId != null) {
        // Insert profile row so fetchProfile() never returns null for this user
        await _supabase.from('users').upsert({
          'id': userId,
          'email': email,
          'name': name,
          'onboarding_complete': false,
          'daily_water_goal_ml': 2000,
          'daily_calorie_goal': 2000,
          'target_weight_kg': null,
          'variety_preference': 'balanced',
          'allergies': <String>[],
          'dietary_preferences': <String>[],
          'created_at': DateTime.now().toIso8601String(),
        });
      }
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

  /// Returns the current active session synchronously.
  /// Used by AuthNotifier on startup to avoid waiting for a stream event
  /// that may have already fired before the listener was attached.
  Session? currentSession() {
    return _supabase.auth.currentSession;
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

  Future<void> sendPhoneOtp(String phoneWithCountryCode) async {
    try {
      await _supabase.auth.signInWithOtp(phone: phoneWithCountryCode);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> verifyPhoneOtp(String phoneWithCountryCode, String token) async {
    try {
      await _supabase.auth.verifyOTP(
        phone: phoneWithCountryCode,
        token: token,
        type: OtpType.sms,
      );
    } catch (e) {
      rethrow;
    }
  }
}
