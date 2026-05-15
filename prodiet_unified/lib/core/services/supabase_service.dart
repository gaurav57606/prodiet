import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:prodiet_unified/core/error/error_handler.dart';

final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

class SupabaseService {
  final SupabaseClient _client;

  SupabaseService(this._client);

  SupabaseClient get client => _client;

  /// Generic wrapper for Supabase calls with centralized error handling
  Future<T> perform<T>(Future<T> Function(SupabaseClient client) action, {String? context}) async {
    try {
      return await action(_client);
    } catch (e) {
      throw ErrorHandler.handle(e, context: context);
    }
  }

  // Auth Helpers
  User? get currentUser => _client.auth.currentUser;
  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  // Realtime Helpers
  RealtimeChannel channel(String name) => _client.channel(name);
}

final supabaseServiceProvider = Provider<SupabaseService>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return SupabaseService(client);
});
