import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:prodiet_unified/core/services/health_service.dart';

final healthServiceProvider = Provider<HealthService>((ref) => HealthService());

class FitbandState {
  final int steps;
  final double calories;
  final int? heartRate;
  final bool isLoading;
  final bool hasPermission;

  FitbandState({
    this.steps = 0,
    this.calories = 0.0,
    this.heartRate,
    this.isLoading = false,
    this.hasPermission = false,
  });

  FitbandState copyWith({
    int? steps,
    double? calories,
    int? heartRate,
    bool? isLoading,
    bool? hasPermission,
  }) {
    return FitbandState(
      steps: steps ?? this.steps,
      calories: calories ?? this.calories,
      heartRate: heartRate ?? this.heartRate,
      isLoading: isLoading ?? this.isLoading,
      hasPermission: hasPermission ?? this.hasPermission,
    );
  }
}

class FitbandNotifier extends StateNotifier<FitbandState> {
  final HealthService _healthService;

  FitbandNotifier(this._healthService) : super(FitbandState());

  Future<void> init() async {
    state = state.copyWith(isLoading: true);
    final granted = await _healthService.requestPermissions();
    state = state.copyWith(hasPermission: granted, isLoading: false);
    if (granted) {
      await refresh();
    }
  }

  Future<void> refresh() async {
    if (!state.hasPermission) return;
    
    state = state.copyWith(isLoading: true);
    try {
      final steps = await _healthService.getTodaySteps();
      final calories = await _healthService.getTodayCalories();
      final hr = await _healthService.getLatestHeartRate();
      
      state = state.copyWith(
        steps: steps,
        calories: calories,
        heartRate: hr,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }
}

final fitbandProvider = StateNotifierProvider<FitbandNotifier, FitbandState>((ref) {
  return FitbandNotifier(ref.watch(healthServiceProvider));
});
