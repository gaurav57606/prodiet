import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:prodiet_unified/core/error/error_handler.dart';
import 'package:prodiet_unified/core/observability/logger/app_logger.dart';

final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

class SupabaseService {
  final SupabaseClient _client;

  SupabaseService(this._client);

  /// Centralized Execution Wrapper
  /// - Standardizes error handling
  /// - Adds observability
  /// - Prevents direct SDK leakage into repositories
  Future<T> perform<T>(
    Future<T> Function(SupabaseClient client) action, {
    String? context,
  }) async {
    try {
      AppLogger.info('[Supabase] Executing: ${context ?? 'unspecified'}');
      return await action(_client);
    } on PostgrestException catch (e, st) {
      AppLogger.error('[Supabase] Postgrest Error: ${e.message}', error: e, stack: st, feature: 'supabase');
      throw ErrorHandler.handle(e, context: context);
    } on AuthException catch (e, st) {
      AppLogger.error('[Supabase] Auth Error: ${e.message}', error: e, stack: st, feature: 'supabase');
      throw ErrorHandler.handle(e, context: context);
    } catch (e, st) {
      AppLogger.critical('[Supabase] Unexpected Error', error: e, stack: st, feature: 'supabase');
      throw ErrorHandler.handle(e, context: context);
    }
  }

  // Auth Status
  User? get currentUser => _client.auth.currentUser;
  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  // Safe Client and SDK Subsystem Accessors
  GoTrueClient get auth => _client.auth;
  SupabaseStorageClient get storage => _client.storage;
  SupabaseClient get client => _client;

  // Realtime
  final Map<String, RealtimeChannel> _activeChannels = {};

  /// Optimized Channel Management
  /// Use this to prevent duplicate subscriptions
  RealtimeChannel createChannel(String name) {
    if (_activeChannels.containsKey(name)) {
      AppLogger.info('[Supabase] Reusing existing channel: $name');
      return _activeChannels[name]!;
    }
    final channel = _client.channel(name);
    _activeChannels[name] = channel;
    return channel;
  }

  Future<void> removeChannel(RealtimeChannel channel) async {
    _activeChannels.removeWhere((key, value) => value == channel);
    await _client.removeChannel(channel);
  }

  // Storage
  /// Secure bucket interaction
  Future<String> uploadFile({
    required String bucket,
    required String path,
    required dynamic file,
  }) async {
    return perform((client) async {
      await client.storage.from(bucket).upload(path, file);
      return client.storage.from(bucket).getPublicUrl(path);
    }, context: 'storage_upload_$bucket');
  }
}

final supabaseServiceProvider = Provider<SupabaseService>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return SupabaseService(client);
});
