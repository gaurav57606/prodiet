
class AppSpacing {
  final double xs;
  final double sm;
  final double md;
  final double lg;
  final double xl;
  final double xxl;

  const AppSpacing({
    required this.xs,
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
    required this.xxl,
  });

  AppSpacing lerp(AppSpacing other, double t) {
    return AppSpacing(
      xs: lerpDouble(xs, other.xs, t)!,
      sm: lerpDouble(sm, other.sm, t)!,
      md: lerpDouble(md, other.md, t)!,
      lg: lerpDouble(lg, other.lg, t)!,
      xl: lerpDouble(xl, other.xl, t)!,
      xxl: lerpDouble(xxl, other.xxl, t)!,
    );
  }

  AppSpacing copyWith({
    double? xs,
    double? sm,
    double? md,
    double? lg,
    double? xl,
    double? xxl,
  }) {
    return AppSpacing(
      xs: xs ?? this.xs,
      sm: sm ?? this.sm,
      md: md ?? this.md,
      lg: lg ?? this.lg,
      xl: xl ?? this.xl,
      xxl: xxl ?? this.xxl,
    );
  }

  static double? lerpDouble(double? a, double? b, double t) {
    if (a == null && b == null) return null;
    if (a == null) return b;
    if (b == null) return a;
    return a + (b - a) * t;
  }
}
