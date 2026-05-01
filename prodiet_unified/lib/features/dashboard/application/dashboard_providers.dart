import 'package:flutter_riverpod/flutter_riverpod.dart';
export 'package:prodiet_unified/features/auth/application/auth_providers.dart';
import 'package:prodiet_unified/features/auth/application/auth_providers.dart';
import 'package:prodiet_unified/features/dashboard/data/dashboard_repository.dart';
import 'package:prodiet_unified/features/dashboard/domain/models/dashboard_summary.dart';

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return DashboardRepository(ref.watch(supabaseClientProvider));
});


final dashboardProvider = FutureProvider.autoDispose<DashboardSummary>((ref) async {
  final userId = ref.watch(currentUserIdProvider);
  if (userId.isEmpty) {
    return DashboardSummary.empty();
  }
  return ref.read(dashboardRepositoryProvider).getTodaySummary(userId);
});

final dashboardSummaryProvider = dashboardProvider;
