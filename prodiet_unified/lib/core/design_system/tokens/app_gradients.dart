import 'package:flutter/material.dart';

class AppGradients {
  final List<Color> brand;
  final List<Color> calories;
  final List<Color> protein;
  final List<Color> carbs;
  final List<Color> fat;
  final List<Color> water;
  final List<Color> activity;
  final List<Color> hero;

  const AppGradients({
    required this.brand,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.water,
    required this.activity,
    required this.hero,
  });

  AppGradients lerp(AppGradients other, double t) {
    return AppGradients(
      brand: _lerpColorList(brand, other.brand, t),
      calories: _lerpColorList(calories, other.calories, t),
      protein: _lerpColorList(protein, other.protein, t),
      carbs: _lerpColorList(carbs, other.carbs, t),
      fat: _lerpColorList(fat, other.fat, t),
      water: _lerpColorList(water, other.water, t),
      activity: _lerpColorList(activity, other.activity, t),
      hero: _lerpColorList(hero, other.hero, t),
    );
  }

  AppGradients copyWith({
    List<Color>? brand,
    List<Color>? calories,
    List<Color>? protein,
    List<Color>? carbs,
    List<Color>? fat,
    List<Color>? water,
    List<Color>? activity,
    List<Color>? hero,
  }) {
    return AppGradients(
      brand: brand ?? this.brand,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fat: fat ?? this.fat,
      water: water ?? this.water,
      activity: activity ?? this.activity,
      hero: hero ?? this.hero,
    );
  }

  static List<Color> _lerpColorList(List<Color> a, List<Color> b, double t) {
    if (a.length != b.length) return t < 0.5 ? a : b;
    return List.generate(a.length, (i) => Color.lerp(a[i], b[i], t)!);
  }
}
