import '../domain/user_preferences.dart';

sealed class PreferencesState {
  const PreferencesState();
}

class PreferencesInitial extends PreferencesState {
  const PreferencesInitial();
}

class PreferencesLoading extends PreferencesState {
  const PreferencesLoading();
}

class PreferencesLoaded extends PreferencesState {
  final UserPreferences prefs;
  const PreferencesLoaded(this.prefs);
}

class PreferencesSaving extends PreferencesState {
  const PreferencesSaving();
}

class PreferencesSaved extends PreferencesState {
  const PreferencesSaved();
}

class PreferencesError extends PreferencesState {
  final String message;
  const PreferencesError(this.message);
}
