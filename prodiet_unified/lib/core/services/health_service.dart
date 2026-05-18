import 'dart:io';
import 'package:health/health.dart';
import 'package:flutter/foundation.dart';
import 'package:prodiet_unified/core/observability/logger/app_logger.dart';

class HealthService {
  final Health _health = Health();

  // Define the types we want to read
  static const _types = [
    HealthDataType.STEPS,
    HealthDataType.HEART_RATE,
    HealthDataType.ACTIVE_ENERGY_BURNED,
  ];

  Future<bool> requestPermissions() async {
    if (kIsWeb || (!Platform.isAndroid && !Platform.isIOS)) return false;
    
    try {
      return await _health.requestAuthorization(_types);
    } catch (e, st) {
      AppLogger.error('[HealthService] Health permission error', error: e, stack: st, feature: 'health_connect');
      return false;
    }
  }

  Future<int> getTodaySteps() async {
    if (kIsWeb || (!Platform.isAndroid && !Platform.isIOS)) return 0;

    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day);

    try {
      final steps = await _health.getTotalStepsInInterval(midnight, now);
      return steps ?? 0;
    } catch (e, st) {
      AppLogger.error('[HealthService] Error fetching steps', error: e, stack: st, feature: 'health_connect');
      return 0;
    }
  }

  Future<double> getTodayCalories() async {
    if (kIsWeb || (!Platform.isAndroid && !Platform.isIOS)) return 0;

    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day);

    try {
      final data = await _health.getHealthDataFromTypes(
        startTime: midnight,
        endTime: now,
        types: [HealthDataType.ACTIVE_ENERGY_BURNED],
      );
      double total = 0.0;
      for (final point in data) {
        total += double.tryParse(point.value.toString()) ?? 0.0;
      }
      return total;
    } catch (e, st) {
      AppLogger.error('[HealthService] Error fetching calories', error: e, stack: st, feature: 'health_connect');
      return 0;
    }
  }

  Future<int?> getLatestHeartRate() async {
    if (kIsWeb || (!Platform.isAndroid && !Platform.isIOS)) return null;

    final now = DateTime.now();
    final oneHourAgo = now.subtract(const Duration(hours: 1));

    try {
      final data = await _health.getHealthDataFromTypes(
        startTime: oneHourAgo,
        endTime: now,
        types: [HealthDataType.HEART_RATE],
      );
      if (data.isEmpty) return null;
      
      // Sort by date to get the latest
      data.sort((a, b) => b.dateTo.compareTo(a.dateTo));
      return int.tryParse(data.first.value.toString());
    } catch (e, st) {
      AppLogger.error('[HealthService] Error fetching heart rate', error: e, stack: st, feature: 'health_connect');
      return null;
    }
  }
}
