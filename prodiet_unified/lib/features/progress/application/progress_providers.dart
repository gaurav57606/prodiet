import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:prodiet_unified/features/auth/application/auth_providers.dart';
import 'package:prodiet_unified/features/auth/application/auth_state.dart';
import '../domain/models/progress_log.dart';
import '../data/progress_repository.dart';

final progressRepositoryProvider = Provider<ProgressRepository>((ref) {
  return ProgressRepository(Supabase.instance.client);
});

final progressLogsProvider = FutureProvider.autoDispose<List<ProgressLog>>((ref) async {
  final authState = ref.watch(authProvider);
  if (authState is! AuthAuthenticated) return [];
  
  final repository = ref.watch(progressRepositoryProvider);
  final result = await repository.getLogs(authState.user.id);
  
  return result.fold(
    (l) => throw l,
    (r) => r,
  );
});

final weightTrendProvider = FutureProvider.autoDispose.family<List<Map<String, dynamic>>, int>((ref, days) async {
  final authState = ref.watch(authProvider);
  if (authState is! AuthAuthenticated) return [];
  
  final repository = ref.watch(progressRepositoryProvider);
  final result = await repository.getWeightTrend(authState.user.id, days);
  
  return result.fold(
    (l) => throw l,
    (r) => r,
  );
});

final progressActionsProvider = StateNotifierProvider<ProgressActionsNotifier, AsyncValue<void>>((ref) {
  return ProgressActionsNotifier(ref.watch(progressRepositoryProvider), ref);
});

class ProgressActionsNotifier extends StateNotifier<AsyncValue<void>> {
  final ProgressRepository _repository;
  final Ref _ref;

  ProgressActionsNotifier(this._repository, this._ref) : super(const AsyncValue.data(null));

  Future<void> addLog(ProgressLog log) async {
    state = const AsyncValue.loading();
    final result = await _repository.addLog(log);
    result.fold(
      (l) => state = AsyncValue.error(l, StackTrace.current),
      (r) {
        state = const AsyncValue.data(null);
        _ref.invalidate(progressLogsProvider);
        _ref.invalidate(weightTrendProvider);
      },
    );
  }

  Future<void> deleteLog(String logId) async {
    state = const AsyncValue.loading();
    final result = await _repository.deleteLog(logId);
    result.fold(
      (l) => state = AsyncValue.error(l, StackTrace.current),
      (r) {
        state = const AsyncValue.data(null);
        _ref.invalidate(progressLogsProvider);
        _ref.invalidate(weightTrendProvider);
      },
    );
  }

  Future<String?> uploadPhoto(File file) async {
    final authState = _ref.read(authProvider);
    if (authState is! AuthAuthenticated) return null;

    final result = await _repository.uploadPhoto(authState.user.id, file);
    return result.fold(
      (l) {
        state = AsyncValue.error(l, StackTrace.current);
        return null;
      },
      (r) => r,
    );
  }
}
