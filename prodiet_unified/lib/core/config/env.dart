import 'package:prodiet_unified/core/config/app_config.dart';

class Env {
  Env._();
  static String get supabaseUrl => AppConfig.supabaseUrl;
  static String get supabaseAnonKey => AppConfig.supabaseAnonKey;
  static String get openFoodFactsUrl => AppConfig.openFoodFactsUrl;
}

