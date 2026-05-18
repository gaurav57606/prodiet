import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Hardware-backed secure storage client for Supabase authentication.
/// Persists access tokens in iOS Keychain and Android Keystore (via EncryptedSharedPreferences).
class SecureSupabaseStorage extends LocalStorage {
  const SecureSupabaseStorage();

  static const String _sessionKey = 'prodiet_secure_session_key';

  static const _secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  @override
  Future<void> initialize() async {
    // No explicit initialization required for secure storage
  }

  @override
  Future<bool> hasAccessToken() async {
    try {
      return await _secureStorage.containsKey(key: _sessionKey);
    } catch (_) {
      return false;
    }
  }

  @override
  Future<String?> accessToken() async {
    try {
      return await _secureStorage.read(key: _sessionKey);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> persistSession(String persistSessionString) async {
    try {
      await _secureStorage.write(key: _sessionKey, value: persistSessionString);
    } catch (_) {
      // Fail silently to prevent hard crashes during UI renders
    }
  }

  @override
  Future<void> removePersistedSession() async {
    try {
      await _secureStorage.delete(key: _sessionKey);
    } catch (_) {
      // Fail silently to maintain robust session cleanups
    }
  }
}
