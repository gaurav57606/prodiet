import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prodiet_unified/core/services/supabase_service.dart';
import 'package:prodiet_unified/core/services/sync_worker.dart';
import 'package:prodiet_unified/features/auth/application/auth_providers.dart';
import 'package:prodiet_unified/features/water/data/water_repository.dart';
import 'package:prodiet_unified/features/water/domain/water_summary.dart';
import '../domain/water_log.dart';

final waterRepositoryProvider = Provider<WaterRepository>((ref) {
  return WaterRepository(
    ref.watch(supabaseServiceProvider),
    ref.watch(appDatabaseProvider),
    ref.watch(syncWorkerProvider),
  );
});

final userWaterTargetProvider = Provider.autoDispose<int>((ref) {
  final user = ref.watch(currentUserProvider);
  return user?.dailyWaterGoalMl ?? 2000;
});

final waterSummaryProvider = StreamProvider.autoDispose<WaterSummary>((ref) {
  final userId = ref.watch(currentUserIdProvider);
  if (userId.isEmpty) return Stream.value(WaterSummary.empty(2000));
  
  final targetMl = ref.watch(userWaterTargetProvider);
  
  return ref.watch(waterRepositoryProvider).watchTodayLogs(userId).map((logs) {
    return WaterSummary.calculate(logs, targetMl);
  });
});

final todayWaterLogsProvider = StreamProvider.autoDispose<List<WaterLog>>((ref) {
  final userId = ref.watch(currentUserIdProvider);
  if (userId.isEmpty) return Stream.value([]);
  
  return ref.watch(waterRepositoryProvider).watchTodayLogs(userId);
});
