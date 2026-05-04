import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prodiet_unified/features/auth/application/auth_providers.dart';
// For AiRepository dependency
import 'package:prodiet_unified/features/ai/data/ai_repository.dart';
import '../data/compensation_repository.dart';
import '../domain/models/compensation_log.dart';

import 'package:prodiet_unified/core/services/analytics_providers.dart';

final aiRepositoryProvider = Provider<AiRepository>((ref) {
  return AiRepository(
    ref.watch(supabaseClientProvider),
    ref.watch(analyticsServiceProvider),
  );
});

final compensationRepositoryProvider = Provider<CompensationRepository>((ref) {
  return CompensationRepository(
    ref.watch(supabaseClientProvider),
    ref.watch(aiRepositoryProvider),
  );
});

final compensationHistoryProvider = FutureProvider.family<List<CompensationLog>, String>((ref, userId) async {
  final result = await ref.watch(compensationRepositoryProvider).getHistory(userId);
  return result.fold((e) => [], (logs) => logs);
});
