import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:prodiet_unified/features/auth/application/auth_providers.dart';
import 'package:prodiet_unified/features/auth/application/auth_state.dart';
import 'package:prodiet_unified/features/dashboard/data/dashboard_repository.dart';
import 'package:prodiet_unified/features/dashboard/domain/models/dashboard_summary.dart';

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return DashboardRepository(Supabase.instance.client);
});

final dashboardSummaryProvider = FutureProvider.autoDispose<DashboardSummary>((ref) async {
  final authState = ref.watch(authProvider);
  
  if (authState is! AuthAuthenticated) {
    return DashboardSummary.empty();
  }
  
  final user = authState.user;
  final repository = ref.watch(dashboardRepositoryProvider);
  
  final result = await repository.getTodaySummary(
    userId: user.id,
    caloriesGoal: user.dailyCalorieGoal ?? 2000,
    waterGoalMl: user.dailyWaterGoalMl,
    // Add macro goals here if they are ever added to AppUser
  );
  
  return result.fold(
    (error) => throw error,
    (summary) => summary,
  );
});
