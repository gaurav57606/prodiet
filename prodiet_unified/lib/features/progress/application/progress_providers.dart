import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prodiet_unified/features/auth/application/auth_providers.dart';
import 'package:prodiet_unified/features/dashboard/application/dashboard_providers.dart';
import 'package:prodiet_unified/features/progress/data/progress_repository.dart';
import 'package:prodiet_unified/features/progress/domain/progress_summary.dart';

final progressRepositoryProvider = Provider<ProgressRepository>((ref) {
  return ProgressRepository(ref.watch(supabaseClientProvider));
});

final selectedRangeProvider = StateProvider<int>((ref) => 30);

final progressSummaryProvider =
    FutureProvider.autoDispose<ProgressSummary>((ref) async {
  final userId = ref.watch(currentUserIdProvider);
  if (userId.isEmpty) return ProgressSummary.calculate([], 70, 70);

  final range = ref.watch(selectedRangeProvider);
  return ref
      .watch(progressRepositoryProvider)
      .getProgressSummary(userId, days: range);
});
