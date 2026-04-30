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
      String.fromEnvironment('OPEN_FOOD_FACTS_BASE_URL', defaultValue: 'https://world.openfoodfacts.org/api/v2');

  static void assertValid() {
    assert(supabaseUrl.isNotEmpty,
        'SUPABASE_URL not set. Pass via --dart-define-from-file=.env.json');
    assert(supabaseAnonKey.isNotEmpty,
        'SUPABASE_ANON_KEY not set. Pass via --dart-define-from-file=.env.json');
  }
}
