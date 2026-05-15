import 'package:flutter/material.dart';

class AppMotion {
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration normal = Duration(milliseconds: 350);
  static const Duration slow = Duration(milliseconds: 500);

  static const Curve standard = Curves.easeInOutCubic;
  static const Curve emphasize = Curves.elasticOut;
  static const Curve smooth = Curves.fastOutSlowIn;
}
