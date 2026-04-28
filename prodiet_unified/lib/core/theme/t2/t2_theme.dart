// T2 THEME — exact copy of theme2/app_theme.dart
import 'package:flutter/material.dart';
import 't2_colors.dart';
import 't2_text_styles.dart';
import 't2_spacing.dart';

class T2Theme {
  static ThemeData get light => _buildTheme(t2LightScheme);
  static ThemeData get dark => _buildTheme(t2DarkScheme);
  static ThemeData get amoled => _buildTheme(t2AmoledScheme);

  static ThemeData _buildTheme(ColorScheme colorScheme) {
    final textTheme = T2TextStyles.getTextTheme(colorScheme);
    
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      textTheme: textTheme,
      
      cardTheme: CardThemeData(
        color: colorScheme.surfaceContainerHighest,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(T2Spacing.radiusLarge),
          side: BorderSide(color: colorScheme.outline, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: textTheme.headlineLarge,
      ),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colorScheme.surface,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurfaceVariant,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: textTheme.labelSmall,
        unselectedLabelStyle: textTheme.labelSmall,
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(T2Spacing.radiusMedium),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(T2Spacing.radiusMedium),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(T2Spacing.radiusMedium),
          borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
        ),
        hintStyle: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(T2Spacing.radiusSmall),
          ),
          textStyle: textTheme.titleMedium,
        ),
      ),
    );
  }
}
