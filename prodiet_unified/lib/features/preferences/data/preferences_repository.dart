import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:prodiet_unified/core/error/error_handler.dart';
import '../domain/user_preferences.dart';

class PreferencesRepository {
  final SupabaseClient _supabase;

  PreferencesRepository(this._supabase);

  Future<UserPreferences?> fetchPreferences(String userId) async {
    try {
      final response =
          await _supabase.from('profiles').select().eq('id', userId).single();

      return UserPreferences.fromMap(response);
    } catch (e) {
      throw ErrorHandler.handle(e,
          context: 'PreferencesRepository.fetchPreferences');
    }
  }

  Future<void> savePreferences(String userId, UserPreferences prefs) async {
    try {
      final data = prefs.toMap();
      data['id'] = userId;

      await _supabase.from('profiles').upsert(data);
    } catch (e) {
      throw ErrorHandler.handle(e,
          context: 'PreferencesRepository.savePreferences');
    }
  }
}
