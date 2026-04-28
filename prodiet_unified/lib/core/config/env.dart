import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  Env._();
  static String get supabaseUrl =>
      dotenv.env['SUPABASE_URL'] ?? (throw Exception('[Env] SUPABASE_URL missing'));
  static String get supabaseAnonKey =>
      dotenv.env['SUPABASE_ANON_KEY'] ?? (throw Exception('[Env] SUPABASE_ANON_KEY missing'));
  static String get geminiApiKey =>
      dotenv.env['GEMINI_API_KEY'] ?? (throw Exception('[Env] GEMINI_API_KEY missing'));
  static String get openFoodFactsUrl =>
      dotenv.env['OPEN_FOOD_FACTS_BASE_URL'] ?? 'https://world.openfoodfacts.org/api/v2';
}
