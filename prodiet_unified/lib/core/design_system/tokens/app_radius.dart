
class AppRadius {
  final double xs;
  final double sm;
  final double md;
  final double lg;
  final double xl;
  final double button;
  final double card;

  const AppRadius({
    required this.xs,
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
    required this.button,
    required this.card,
  });

  AppRadius lerp(AppRadius other, double t) {
    return AppRadius(
      xs: lerpDouble(xs, other.xs, t)!,
      sm: lerpDouble(sm, other.sm, t)!,
      md: lerpDouble(md, other.md, t)!,
      lg: lerpDouble(lg, other.lg, t)!,
      xl: lerpDouble(xl, other.xl, t)!,
      button: lerpDouble(button, other.button, t)!,
      card: lerpDouble(card, other.card, t)!,
    );
  }

  AppRadius copyWith({
    double? xs,
    double? sm,
    double? md,
    double? lg,
    double? xl,
    double? button,
    double? card,
  }) {
    return AppRadius(
      xs: xs ?? this.xs,
      sm: sm ?? this.sm,
      md: md ?? this.md,
      lg: lg ?? this.lg,
      xl: xl ?? this.xl,
      button: button ?? this.button,
      card: card ?? this.card,
    );
  }


  static double? lerpDouble(double? a, double? b, double t) {
    if (a == null && b == null) return null;
    if (a == null) return b;
    if (b == null) return a;
    return a + (b - a) * t;
  }
}
