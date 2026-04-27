import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Which visual theme is currently active.
/// Each value maps to a distinct ThemeData with isolated colors,
/// fonts, spacing and widget styles — no cross-contamination.
enum ActiveTheme {
  t1Light,   // theme1 — Outfit font — purple/light
  t1Dark,    // theme1 — Outfit font — purple/dark  ← default
  t1Amoled,  // theme1 — Outfit font — purple/amoled
  t2Light,   // theme2 — BarlowCondensed+DmSans — lime/light
  t2Dark,    // theme2 — BarlowCondensed+DmSans — lime/dark
  t2Amoled,  // theme2 — BarlowCondensed+DmSans — lime/amoled
}

/// Default: t1Dark — matches theme1's original default (ThemeMode.dark).
final activeThemeProvider = StateProvider<ActiveTheme>(
  (ref) => ActiveTheme.t1Dark,
);
