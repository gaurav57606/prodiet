import 'package:prodiet_unified/core/services/supabase_service.dart';
import 'package:prodiet_unified/core/error/error_handler.dart';
import '../domain/user_preferences.dart';

class PreferencesRepository {
  final SupabaseService _supabase;

  PreferencesRepository(this._supabase);

  Future<UserPreferences?> fetchPreferences(String userId) async {
    try {
      final response = await _supabase.perform((client) async {
        return await client
            .from('profiles')
            .select()
            .eq('id', userId)
            .single();
      }, context: 'preferences.fetchPreferences');
      
      return UserPreferences.fromMap(response);
    } catch (e) {
      throw ErrorHandler.handle(e, context: 'PreferencesRepository.fetchPreferences');
    }
  }

  Future<void> savePreferences(String userId, UserPreferences prefs) async {
    try {
      final data = prefs.toMap();
      data['id'] = userId;
      
      await _supabase.perform((client) async {
        await client
            .from('profiles')
            .upsert(data);
      }, context: 'preferences.savePreferences');
    } catch (e) {
      throw ErrorHandler.handle(e, context: 'PreferencesRepository.savePreferences');
    }
  }
}
