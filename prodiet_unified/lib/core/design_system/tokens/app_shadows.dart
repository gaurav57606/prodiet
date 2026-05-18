import 'package:flutter/material.dart';

class AppShadows {
  final List<BoxShadow> low;
  final List<BoxShadow> medium;
  final List<BoxShadow> high;

  const AppShadows({
    required this.low,
    required this.medium,
    required this.high,
  });

  AppShadows lerp(AppShadows other, double t) {
    return AppShadows(
      low: BoxShadow.lerpList(low, other.low, t)!,
      medium: BoxShadow.lerpList(medium, other.medium, t)!,
      high: BoxShadow.lerpList(high, other.high, t)!,
    );
  }

  AppShadows copyWith({
    List<BoxShadow>? low,
    List<BoxShadow>? medium,
    List<BoxShadow>? high,
  }) {
    return AppShadows(
      low: low ?? this.low,
      medium: medium ?? this.medium,
      high: high ?? this.high,
    );
  }
}
