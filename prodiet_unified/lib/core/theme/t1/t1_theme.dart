// ═══════════════════════════════════════════════════════════
// T1 THEME  —  EXACT COPY of theme1/lib/core/theme/app_theme.dart
// Imports only t1_colors, t1_text_styles, t1_spacing.
// DO NOT import anything from t2/ or ls/.
// VISUAL OUTPUT IS IDENTICAL to running theme1 standalone.
// ═══════════════════════════════════════════════════════════
import 'package:flutter/material.dart';
import 't1_colors.dart';
import 't1_text_styles.dart';
import 't1_spacing.dart';

class T1Theme {
  // ── Public getters ────────────────────────────────────────
  static ThemeData get light  => _buildTheme(T1ColorSchemes.lightScheme,  isLight: true);
  static ThemeData get dark   => _buildTheme(T1ColorSchemes.darkScheme,   isLight: false);
  static ThemeData get amoled => _buildTheme(T1ColorSchemes.amoledScheme, isLight: false);

  // ── Dark / Amoled builder (matches theme1 buildTheme exactly) ──
  static ThemeData _buildTheme(ColorScheme scheme, {required bool isLight}) {
    if (isLight) return _buildLightTheme();

    final tt = T1TextStyles.getTextTheme(scheme);

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      textTheme: tt,
      scaffoldBackgroundColor: scheme.surface,

      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: tt.headlineSmall?.copyWith(
          color: scheme.onSurface,
        ),
      ),

