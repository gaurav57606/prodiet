import 'package:flutter/material.dart';
import 'package:prodiet_unified/core/theme/pro_diet_theme_extension.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? borderRadius;
  final Color? color;
  final BorderSide? borderSide;
  final List<BoxShadow>? boxShadow;
  final VoidCallback? onTap;
  final Clip clipBehavior;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius,
    this.color,
    this.borderSide,
    this.boxShadow,
    this.onTap,
    this.clipBehavior = Clip.antiAlias,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<ProDietThemeExtension>()!;
    
    final effectiveRadius = borderRadius ?? ext.cardRadius;
    final effectiveColor = color ?? ext.cardBackground;
    final effectiveBorder = borderSide ?? ext.cardBorder;

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: effectiveColor,
        borderRadius: BorderRadius.circular(effectiveRadius),
        border: Border.fromBorderSide(effectiveBorder),
        boxShadow: boxShadow ?? [
          BoxShadow(
            color: ext.shadowColor.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        clipBehavior: clipBehavior,
        borderRadius: BorderRadius.circular(effectiveRadius),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(effectiveRadius),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(16.0),
            child: child,
          ),
        ),
      ),
    );
  }
}
