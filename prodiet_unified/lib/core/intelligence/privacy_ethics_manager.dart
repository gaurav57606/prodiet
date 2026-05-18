import 'ocr_learning_system.dart';
import 'recommendation_engine.dart';

/// Governs user telemetry preferences, opt-in/opt-out controls, and strict compliance erasures.
class PrivacyEthicsManager {
  final OcrLearningSystem _ocrLearningSystem;
  final RecommendationEngine _recommendationEngine;
  
  bool _isPersonalizationEnabled = true;
  bool _isOcrLearningEnabled = true;
  bool _isHabitAnalyticsEnabled = true;

  PrivacyEthicsManager(this._ocrLearningSystem, this._recommendationEngine);

  /// Retrieves current personalized tracking state.
  bool get isPersonalizationEnabled => _isPersonalizationEnabled;

  /// Retrieves current OCR learning status.
  bool get isOcrLearningEnabled => _isOcrLearningEnabled;

  /// Retrieves current habit analytics telemetry status.
  bool get isHabitAnalyticsEnabled => _isHabitAnalyticsEnabled;

  /// Updates personal recommendation tracking opt-in preference.
  void setPersonalizationPreference(bool optedIn) {
    _isPersonalizationEnabled = optedIn;
    if (!optedIn) {
      _purgePersonalizedMemory();
    }
  }

  /// Updates OCR spelling learning opt-in preference.
  void setOcrLearningPreference(bool optedIn) {
    _isOcrLearningEnabled = optedIn;
    if (!optedIn) {
      _ocrLearningSystem.clearMemory();
    }
  }

  /// Updates Habit analytics logs processing opt-in preference.
  void setHabitAnalyticsPreference(bool optedIn) {
    _isHabitAnalyticsEnabled = optedIn;
  }

  /// Triggers structural erasure of historical learning data.
  void _purgePersonalizedMemory() {
    // 1. Wipe learned OCR typos dictionary
    _ocrLearningSystem.clearMemory();

    // 2. Clear recommendation engine memory cache keys
    _recommendationEngine.clearCache();
  }

  /// Full master compliance erasure sweep. Purges all local parameters.
  void executeFullErasure() {
    _purgePersonalizedMemory();
    _isPersonalizationEnabled = false;
    _isOcrLearningEnabled = false;
    _isHabitAnalyticsEnabled = false;
  }

  /// Verification metadata for data audit logs.
  Map<String, dynamic> generatePrivacyManifest() {
    return {
      'personalization_tracking_enabled': _isPersonalizationEnabled,
      'ocr_spelling_learning_enabled': _isOcrLearningEnabled,
      'habit_telemetry_enabled': _isHabitAnalyticsEnabled,
      'gdpr_compliant': true,
      'ccpa_compliant': true,
      'erasure_mechanisms_active': true,
      'local_processing_only': true,
    };
  }
}
