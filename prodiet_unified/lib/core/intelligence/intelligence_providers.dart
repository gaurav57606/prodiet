import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prodiet_unified/core/services/supabase_service.dart';
import 'inference_abstraction.dart';
import 'user_profile_engine.dart';
import 'recommendation_engine.dart';
import 'ocr_learning_system.dart';
import 'analytics_intelligence.dart';
import 'privacy_ethics_manager.dart';

/// Provider for local client-side ML engine.
final localMlEngineProvider = Provider<LocalMlEngine>((ref) {
  return LocalMlEngine();
});

/// Provider for cloud edge-compute AI engine.
final cloudAiEngineProvider = Provider<CloudAiEngine>((ref) {
  final supabaseService = ref.watch(supabaseServiceProvider);
  final localMl = ref.watch(localMlEngineProvider);
  return CloudAiEngine(supabaseService, localMl);
});

/// Provider for user profiling behavior engine.
final userProfileEngineProvider = Provider<UserProfileEngine>((ref) {
  return UserProfileEngine();
});

/// Provider for the recommendation manager.
final recommendationEngineProvider = Provider<RecommendationEngine>((ref) {
  final localMl = ref.watch(localMlEngineProvider);
  return RecommendationEngine(localMl);
});

/// Provider for the fuzzy auto-correction OCR learning system.
final ocrLearningSystemProvider = Provider<OcrLearningSystem>((ref) {
  return OcrLearningSystem();
});

/// Provider for nutrition trend analytics anomalies detection.
final analyticsIntelligenceProvider = Provider<AnalyticsIntelligence>((ref) {
  return AnalyticsIntelligence();
});

/// Provider for user privacy ethics constraints and erasures.
final privacyEthicsManagerProvider = Provider<PrivacyEthicsManager>((ref) {
  final ocrSystem = ref.watch(ocrLearningSystemProvider);
  final recommendationEngine = ref.watch(recommendationEngineProvider);
  return PrivacyEthicsManager(ocrSystem, recommendationEngine);
});