      cardTheme: CardThemeData(
        color: scheme.surfaceContainerHighest,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(T1Spacing.radiusXl),
          side: BorderSide(
            color: scheme.primary.withOpacity(0.12),
            width: 1.0,
          ),
        ),
        margin: const EdgeInsets.symmetric(
          horizontal: T1Spacing.md,
          vertical: T1Spacing.sm,
        ),
      ),

      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return scheme.onPrimary;
          return scheme.onSurface.withOpacity(0.4);
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return scheme.primary;
          return scheme.onSurface.withOpacity(0.15);
        }),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          elevation: 0,
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(T1Spacing.radiusMd),
          ),
          textStyle: tt.titleSmall,
        ),
      ),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: scheme.surface.withOpacity(0.92),
        selectedItemColor: scheme.primary,
        unselectedItemColor: scheme.onSurface.withOpacity(0.25),
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: tt.labelSmall,
        unselectedLabelStyle: tt.labelSmall,
        selectedIconTheme: IconThemeData(color: scheme.primary, size: 24),
        unselectedIconTheme: IconThemeData(
          color: scheme.onSurface.withOpacity(0.25),
          size: 22,
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(T1Spacing.radiusMd),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(T1Spacing.radiusMd),
          borderSide: BorderSide(color: scheme.primary.withOpacity(0.15)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(T1Spacing.radiusMd),
          borderSide: BorderSide(color: scheme.primary, width: 1.5),
        ),
        hintStyle: tt.bodyMedium?.copyWith(
          color: scheme.onSurface.withOpacity(0.35),
        ),
      ),
    );
  }

  // ── Light builder (matches theme1 lightTheme exactly) ──────
  static ThemeData _buildLightTheme() {
    try {
      final c = T1ColorsLight;
      return ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        fontFamily: T1TextStyles.fontFamily,
        scaffoldBackgroundColor: c.bgPage,

        colorScheme: ColorScheme(
          brightness: Brightness.light,
          surface: c.bgPage,
          surfaceContainerHighest: c.bgElevated,
          onSurface: c.text1,
          onSurfaceVariant: c.text2,
          primary: c.primary,
          onPrimary: Colors.white,
          primaryContainer: c.bgCard,
          onPrimaryContainer: c.text1,
          secondary: c.alertGreen,
          onSecondary: Colors.white,
          secondaryContainer: c.alertGreenBg,
          onSecondaryContainer: c.alertGreen,
          error: c.alertAmber,
          onError: Colors.white,
          errorContainer: c.alertAmberBg,
          onErrorContainer: c.alertAmber,
          outline: c.border,
          outlineVariant: c.phoneBorder,
          inverseSurface: c.text1,
          onInverseSurface: c.bgPage,
          inversePrimary: c.primaryLight,
          scrim: Colors.black,
          shadow: Colors.black,
        ),

        cardTheme: CardThemeData(
          color: c.bgCard,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: BorderSide(color: c.border, width: 1),
          ),
        ),

        dividerTheme: DividerThemeData(color: c.border, thickness: 1),

        appBarTheme: AppBarTheme(
          backgroundColor: c.bgPage,
          foregroundColor: c.text1,
          elevation: 0,
          iconTheme: IconThemeData(color: c.text1),
          titleTextStyle: const TextStyle(
            fontFamily: T1TextStyles.fontFamily,
            fontWeight: FontWeight.w800,
            fontSize: 20,
            color: Color(0xFF2A0A50),
            letterSpacing: -0.3,
          ),
        ),

        textTheme: TextTheme(
          displayLarge:  TextStyle(fontFamily: T1TextStyles.fontFamily, fontWeight: FontWeight.w800, color: c.text1),
          displayMedium: TextStyle(fontFamily: T1TextStyles.fontFamily, fontWeight: FontWeight.w800, color: c.text1),
          displaySmall:  TextStyle(fontFamily: T1TextStyles.fontFamily, fontWeight: FontWeight.w800, color: c.text1),
          headlineLarge: TextStyle(fontFamily: T1TextStyles.fontFamily, fontWeight: FontWeight.w800, color: c.text1),
          headlineMedium:TextStyle(fontFamily: T1TextStyles.fontFamily, fontWeight: FontWeight.w700, color: c.text1),
          headlineSmall: TextStyle(fontFamily: T1TextStyles.fontFamily, fontWeight: FontWeight.w700, color: c.text1),
          titleLarge:    TextStyle(fontFamily: T1TextStyles.fontFamily, fontWeight: FontWeight.w700, color: c.text1),
          titleMedium:   TextStyle(fontFamily: T1TextStyles.fontFamily, fontWeight: FontWeight.w600, color: c.text1),
          titleSmall:    TextStyle(fontFamily: T1TextStyles.fontFamily, fontWeight: FontWeight.w600, color: c.text2),
          bodyLarge:     TextStyle(fontFamily: T1TextStyles.fontFamily, fontWeight: FontWeight.w500, color: c.text1),
          bodyMedium:    TextStyle(fontFamily: T1TextStyles.fontFamily, fontWeight: FontWeight.w400, color: c.text2),
          bodySmall:     TextStyle(fontFamily: T1TextStyles.fontFamily, fontWeight: FontWeight.w400, color: c.text3),
          labelLarge:    TextStyle(fontFamily: T1TextStyles.fontFamily, fontWeight: FontWeight.w700, color: c.text1, letterSpacing: 0.5),
          labelMedium:   TextStyle(fontFamily: T1TextStyles.fontFamily, fontWeight: FontWeight.w600, color: c.text2, letterSpacing: 0.5),
          labelSmall:    TextStyle(fontFamily: T1TextStyles.fontFamily, fontWeight: FontWeight.w600, color: c.text3, letterSpacing: 1.0),
        ),

        iconTheme: IconThemeData(color: c.navIcon),

        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: c.navBg,
          selectedItemColor: c.primary,
          unselectedItemColor: c.navIcon,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
        ),

        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: c.navBg,
          indicatorColor: c.primary.withOpacity(0.15),
          iconTheme: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return IconThemeData(color: c.primary);
            }
            return IconThemeData(color: c.navIcon);
          }),
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return TextStyle(
                fontFamily: T1TextStyles.fontFamily,
                fontSize: 8,
                fontWeight: FontWeight.w700,
                color: c.primary,
              );
            }
            return TextStyle(
              fontFamily: T1TextStyles.fontFamily,
              fontSize: 8,
              fontWeight: FontWeight.w700,
              color: c.navLabel,
            );
          }),
        ),

        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: c.bgCard,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: c.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: c.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: c.primary, width: 1.5),
          ),
          hintStyle: TextStyle(
            color: c.text3,
            fontFamily: T1TextStyles.fontFamily,
          ),
          labelStyle: TextStyle(
            color: c.text2,
            fontFamily: T1TextStyles.fontFamily,
          ),
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: c.primary,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontFamily: T1TextStyles.fontFamily,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),

        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: c.primary,
            side: BorderSide(color: c.border),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontFamily: T1TextStyles.fontFamily,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),

        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: c.primary,
            textStyle: const TextStyle(
              fontFamily: T1TextStyles.fontFamily,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),

        switchTheme: SwitchThemeData(
          thumbColor: WidgetStateProperty.resolveWith((s) =>
            s.contains(WidgetState.selected) ? c.primary : Colors.white),
          trackColor: WidgetStateProperty.resolveWith((s) =>
            s.contains(WidgetState.selected)
              ? c.primary.withOpacity(0.4)
              : c.border),
        ),

        checkboxTheme: CheckboxThemeData(
          fillColor: WidgetStateProperty.resolveWith((s) =>
            s.contains(WidgetState.selected) ? c.primary : Colors.transparent),
          checkColor: WidgetStateProperty.all(Colors.white),
          side: BorderSide(color: c.border, width: 1.5),
        ),

        chipTheme: ChipThemeData(
          backgroundColor: c.tagNormalBg,
          selectedColor: c.primary.withOpacity(0.15),
          disabledColor: c.bgCard,
          labelStyle: TextStyle(
            fontFamily: T1TextStyles.fontFamily,
            color: c.text2,
            fontSize: 11,
          ),
          side: BorderSide(color: c.border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),

        progressIndicatorTheme: ProgressIndicatorThemeData(
          color: c.primary,
          linearTrackColor: c.border,
          circularTrackColor: c.border,
        ),
      );
    } catch (_) {
      return ThemeData.light();
    }
  }
}
