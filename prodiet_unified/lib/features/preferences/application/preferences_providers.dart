import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prodiet_unified/core/services/supabase_service.dart';
import '../data/preferences_repository.dart';
import 'preferences_notifier.dart';
import 'preferences_state.dart';

final preferencesRepositoryProvider = Provider<PreferencesRepository>((ref) {
  final supabase = ref.watch(supabaseServiceProvider);
  return PreferencesRepository(supabase);
});

final preferencesNotifierProvider =
    NotifierProvider<PreferencesNotifier, PreferencesState>(() {
  return PreferencesNotifier();
});
