import 'package:flutter/material.dart';
import 'color_schemes.dart';
import 'text_styles.dart';
import 'app_spacing.dart';
import 'app_colors_light.dart';

class AppTheme {
  static ThemeData buildTheme(ColorScheme scheme) {
    final tt = AppTextStyles.getTextTheme(scheme);
    
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
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
          side: BorderSide(
            color: scheme.primary.withOpacity(0.12),
            width: 1.0,
          ),
        ),
        margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
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
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
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
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: BorderSide(
            color: scheme.primary.withOpacity(0.15),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: BorderSide(color: scheme.primary, width: 1.5),
        ),
        hintStyle: tt.bodyMedium?.copyWith(
          color: scheme.onSurface.withOpacity(0.35),
        ),
      ),
    );
  }

  static ThemeData get darkTheme => buildTheme(AppColorSchemes.darkScheme);
  static ThemeData get amoledTheme => buildTheme(AppColorSchemes.amoledScheme);

  static ThemeData get lightTheme {
    try {
      return ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        fontFamily: 'Outfit',
        scaffoldBackgroundColor: AppColorsLight.bgPage,

        colorScheme: ColorScheme(
          brightness:               Brightness.light,

          // Surfaces
          surface:                  AppColorsLight.bgPage,
          surfaceContainerHighest:  AppColorsLight.bgElevated,
          onSurface:                AppColorsLight.text1,
          onSurfaceVariant:         AppColorsLight.text2,

          // Primary
          primary:                  AppColorsLight.primary,
          onPrimary:                Colors.white,
          primaryContainer:         AppColorsLight.bgCard,
          onPrimaryContainer:       AppColorsLight.text1,

          // Secondary
          secondary:                AppColorsLight.alertGreen,
          onSecondary:              Colors.white,
          secondaryContainer:       AppColorsLight.alertGreenBg,
          onSecondaryContainer:     AppColorsLight.alertGreen,

          // Error
          error:                    AppColorsLight.alertAmber,
          onError:                  Colors.white,
          errorContainer:           AppColorsLight.alertAmberBg,
          onErrorContainer:         AppColorsLight.alertAmber,

          // Background (deprecated but still used in M3)
          background:               AppColorsLight.bgPage,
          onBackground:             AppColorsLight.text1,

          // Outline / border
          outline:                  AppColorsLight.border,
          outlineVariant:           AppColorsLight.phoneBorder,

          // Inverse
          inverseSurface:           AppColorsLight.text1,
          onInverseSurface:         AppColorsLight.bgPage,
          inversePrimary:           AppColorsLight.primaryLight,

          // Scrim / shadow
          scrim:                    Colors.black,
          shadow:                   Colors.black,
        ),

        cardTheme: CardThemeData(
          color:        AppColorsLight.bgCard,
          elevation:    0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: BorderSide(color: AppColorsLight.border, width: 1),
          ),
        ),

        dividerTheme: DividerThemeData(
          color:     AppColorsLight.border,
          thickness: 1,
        ),

        appBarTheme: AppBarTheme(
          backgroundColor:  AppColorsLight.bgPage,
          foregroundColor:  AppColorsLight.text1,
          elevation:        0,
          iconTheme:        IconThemeData(color: AppColorsLight.text1),
          titleTextStyle: TextStyle(
            fontFamily:  'Outfit',
            fontWeight:  FontWeight.w800,
            fontSize:    20,
            color:       AppColorsLight.text1,
            letterSpacing: -0.3,
          ),
        ),

        textTheme: TextTheme(
          displayLarge:  TextStyle(fontFamily:'Outfit', fontWeight:FontWeight.w800, color:AppColorsLight.text1),
          displayMedium: TextStyle(fontFamily:'Outfit', fontWeight:FontWeight.w800, color:AppColorsLight.text1),
          displaySmall:  TextStyle(fontFamily:'Outfit', fontWeight:FontWeight.w800, color:AppColorsLight.text1),
          headlineLarge: TextStyle(fontFamily:'Outfit', fontWeight:FontWeight.w800, color:AppColorsLight.text1),
          headlineMedium:TextStyle(fontFamily:'Outfit', fontWeight:FontWeight.w700, color:AppColorsLight.text1),
          headlineSmall: TextStyle(fontFamily:'Outfit', fontWeight:FontWeight.w700, color:AppColorsLight.text1),
          titleLarge:    TextStyle(fontFamily:'Outfit', fontWeight:FontWeight.w700, color:AppColorsLight.text1),
          titleMedium:   TextStyle(fontFamily:'Outfit', fontWeight:FontWeight.w600, color:AppColorsLight.text1),
          titleSmall:    TextStyle(fontFamily:'Outfit', fontWeight:FontWeight.w600, color:AppColorsLight.text2),
          bodyLarge:     TextStyle(fontFamily:'Outfit', fontWeight:FontWeight.w500, color:AppColorsLight.text1),
          bodyMedium:    TextStyle(fontFamily:'Outfit', fontWeight:FontWeight.w400, color:AppColorsLight.text2),
          bodySmall:     TextStyle(fontFamily:'Outfit', fontWeight:FontWeight.w400, color:AppColorsLight.text3),
          labelLarge:    TextStyle(fontFamily:'Outfit', fontWeight:FontWeight.w700, color:AppColorsLight.text1, letterSpacing:0.5),
          labelMedium:   TextStyle(fontFamily:'Outfit', fontWeight:FontWeight.w600, color:AppColorsLight.text2, letterSpacing:0.5),
          labelSmall:    TextStyle(fontFamily:'Outfit', fontWeight:FontWeight.w600, color:AppColorsLight.text3, letterSpacing:1.0),
        ),

        iconTheme: IconThemeData(color: AppColorsLight.navIcon),

        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor:      AppColorsLight.navBg,
          selectedItemColor:    AppColorsLight.primary,
          unselectedItemColor:  AppColorsLight.navIcon,
          elevation:            0,
          type: BottomNavigationBarType.fixed,
        ),

        navigationBarTheme: NavigationBarThemeData(
          backgroundColor:      AppColorsLight.navBg,
          indicatorColor:       AppColorsLight.primary.withOpacity(0.15),
          iconTheme: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return IconThemeData(color: AppColorsLight.primary);
            }
            return IconThemeData(color: AppColorsLight.navIcon);
          }),
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return TextStyle(
                fontFamily: 'Outfit', fontSize: 8, fontWeight: FontWeight.w700,
                color: AppColorsLight.primary,
              );
            }
            return TextStyle(
              fontFamily: 'Outfit', fontSize: 8, fontWeight: FontWeight.w700,
              color: AppColorsLight.navLabel,
            );
          }),
        ),

        inputDecorationTheme: InputDecorationTheme(
          filled:      true,
          fillColor:   AppColorsLight.bgCard,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColorsLight.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColorsLight.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColorsLight.primary, width: 1.5),
          ),
          hintStyle: TextStyle(color: AppColorsLight.text3, fontFamily: 'Outfit'),
          labelStyle: TextStyle(color: AppColorsLight.text2, fontFamily: 'Outfit'),
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor:   AppColorsLight.primary,
            foregroundColor:   Colors.white,
            elevation:         0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontFamily: 'Outfit', fontWeight: FontWeight.w700,
            ),
          ),
        ),

        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColorsLight.primary,
            side:            BorderSide(color: AppColorsLight.border),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontFamily: 'Outfit', fontWeight: FontWeight.w700,
            ),
          ),
        ),

        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColorsLight.primary,
            textStyle: const TextStyle(
              fontFamily: 'Outfit', fontWeight: FontWeight.w700,
            ),
          ),
        ),

        switchTheme: SwitchThemeData(
          thumbColor: WidgetStateProperty.resolveWith((s) =>
            s.contains(WidgetState.selected) ? AppColorsLight.primary : Colors.white),
          trackColor: WidgetStateProperty.resolveWith((s) =>
            s.contains(WidgetState.selected)
              ? AppColorsLight.primary.withOpacity(0.4)
              : AppColorsLight.border),
        ),

        checkboxTheme: CheckboxThemeData(
          fillColor: WidgetStateProperty.resolveWith((s) =>
            s.contains(WidgetState.selected) ? AppColorsLight.primary : Colors.transparent),
          checkColor: WidgetStateProperty.all(Colors.white),
          side: BorderSide(color: AppColorsLight.border, width: 1.5),
        ),

        chipTheme: ChipThemeData(
          backgroundColor:   AppColorsLight.tagNormalBg,
          selectedColor:     AppColorsLight.primary.withOpacity(0.15),
          disabledColor:     AppColorsLight.bgCard,
          labelStyle:        TextStyle(fontFamily:'Outfit', color:AppColorsLight.text2, fontSize:11),
          side:              BorderSide(color: AppColorsLight.border),
          shape:             RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),

        progressIndicatorTheme: ProgressIndicatorThemeData(
          color:                AppColorsLight.primary,
          linearTrackColor:     AppColorsLight.border,
          circularTrackColor:   AppColorsLight.border,
        ),
      );
    } catch (_) {
      // Isolation safety net — if light theme construction fails for any
      // reason, return a plain light theme. This can NEVER affect darkTheme.
      return ThemeData.light();
    }
  }
}
