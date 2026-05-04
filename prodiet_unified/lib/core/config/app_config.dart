// ignore_for_file: do_not_use_environment
class AppConfig {
  AppConfig._();

  static const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');
  static const geminiApiKey = String.fromEnvironment('GEMINI_API_KEY');
  static const openFoodFactsUrl = String.fromEnvironment(
      'OPEN_FOOD_FACTS_BASE_URL',
      defaultValue: 'https://world.openfoodfacts.org/api/v2');

  /// Throws [StateError] in ALL build modes (debug, profile, release)
  /// if required environment variables are missing.
  /// assert() is a no-op outside debug+debugger — do NOT use it for config validation.
  static void assertValid() {
    if (supabaseUrl.isEmpty) {
      throw StateError(
        'SUPABASE_URL is not set.\n'
        'Build with: flutter build apk --dart-define-from-file=.env.json\n'
        'CI: ensure SUPABASE_URL secret is set in GitHub Actions.',
      );
    }
    if (supabaseAnonKey.isEmpty) {
      throw StateError(
        'SUPABASE_ANON_KEY is not set.\n'
        'Build with: flutter build apk --dart-define-from-file=.env.json\n'
        'CI: ensure SUPABASE_ANON_KEY secret is set in GitHub Actions.',
      );
    }
  }

  /// Returns true if all required config values are present.
  static bool get isValid =>
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;
}
