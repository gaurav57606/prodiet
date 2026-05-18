import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:prodiet_unified/core/services/supabase_service.dart';
import 'package:prodiet_unified/features/auth/application/auth_providers.dart';
import 'package:prodiet_unified/features/dashboard/data/dashboard_repository.dart';
import 'package:prodiet_unified/features/dashboard/domain/models/dashboard_summary.dart';

part 'dashboard_providers.g.dart';

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return DashboardRepository(ref.watch(supabaseServiceProvider));
});

@riverpod
class Dashboard extends _$Dashboard {

  @override
  FutureOr<DashboardSummary> build() async {
    final userId = ref.watch(currentUserIdProvider);
    if (userId.isEmpty) {
      return DashboardSummary.empty();
    }
    return ref.read(dashboardRepositoryProvider).getTodaySummary(userId);
  }

  void addWaterLocally(int amountMl) {
    if (state.value == null) return;
    
    // Optimistic UI update
    state = AsyncData(state.value!.copyWith(
      waterMl: state.value!.waterMl + amountMl,
    ));
  }
}
