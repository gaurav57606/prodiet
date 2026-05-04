/// Feature flags — toggle features on/off without a new release.
/// In production, these should come from Supabase remote config or Firebase RC.
/// For now they are compile-time constants that can be toggled per build.
class FeatureFlags {
  FeatureFlags._();
  
  /// Set to true when `ocr-pipeline` Edge Function is confirmed deployed and tested.
  static const bool ocrEnabled = bool.fromEnvironment('FEATURE_OCR', defaultValue: false);
  
  /// Set to true when voice logging is implemented for T1.
  static const bool voiceLogEnabled = bool.fromEnvironment('FEATURE_VOICE', defaultValue: false);
  
  /// Set to true when micronutrient data integration is complete.
  static const bool micronutrientsEnabled = bool.fromEnvironment('FEATURE_MICRONUTRIENTS', defaultValue: false);
  
  /// Set to true when AI plan generation Edge Function is confirmed live.
  static const bool aiPlanEnabled = bool.fromEnvironment('FEATURE_AI_PLAN', defaultValue: true);
}
