import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:prodiet_unified/core/services/supabase_service.dart';
import 'package:prodiet_unified/features/auth/application/auth_providers.dart';
import 'package:prodiet_unified/features/progress/data/progress_repository.dart';
import 'package:prodiet_unified/features/progress/domain/progress_summary.dart';

final progressRepositoryProvider = Provider<ProgressRepository>((ref) {
  return ProgressRepository(ref.watch(supabaseServiceProvider));
});

final selectedRangeProvider = StateProvider<int>((ref) => 30);

final progressSummaryProvider = FutureProvider.autoDispose<ProgressSummary>((ref) async {
  final userId = ref.watch(currentUserIdProvider);
  if (userId.isEmpty) return ProgressSummary.calculate([], 70, 70);
  
  final range = ref.watch(selectedRangeProvider);
  return ref.watch(progressRepositoryProvider).getProgressSummary(userId, days: range);
});
class ActivityLog {
  final String id;
  final String name;
  final int steps;
  final int caloriesBurned;
  final DateTime date;
  final String source;

  ActivityLog({
    required this.id,
    required this.name,
    required this.steps,
    required this.caloriesBurned,
    required this.date,
    required this.source,
  });

  factory ActivityLog.fromJson(Map<String, dynamic> json) => ActivityLog(
    id: json['id'] as String,
    name: json['name'] as String? ?? 'Activity Session',
    steps: json['steps'] as int? ?? 0,
    caloriesBurned: json['calories_burned'] as int? ?? 0,
    date: DateTime.parse(json['date'] as String),
    source: json['source'] as String? ?? 'app',
  );
}

final activityHistoryProvider = FutureProvider.autoDispose<List<ActivityLog>>((ref) async {
  final userId = ref.watch(currentUserIdProvider);
  if (userId.isEmpty) return [];

  final supabase = ref.watch(supabaseServiceProvider);
  final response = await supabase.perform((client) async {
    return await client
        .from('activity_logs')
        .select()
        .eq('user_id', userId)
        .order('date', ascending: false)
        .limit(10);
  }, context: 'progress.activityHistory');
  
  return (response as List).map((l) => ActivityLog.fromJson(l)).toList();
});
