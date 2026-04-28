import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:prodiet_unified/features/auth/application/auth_providers.dart';
import 'package:prodiet_unified/features/auth/application/auth_state.dart';
import 'package:prodiet_unified/core/services/analytics_providers.dart';
import '../domain/models/water_log.dart';
import '../data/water_repository.dart';

final waterRepositoryProvider = Provider<WaterRepository>((ref) {
  return WaterRepository(
    ref.watch(supabaseClientProvider),
    ref.watch(analyticsServiceProvider),
  );
});

final todayWaterTotalProvider = FutureProvider.autoDispose<int>((ref) async {
  final authState = ref.watch(authProvider);
  if (authState is! AuthAuthenticated) return 0;
  
  final repository = ref.watch(waterRepositoryProvider);
  final result = await repository.getTodayWaterTotal(authState.user.id);
  
  return result.fold(
    (l) => throw l,
    (r) => r,
  );
});

final waterLogsProvider = FutureProvider.autoDispose.family<List<WaterLog>, String>((ref, date) async {
  final authState = ref.watch(authProvider);
  if (authState is! AuthAuthenticated) return [];
  
  final repository = ref.watch(waterRepositoryProvider);
  final result = await repository.getWaterLogs(authState.user.id, date);
  
  return result.fold(
    (l) => throw l,
    (r) => r,
  );
});

final waterActionsProvider = StateNotifierProvider<WaterActionsNotifier, AsyncValue<void>>((ref) {
  return WaterActionsNotifier(ref.watch(waterRepositoryProvider), ref);
});

class WaterActionsNotifier extends StateNotifier<AsyncValue<void>> {
  final WaterRepository _repository;
  final Ref _ref;

  WaterActionsNotifier(this._repository, this._ref) : super(const AsyncValue.data(null));

  Future<void> logWater(int amountMl) async {
    final authState = _ref.read(authProvider);
    if (authState is! AuthAuthenticated) return;

    state = const AsyncValue.loading();
    final result = await _repository.logWater(authState.user.id, amountMl);
    result.fold(
      (l) => state = AsyncValue.error(l, StackTrace.current),
      (r) {
        state = const AsyncValue.data(null);
        _ref.invalidate(todayWaterTotalProvider);
        _ref.invalidate(waterLogsProvider(DateTime.now().toIso8601String().split('T')[0]));
      },
    );
  }

  Future<void> deleteLog(String logId, String date) async {
    state = const AsyncValue.loading();
    final result = await _repository.deleteLog(logId);
    result.fold(
      (l) => state = AsyncValue.error(l, StackTrace.current),
      (r) {
        state = const AsyncValue.data(null);
        _ref.invalidate(todayWaterTotalProvider);
        _ref.invalidate(waterLogsProvider(date));
      },
    );
  }
}
