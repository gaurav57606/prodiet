import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Hardware-backed secure storage client for Supabase authentication.
/// Persists access tokens in iOS Keychain and Android Keystore (via EncryptedSharedPreferences).
class SecureSupabaseStorage extends LocalStorage {
  const SecureSupabaseStorage();

  static const String _sessionKey = 'prodiet_secure_session_key';
  
  // In-memory fallback map to ensure auth client never crashes when storage is restricted/blocked
  static final Map<String, String> _inMemoryFallback = {};

  static const _secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  @override
  Future<void> initialize() async {
    try {
      await _secureStorage.write(key: 'prodiet_storage_test', value: 'test');
      await _secureStorage.delete(key: 'prodiet_storage_test');
    } catch (_) {
      // If secure storage throws (e.g. on blocked web localStorage), we gracefully rely on the in-memory fallback
    }
  }

  @override
  Future<bool> hasAccessToken() async {
    try {
      final exists = await _secureStorage.containsKey(key: _sessionKey);
      if (exists) return true;
    } catch (_) {}
    return _inMemoryFallback.containsKey(_sessionKey);
  }

  @override
  Future<String?> accessToken() async {
    try {
      final token = await _secureStorage.read(key: _sessionKey);
      if (token != null) return token;
    } catch (_) {}
    return _inMemoryFallback[_sessionKey];
  }

  @override
  Future<void> persistSession(String persistSessionString) async {
    _inMemoryFallback[_sessionKey] = persistSessionString;
    try {
      await _secureStorage.write(key: _sessionKey, value: persistSessionString);
    } catch (_) {
      // Fail silently to prevent hard crashes during UI renders
    }
  }

  @override
  Future<void> removePersistedSession() async {
    _inMemoryFallback.remove(_sessionKey);
    try {
      await _secureStorage.delete(key: _sessionKey);
    } catch (_) {
      // Fail silently to maintain robust session cleanups
    }
  }
}
