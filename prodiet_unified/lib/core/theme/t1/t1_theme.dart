// T1 THEME — exact copy of theme1/app_theme.dart
import 'package:flutter/material.dart';
import 't1_colors.dart';
import 't1_text_styles.dart';
import 't1_spacing.dart';

class T1Theme {
  static ThemeData buildTheme(ColorScheme scheme) {
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
        color: scheme.brightness == Brightness.dark
            ? scheme.surfaceContainerHighest
            : Colors.white.withOpacity(0.7),
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
          if (states.contains(WidgetState.selected)) {
            return scheme.onPrimary;
          }
          return scheme.onSurface.withOpacity(0.4);
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return scheme.primary;
          }
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
        selectedIconTheme: IconThemeData(
          color: scheme.primary,
          size: 24,
        ),
        unselectedIconTheme: IconThemeData(
          color: scheme.onSurface.withOpacity(0.25),
          size: 22,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.brightness == Brightness.dark
            ? Colors.white.withOpacity(0.05)
            : Colors.white.withOpacity(0.6),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(T1Spacing.radiusMd),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(T1Spacing.radiusMd),
          borderSide: BorderSide(
            color: scheme.primary.withOpacity(0.15),
          ),
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

  static ThemeData get dark => buildTheme(T1ColorSchemes.darkScheme);
  static ThemeData get amoled => buildTheme(T1ColorSchemes.amoledScheme);

  static ThemeData get light {
    try {
      return ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        fontFamily: 'Outfit',
        scaffoldBackgroundColor: T1ColorsLight.bgPage,
        colorScheme: ColorScheme(
          brightness: Brightness.light,

          // Surfaces
          surface: T1ColorsLight.bgPage,
          surfaceContainerHighest: T1ColorsLight.bgElevated,
          onSurface: T1ColorsLight.text1,
          onSurfaceVariant: T1ColorsLight.text2,

          // Primary
          primary: T1ColorsLight.primary,
          onPrimary: Colors.white,
          primaryContainer: T1ColorsLight.bgCard,
          onPrimaryContainer: T1ColorsLight.text1,

          // Secondary
          secondary: T1ColorsLight.alertGreen,
          onSecondary: Colors.white,
          secondaryContainer: T1ColorsLight.alertGreenBg,
          onSecondaryContainer: T1ColorsLight.alertGreen,

          // Error
          error: T1ColorsLight.alertAmber,
          onError: Colors.white,
          errorContainer: T1ColorsLight.alertAmberBg,
          onErrorContainer: T1ColorsLight.alertAmber,

          // Background (deprecated but still used in M3)
          background: T1ColorsLight.bgPage,
          onBackground: T1ColorsLight.text1,

          // Outline / border
          outline: T1ColorsLight.border,
          outlineVariant: T1ColorsLight.phoneBorder,

          // Inverse
          inverseSurface: T1ColorsLight.text1,
          onInverseSurface: T1ColorsLight.bgPage,
          inversePrimary: T1ColorsLight.primaryLight,

          // Scrim / shadow
          scrim: Colors.black,
          shadow: Colors.black,
        ),
        cardTheme: CardThemeData(
          color: T1ColorsLight.bgCard,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: BorderSide(color: T1ColorsLight.border, width: 1),
          ),
        ),
        dividerTheme: DividerThemeData(
          color: T1ColorsLight.border,
          thickness: 1,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: T1ColorsLight.bgPage,
          foregroundColor: T1ColorsLight.text1,
          elevation: 0,
          iconTheme: IconThemeData(color: T1ColorsLight.text1),
          titleTextStyle: const TextStyle(
            fontFamily: 'Outfit',
            fontWeight: FontWeight.w800,
            fontSize: 20,
            color: T1ColorsLight.text1,
            letterSpacing: -0.3,
          ),
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
              fontFamily: 'Outfit',
              fontWeight: FontWeight.w800,
              color: T1ColorsLight.text1),
          displayMedium: TextStyle(
              fontFamily: 'Outfit',
              fontWeight: FontWeight.w800,
              color: T1ColorsLight.text1),
          displaySmall: TextStyle(
              fontFamily: 'Outfit',
              fontWeight: FontWeight.w800,
              color: T1ColorsLight.text1),
          headlineLarge: TextStyle(
              fontFamily: 'Outfit',
              fontWeight: FontWeight.w800,
              color: T1ColorsLight.text1),
          headlineMedium: TextStyle(
              fontFamily: 'Outfit',
              fontWeight: FontWeight.w700,
              color: T1ColorsLight.text1),
          headlineSmall: TextStyle(
              fontFamily: 'Outfit',
              fontWeight: FontWeight.w700,
              color: T1ColorsLight.text1),
          titleLarge: TextStyle(
              fontFamily: 'Outfit',
              fontWeight: FontWeight.w700,
              color: T1ColorsLight.text1),
          titleMedium: TextStyle(
              fontFamily: 'Outfit',
              fontWeight: FontWeight.w600,
              color: T1ColorsLight.text1),
          titleSmall: TextStyle(
              fontFamily: 'Outfit',
              fontWeight: FontWeight.w600,
              color: T1ColorsLight.text2),
          bodyLarge: TextStyle(
              fontFamily: 'Outfit',
              fontWeight: FontWeight.w500,
              color: T1ColorsLight.text1),
          bodyMedium: TextStyle(
              fontFamily: 'Outfit',
              fontWeight: FontWeight.w400,
              color: T1ColorsLight.text2),
          bodySmall: TextStyle(
              fontFamily: 'Outfit',
              fontWeight: FontWeight.w400,
              color: T1ColorsLight.text3),
          labelLarge: TextStyle(
              fontFamily: 'Outfit',
              fontWeight: FontWeight.w700,
              color: T1ColorsLight.text1,
              letterSpacing: 0.5),
          labelMedium: TextStyle(
              fontFamily: 'Outfit',
              fontWeight: FontWeight.w600,
              color: T1ColorsLight.text2,
              letterSpacing: 0.5),
          labelSmall: TextStyle(
              fontFamily: 'Outfit',
              fontWeight: FontWeight.w600,
              color: T1ColorsLight.text3,
              letterSpacing: 1.0),
        ),
        iconTheme: const IconThemeData(color: T1ColorsLight.navIcon),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: T1ColorsLight.navBg,
          selectedItemColor: T1ColorsLight.primary,
          unselectedItemColor: T1ColorsLight.navIcon,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: T1ColorsLight.navBg,
          indicatorColor: T1ColorsLight.primary.withOpacity(0.15),
          iconTheme: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const IconThemeData(color: T1ColorsLight.primary);
            }
            return const IconThemeData(color: T1ColorsLight.navIcon);
          }),
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const TextStyle(
                fontFamily: 'Outfit',
                fontSize: 8,
                fontWeight: FontWeight.w700,
                color: T1ColorsLight.primary,
              );
            }
            return const TextStyle(
              fontFamily: 'Outfit',
              fontSize: 8,
              fontWeight: FontWeight.w700,
              color: T1ColorsLight.navLabel,
            );
          }),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: T1ColorsLight.bgCard,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: T1ColorsLight.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: T1ColorsLight.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                const BorderSide(color: T1ColorsLight.primary, width: 1.5),
          ),
          hintStyle:
              const TextStyle(color: T1ColorsLight.text3, fontFamily: 'Outfit'),
          labelStyle:
              const TextStyle(color: T1ColorsLight.text2, fontFamily: 'Outfit'),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: T1ColorsLight.primary,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontFamily: 'Outfit',
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: T1ColorsLight.primary,
            side: const BorderSide(color: T1ColorsLight.border),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontFamily: 'Outfit',
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: T1ColorsLight.primary,
            textStyle: const TextStyle(
              fontFamily: 'Outfit',
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        switchTheme: SwitchThemeData(
          thumbColor: WidgetStateProperty.resolveWith((s) =>
              s.contains(WidgetState.selected)
                  ? T1ColorsLight.primary
                  : Colors.white),
          trackColor: WidgetStateProperty.resolveWith((s) =>
              s.contains(WidgetState.selected)
                  ? T1ColorsLight.primary.withOpacity(0.4)
                  : T1ColorsLight.border),
        ),
        checkboxTheme: CheckboxThemeData(
          fillColor: WidgetStateProperty.resolveWith((s) =>
              s.contains(WidgetState.selected)
                  ? T1ColorsLight.primary
                  : Colors.transparent),
          checkColor: WidgetStateProperty.all(Colors.white),
          side: const BorderSide(color: T1ColorsLight.border, width: 1.5),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: T1ColorsLight.tagNormalBg,
          selectedColor: T1ColorsLight.primary.withOpacity(0.15),
          disabledColor: T1ColorsLight.bgCard,
          labelStyle: const TextStyle(
              fontFamily: 'Outfit', color: T1ColorsLight.text2, fontSize: 11),
          side: const BorderSide(color: T1ColorsLight.border),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: T1ColorsLight.primary,
          linearTrackColor: T1ColorsLight.border,
          circularTrackColor: T1ColorsLight.border,
        ),
      );
    } catch (_) {
      // Isolation safety net — if light theme construction fails for any
      // reason, return a plain light theme. This can NEVER affect darkTheme.
      return ThemeData.light();
    }
  }
}
