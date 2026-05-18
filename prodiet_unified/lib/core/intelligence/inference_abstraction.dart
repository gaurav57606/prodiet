import 'package:flutter/foundation.dart';
import 'package:prodiet_unified/core/services/supabase_service.dart';

/// Abstract contract for both local and cloud-based intelligence models.
abstract class BaseInferenceEngine {
  /// Unique identifier representing this model (e.g. 'ocr-cleanup', 'calorie-predictor')
  String get modelId;

  /// Asynchronously executes dynamic inference without blocking the UI thread.
  Future<Map<String, dynamic>> executeInference(Map<String, dynamic> inputs);
}

/// Offline-safe client-side machine learning engine (scaffolded for ONNX/TFLite integrations).
/// Leverages separate isolates via Flutter's [compute] utility to ensure perfect UI fluidity.
class LocalMlEngine implements BaseInferenceEngine {
  @override
  String get modelId => 'local-micro-classifier';

  @override
  Future<Map<String, dynamic>> executeInference(Map<String, dynamic> inputs) async {
    // Dispatch heavy calculations entirely to a background thread to prevent frame drops
    return await compute(_runOfflineInference, inputs);
  }

  static Map<String, dynamic> _runOfflineInference(Map<String, dynamic> inputs) {
    final type = inputs['type'] as String?;

    switch (type) {
      case 'macro_score':
        final protein = (inputs['protein'] as num?) ?? 0;
        final carbs = (inputs['carbs'] as num?) ?? 0;
        final fat = (inputs['fat'] as num?) ?? 0;
        final total = protein + carbs + fat;
        if (total == 0) return {'score': 1.0, 'classification': 'balanced'};

        final proteinRatio = protein / total;
        if (proteinRatio > 0.4) {
          return {'score': 0.95, 'classification': 'high_protein'};
        } else if (carbs / total > 0.6) {
          return {'score': 0.8, 'classification': 'high_carb'};
        }
        return {'score': 0.9, 'classification': 'balanced'};

      case 'calorie_predictor':
        // Simulates future linear regression calorie projection modeling based on activity and weight
        final steps = (inputs['steps'] as num?) ?? 0;
        final currentWeight = (inputs['weight'] as num?) ?? 75.0;
        final activityFactor = (steps > 10000) ? 1.2 : 1.0;
        final predictedKcal = (2000 * activityFactor) + (currentWeight * 0.1);
        return {
          'predicted_maintenance_calories': predictedKcal,
          'confidence_index': 0.88,
        };

      case 'meal_classifier':
        // Simulates local CNN food classification dictionary lookup
        final foodName = (inputs['food_name'] as String? ?? '').trim().toLowerCase();
        if (foodName.contains('chicken') || foodName.contains('egg') || foodName.contains('fish')) {
          return {'category': 'protein_dense', 'health_score': 9.0};
        } else if (foodName.contains('sugar') || foodName.contains('donut') || foodName.contains('soda')) {
          return {'category': 'processed_sugars', 'health_score': 2.0};
        }
        return {'category': 'standard', 'health_score': 6.5};

      case 'nutrition_scoring':
        // Computes composite scoring for a specific food log payload
        final calories = (inputs['calories'] as num?) ?? 0;
        final protein = (inputs['protein'] as num?) ?? 0;
        final fat = (inputs['fat'] as num?) ?? 0;

        final score = ((protein * 4 / calories).clamp(0.0, 0.5) * 100.0) +
            (100.0 - (fat * 9 / calories).clamp(0.0, 0.4) * 100.0);
        return {
          'composite_score': score.clamp(10.0, 100.0),
          'is_nutrient_dense': score > 70.0,
        };

      default:
        return {'score': 1.0, 'classification': 'unknown'};
    }
  }
}

/// Cloud-based intelligence engine integrated with Supabase Edge Functions / Gemini.
/// Built with robust local engine fallbacks in case of offline states or latency issues.
class CloudAiEngine implements BaseInferenceEngine {
  final SupabaseService _supabase;
  final LocalMlEngine _localFallback;

  CloudAiEngine(this._supabase, this._localFallback);

  @override
  String get modelId => 'supabase-edge-ai';

  @override
  Future<Map<String, dynamic>> executeInference(Map<String, dynamic> inputs) async {
    final endpoint = inputs['endpoint'] as String? ?? 'ai-chat';
    final payload = inputs['payload'] as Map<String, dynamic>? ?? {};

    try {
      final response = await _supabase.perform(
        (client) => client.functions.invoke(
          endpoint,
          body: payload,
        ),
        context: 'ai_cloud_inference',
      );

      if (response.status != 200) {
        // Safe Fallback to offline model rather than throwing
        final fallbackResult = await _localFallback.executeInference(inputs);
        return {
          'success': true,
          'is_fallback': true,
          'error': 'Cloud returned status ${response.status}',
          'data': fallbackResult,
        };
      }

      return {
        'success': true,
        'is_fallback': false,
        'data': response.data,
      };
    } catch (e) {
      // Direct network failure gracefully redirects to Local ML Engine execution
      final fallbackResult = await _localFallback.executeInference(inputs);
      return {
        'success': true,
        'is_fallback': true,
        'error': e.toString(),
        'data': fallbackResult,
      };
    }
  }
}
