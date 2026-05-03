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

  /// Legacy: kept for compatibility — no longer throws, just logs.
  static void assertValid() {
    final error = validate();
    if (error != null) {
      // ignore: avoid_print
      print('[AppConfig] WARNING: $error');
    }
  }
}
