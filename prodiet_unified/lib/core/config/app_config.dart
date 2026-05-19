import 'package:prodiet_unified/core/observability/logger/app_logger.dart';

// ignore_for_file: do_not_use_environment
class AppConfig {
  AppConfig._();

  static const supabaseUrl =
      String.fromEnvironment('SUPABASE_URL');
  static const supabaseAnonKey =
      String.fromEnvironment('SUPABASE_ANON_KEY');
  static const geminiApiKey =
      String.fromEnvironment('GEMINI_API_KEY');
  static const openFoodFactsUrl =
      String.fromEnvironment('OPEN_FOOD_FACTS_BASE_URL',
          defaultValue: 'https://world.openfoodfacts.org/api/v2');

  /// Returns null if config is valid, or an error message string if not.
  static String? validate() {
    if (supabaseUrl.isEmpty) {
      return 'SUPABASE_URL is not set.\n\n'
          'Run with:\n'
          'flutter run --dart-define-from-file=.env.json\n\n'
          'Build with:\n'
          'flutter build apk --dart-define-from-file=.env.json';
    }
    if (supabaseAnonKey.isEmpty) {
      return 'SUPABASE_ANON_KEY is not set.\n\n'
          'Run with:\n'
          'flutter run --dart-define-from-file=.env.json';
    }
    return null;
  }

  static bool get isValid =>
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;

  /// Human-readable config status for debug display.
  /// Returns a list of which required env vars are missing.
  static List<String> get missingVars {
    final missing = <String>[];
    if (supabaseUrl.isEmpty) missing.add('SUPABASE_URL');
    if (supabaseAnonKey.isEmpty) missing.add('SUPABASE_ANON_KEY');
    return missing;
  }

  /// Legacy: kept for compatibility — no longer throws, just logs.
  static void assertValid() {
    final error = validate();
    if (error != null) {
      AppLogger.warning('[AppConfig] WARNING: $error');
    }
  }
}
