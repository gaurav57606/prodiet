import 'package:health/health.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:logger/logger.dart';

class ActivityData {
  final int steps;
  final int caloriesBurned;
  final int activeMinutes;

  ActivityData({
    required this.steps,
    required this.caloriesBurned,
    required this.activeMinutes,
  });

  Map<String, dynamic> toJson() => {
        'steps': steps,
        'calories_burned': caloriesBurned,
        'active_minutes': activeMinutes,
      };
}

class FitbandService {
  final SupabaseClient _supabase;
  final _health = Health();
  final _logger = Logger();

  FitbandService(this._supabase);

  Future<bool> requestPermissions() async {
    final types = [
      HealthDataType.STEPS,
      HealthDataType.ACTIVE_ENERGY_BURNED,
      HealthDataType.HEART_RATE,
    ];

    // The health package API might have changed slightly depending on version,
    // but the general flow is requestAuthorization.
    try {
      bool authorized = await _health.requestAuthorization(types);
      return authorized;
    } catch (e) {
      _logger.e('Error requesting health permissions: $e');
      return false;
    }
  }

  Future<ActivityData> getTodayActivity() async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);

    final types = [
      HealthDataType.STEPS,
      HealthDataType.ACTIVE_ENERGY_BURNED,
    ];

    try {
      List<HealthDataPoint> healthData = await _health.getHealthDataFromTypes(
        startTime: startOfDay,
        endTime: now,
        types: types,
      );

      int steps = 0;
      double calories = 0;

      for (var point in healthData) {
        if (point.type == HealthDataType.STEPS) {
          // Some health data points might be NumericHealthValue
          final value = point.value;
          if (value is NumericHealthValue) {
            steps += value.numericValue.toInt();
          }
        } else if (point.type == HealthDataType.ACTIVE_ENERGY_BURNED) {
          final value = point.value;
          if (value is NumericHealthValue) {
            calories += value.numericValue.toDouble();
          }
        }
      }

      // Simplified active minutes estimation or retrieval if available
      return ActivityData(
        steps: steps,
        caloriesBurned: calories.toInt(),
        activeMinutes: (steps / 100).toInt(), // fallback heuristic
      );
    } catch (e) {
      _logger.e('Error fetching health data: $e');
      return ActivityData(steps: 0, caloriesBurned: 0, activeMinutes: 0);
    }
  }

  Future<void> syncToSupabase(String userId, ActivityData data) async {
    try {
      final today = DateTime.now().toIso8601String().split('T')[0];

      await _supabase.from('activity_logs').upsert({
        'user_id': userId,
        'steps': data.steps,
        'calories_burned': data.caloriesBurned,
        'active_minutes': data.activeMinutes,
        'date': today,
        'source': 'fitband',
        'updated_at': DateTime.now().toIso8601String(),
      }, onConflict: 'user_id, date');

      _logger.i('Synced activity data for $userId');
    } catch (e) {
      _logger.e('Error syncing activity data: $e');
    }
  }
}
