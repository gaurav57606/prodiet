import 'package:flutter_riverpod/flutter_riverpod.dart';

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

/// Default: t1Dark — matches theme1's original ThemeMode.dark default.
final activeThemeProvider = StateProvider<ActiveTheme>(
  (ref) => ActiveTheme.t1Dark,
);
