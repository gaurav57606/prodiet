import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prodiet_unified/features/auth/application/auth_providers.dart';
import 'package:prodiet_unified/features/dashboard/application/dashboard_providers.dart';
import 'package:prodiet_unified/features/water/data/water_repository.dart';
import 'package:prodiet_unified/features/water/domain/water_summary.dart';
import '../domain/water_log.dart';

final waterRepositoryProvider = Provider<WaterRepository>((ref) {
  return WaterRepository(ref.watch(supabaseClientProvider));
});

final userWaterTargetProvider = FutureProvider.autoDispose<int>((ref) async {
  final userId = ref.watch(currentUserIdProvider);
  if (userId.isEmpty) return 2000;
  
  final data = await ref.read(supabaseClientProvider)
      .from('users')
      .select('daily_water_goal_ml')
      .eq('id', userId)
      .single();
  
  return (data['daily_water_goal_ml'] as num? ?? 2000).toInt();
});

final waterSummaryProvider = StreamProvider.autoDispose<WaterSummary>((ref) {
  final userId = ref.watch(currentUserIdProvider);
  if (userId.isEmpty) return Stream.value(WaterSummary.empty(2000));
  
  final targetAsync = ref.watch(userWaterTargetProvider);
  final targetMl = targetAsync.value ?? 2000;
  
  return ref.watch(waterRepositoryProvider).watchTodayLogs(userId).map((logs) {
    return WaterSummary.calculate(logs, targetMl);
  });
});

final todayWaterLogsProvider = StreamProvider.autoDispose<List<WaterLog>>((ref) {
  final userId = ref.watch(currentUserIdProvider);
  if (userId.isEmpty) return Stream.value([]);
  
  return ref.watch(waterRepositoryProvider).watchTodayLogs(userId);
});
