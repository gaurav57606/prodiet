import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsRepository {
  final SharedPreferences _prefs;

  SettingsRepository(this._prefs);

  static const _themeKey = 'pref_theme_mode';
  static const _notificationsKey = 'pref_notifications_enabled';
  static const _onboardingKey = 'pref_onboarding_complete';

  Future<void> setTheme(String mode) => _prefs.setString(_themeKey, mode);
  String? getTheme() => _prefs.getString(_themeKey);

  Future<void> setNotificationsEnabled(bool enabled) => _prefs.setBool(_notificationsKey, enabled);
  bool getNotificationsEnabled() => _prefs.getBool(_notificationsKey) ?? true;

  Future<void> setOnboardingComplete(bool complete) => _prefs.setBool(_onboardingKey, complete);
  bool isOnboardingComplete() => _prefs.getBool(_onboardingKey) ?? false;
}

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  throw UnimplementedError('Initialize this in the bootstrap phase');
});
