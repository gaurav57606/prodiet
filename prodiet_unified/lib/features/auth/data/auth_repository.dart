import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:prodiet_unified/core/services/supabase_service.dart';
import '../domain/models/app_user.dart';

class AuthRepository {
  final SupabaseService _supabase;

  AuthRepository(this._supabase);

  Future<void> signUpWithEmail(String email, String password, String name) async {
    final response = await _supabase.perform((client) async {
      return await client.auth.signUp(
        email: email,
        password: password,
        data: {'name': name},
      );
    }, context: 'auth.signUpWithEmail');

    final userId = response.user?.id;
    if (userId != null) {
      // Insert profile row so fetchProfile() never returns null for this user
      await _supabase.perform((client) async {
        await client.from('users').upsert({
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
      }, context: 'auth.signUpUpsertProfile');
    }
  }

  Future<void> signInWithEmail(String email, String password) async {
    await _supabase.perform((client) async {
      await client.auth.signInWithPassword(
        email: email,
        password: password,
      );
    }, context: 'auth.signInWithEmail');
  }

  Future<void> signInWithGoogle() async {
    await _supabase.perform((client) async {
      await client.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'com.prodiet.app://login-callback',
      );
    }, context: 'auth.signInWithGoogle');
  }

  Future<void> signOut() async {
    await _supabase.perform((client) async {
      await client.auth.signOut();
    }, context: 'auth.signOut');
  }

  Future<void> sendPasswordReset(String email) async {
    await _supabase.perform((client) async {
      await client.auth.resetPasswordForEmail(email);
    }, context: 'auth.sendPasswordReset');
  }

  Stream<AuthState> authStateChanges() {
    return _supabase.authStateChanges;
  }

  /// Returns the current active session synchronously.
  /// Used by AuthNotifier on startup to avoid waiting for a stream event
  /// that may have already fired before the listener was attached.
  Session? currentSession() {
    return _supabase.auth.currentSession;
  }

  Future<AppUser?> fetchProfile(String userId) async {
    final data = await _supabase.perform((client) async {
      return await client
          .from('users')
          .select()
          .eq('id', userId)
          .maybeSingle();
    }, context: 'auth.fetchProfile');
    
    if (data == null) return null;
    return AppUser.fromJson(data);
  }

  Future<void> updateProfile(String userId, Map<String, dynamic> data) async {
    data['updated_at'] = DateTime.now().toIso8601String();
    await _supabase.perform((client) async {
      await client.from('users').update(data).eq('id', userId);
    }, context: 'auth.updateProfile');
  }

  Future<void> sendPhoneOtp(String phoneWithCountryCode) async {
    await _supabase.perform((client) async {
      await client.auth.signInWithOtp(phone: phoneWithCountryCode);
    }, context: 'auth.sendPhoneOtp');
  }

  Future<void> verifyPhoneOtp(String phoneWithCountryCode, String token) async {
    await _supabase.perform((client) async {
      await client.auth.verifyOTP(
        phone: phoneWithCountryCode,
        token: token,
        type: OtpType.sms,
      );
    }, context: 'auth.verifyPhoneOtp');
  }
}
