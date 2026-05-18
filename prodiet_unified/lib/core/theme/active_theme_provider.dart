import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Which visual theme is currently active.
/// Each value maps to a completely isolated ThemeData.
/// No cross-contamination between t1 and t2 is possible.
enum ActiveTheme {
  t1Light,    // theme1 — Outfit font — purple/light
  t1Dark,     // theme1 — Outfit font — purple/dark   ← default
  t1Amoled,   // theme1 — Outfit font — purple/amoled
  t2Light,    // theme2 — BarlowCondensed+DmSans — lime/light
  t2Dark,     // theme2 — BarlowCondensed+DmSans — lime/dark
  t2Amoled,   // theme2 — BarlowCondensed+DmSans — lime/amoled
}

const _kThemeKey = 'active_theme';

class ActiveThemeNotifier extends Notifier<ActiveTheme> {
  @override
  ActiveTheme build() => ActiveTheme.t1Dark;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_kThemeKey);
    if (saved != null) {
      final match = ActiveTheme.values.firstWhere(
        (e) => e.name == saved,
        orElse: () => ActiveTheme.t1Dark,
      );
      // Set state FIRST so RouterNotifier picks up the correct theme
      state = match;
    }
    // Mark initialized AFTER state is set
    // This ordering ensures the router reads the correct theme
    // when it re-evaluates the redirect
    ref.read(activeThemeInitializedProvider.notifier).state = true;
  }

  Future<void> setTheme(ActiveTheme theme) async {
    state = theme;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kThemeKey, theme.name);
  }
}

class ActiveThemeInitializedNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  @override
  set state(bool value) => super.state = value;
}

/// False until SharedPreferences has been read.
final activeThemeInitializedProvider = NotifierProvider<ActiveThemeInitializedNotifier, bool>(
  ActiveThemeInitializedNotifier.new,
);

/// Default: t1Dark — persisted to SharedPreferences across restarts.
final activeThemeProvider = NotifierProvider<ActiveThemeNotifier, ActiveTheme>(
  ActiveThemeNotifier.new,
);
