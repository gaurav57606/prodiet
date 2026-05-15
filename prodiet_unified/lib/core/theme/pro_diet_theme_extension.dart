import 'package:flutter/material.dart';

class ProDietThemeExtension extends ThemeExtension<ProDietThemeExtension> {
  final double cardRadius;
  final double buttonRadius;
  final Color cardBackground;
  final BorderSide cardBorder;
  final TextStyle sectionLabelStyle;
  final List<Color> brandGradient;
  final Color macroCalories;
  final Color macroProtein;
  final Color macroCarbs;
  final Color macroFat;
  final List<Color> macroCaloriesGradient;
  final List<Color> macroProteinGradient;
  final List<Color> macroCarbsGradient;
  final List<Color> macroFatGradient;
  final Color water;
  final List<Color> waterGradient;
  final Color activity;
  final List<Color> activityGradient;
  final LinearGradient heroGradient;
  final Color shadowColor;

  const ProDietThemeExtension({
    required this.cardRadius,
    required this.buttonRadius,
    required this.cardBackground,
    required this.cardBorder,
    required this.sectionLabelStyle,
    required this.brandGradient,
    required this.macroCalories,
    required this.macroProtein,
    required this.macroCarbs,
    required this.macroFat,
    required this.macroCaloriesGradient,
    required this.macroProteinGradient,
    required this.macroCarbsGradient,
    required this.macroFatGradient,
    required this.water,
    required this.waterGradient,
    required this.activity,
    required this.activityGradient,
    required this.heroGradient,
    required this.shadowColor,
  });

  @override
  ThemeExtension<ProDietThemeExtension> copyWith({
    double? cardRadius,
    double? buttonRadius,
    Color? cardBackground,
    BorderSide? cardBorder,
    TextStyle? sectionLabelStyle,
    List<Color>? brandGradient,
    Color? macroCalories,
    Color? macroProtein,
    Color? macroCarbs,
    Color? macroFat,
    List<Color>? macroCaloriesGradient,
    List<Color>? macroProteinGradient,
    List<Color>? macroCarbsGradient,
    List<Color>? macroFatGradient,
    Color? water,
    List<Color>? waterGradient,
    Color? activity,
    List<Color>? activityGradient,
    LinearGradient? heroGradient,
    Color? shadowColor,
  }) {
    return ProDietThemeExtension(
      cardRadius: cardRadius ?? this.cardRadius,
      buttonRadius: buttonRadius ?? this.buttonRadius,
      cardBackground: cardBackground ?? this.cardBackground,
      cardBorder: cardBorder ?? this.cardBorder,
      sectionLabelStyle: sectionLabelStyle ?? this.sectionLabelStyle,
      brandGradient: brandGradient ?? this.brandGradient,
      macroCalories: macroCalories ?? this.macroCalories,
      macroProtein: macroProtein ?? this.macroProtein,
      macroCarbs: macroCarbs ?? this.macroCarbs,
      macroFat: macroFat ?? this.macroFat,
      macroCaloriesGradient: macroCaloriesGradient ?? this.macroCaloriesGradient,
      macroProteinGradient: macroProteinGradient ?? this.macroProteinGradient,
      macroCarbsGradient: macroCarbsGradient ?? this.macroCarbsGradient,
      macroFatGradient: macroFatGradient ?? this.macroFatGradient,
      water: water ?? this.water,
      waterGradient: waterGradient ?? this.waterGradient,
      activity: activity ?? this.activity,
      activityGradient: activityGradient ?? this.activityGradient,
      heroGradient: heroGradient ?? this.heroGradient,
      shadowColor: shadowColor ?? this.shadowColor,
    );
  }

  @override
  ThemeExtension<ProDietThemeExtension> lerp(
    ThemeExtension<ProDietThemeExtension>? other,
    double t,
  ) {
    if (other is! ProDietThemeExtension) return this;
    return ProDietThemeExtension(
      cardRadius: lerpDouble(cardRadius, other.cardRadius, t)!,
      buttonRadius: lerpDouble(buttonRadius, other.buttonRadius, t)!,
      cardBackground: Color.lerp(cardBackground, other.cardBackground, t)!,
      cardBorder: BorderSide.lerp(cardBorder, other.cardBorder, t),
      sectionLabelStyle: TextStyle.lerp(sectionLabelStyle, other.sectionLabelStyle, t)!,
      brandGradient: _lerpColorList(brandGradient, other.brandGradient, t),
      macroCalories: Color.lerp(macroCalories, other.macroCalories, t)!,
      macroProtein: Color.lerp(macroProtein, other.macroProtein, t)!,
      macroCarbs: Color.lerp(macroCarbs, other.macroCarbs, t)!,
      macroFat: Color.lerp(macroFat, other.macroFat, t)!,
      macroCaloriesGradient: _lerpColorList(macroCaloriesGradient, other.macroCaloriesGradient, t),
      macroProteinGradient: _lerpColorList(macroProteinGradient, other.macroProteinGradient, t),
      macroCarbsGradient: _lerpColorList(macroCarbsGradient, other.macroCarbsGradient, t),
      macroFatGradient: _lerpColorList(macroFatGradient, other.macroFatGradient, t),
      water: Color.lerp(water, other.water, t)!,
      waterGradient: _lerpColorList(waterGradient, other.waterGradient, t),
      activity: Color.lerp(activity, other.activity, t)!,
      activityGradient: _lerpColorList(activityGradient, other.activityGradient, t),
      heroGradient: LinearGradient.lerp(heroGradient, other.heroGradient, t)!,
      shadowColor: Color.lerp(shadowColor, other.shadowColor, t)!,
    );
  }

  static List<Color> _lerpColorList(List<Color> a, List<Color> b, double t) {
    if (a.length != b.length) return t < 0.5 ? a : b;
    return List.generate(a.length, (i) => Color.lerp(a[i], b[i], t)!);
  }

  static double? lerpDouble(double? a, double? b, double t) {
    if (a == null && b == null) return null;
    if (a == null) return b;
    if (b == null) return a;
    return a + (b - a) * t;
  }
}
