import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prodiet_unified/features/auth/application/auth_providers.dart';
import '../data/preferences_repository.dart';
import 'preferences_notifier.dart';
import 'preferences_state.dart';

final preferencesRepositoryProvider = Provider<PreferencesRepository>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return PreferencesRepository(supabase);
});

final preferencesNotifierProvider =
    StateNotifierProvider<PreferencesNotifier, PreferencesState>((ref) {
  final repository = ref.watch(preferencesRepositoryProvider);
  return PreferencesNotifier(repository);
});
