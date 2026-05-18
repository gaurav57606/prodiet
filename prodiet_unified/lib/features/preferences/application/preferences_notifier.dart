import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/preferences_repository.dart';
import '../domain/user_preferences.dart';
import 'preferences_state.dart';
import 'package:prodiet_unified/core/error/app_error.dart';
import 'preferences_providers.dart';

class PreferencesNotifier extends Notifier<PreferencesState> {
  late final PreferencesRepository _repository;

  @override
  PreferencesState build() {
    _repository = ref.watch(preferencesRepositoryProvider);
    return const PreferencesInitial();
  }

  Future<void> loadPreferences(String userId) async {
    state = const PreferencesLoading();
    try {
      final prefs = await _repository.fetchPreferences(userId);
      state = PreferencesLoaded(prefs ?? UserPreferences.empty());
    } catch (e) {
      final message = e is AppError ? e.displayMessage : e.toString();
      state = PreferencesError(message);
    }
  }

  Future<void> savePreferences(String userId, UserPreferences prefs) async {
    final previousState = state;
    state = const PreferencesSaving();
    try {
      await _repository.savePreferences(userId, prefs);
      state = const PreferencesSaved();
      // After saving, return to loaded state with updated preferences
      state = PreferencesLoaded(prefs);
    } catch (e) {
      final message = e is AppError ? e.displayMessage : e.toString();
      state = PreferencesError(message);
      // Rollback to previous loaded state if possible
      if (previousState is PreferencesLoaded) {
        state = previousState;
      }
    }
  }
}
