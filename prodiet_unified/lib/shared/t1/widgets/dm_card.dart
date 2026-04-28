import 'package:flutter/material.dart';
import 'package:prodiet_unified/core/theme/t1/t1_spacing.dart';

class DmCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;
  final double? elevation;
  final VoidCallback? onTap;
  final Color? color;
  final BorderSide? borderSide;

  final EdgeInsetsGeometry? margin;

  const DmCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius,
    this.elevation,
    this.onTap,
    this.color,
    this.borderSide,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final shape = theme.cardTheme.shape;
    final BorderSide side = borderSide ?? (shape is RoundedRectangleBorder ? shape.side : BorderSide.none);

    Widget cardContent = Container(
      margin: margin,
      padding: padding ?? const EdgeInsets.all(T1Spacing.md),
      decoration: BoxDecoration(
        color: color ?? theme.cardTheme.color,
        borderRadius: BorderRadius.circular(borderRadius ?? T1Spacing.radiusXl),
        border: Border.fromBorderSide(side),
        boxShadow: elevation != null && elevation! > 0
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: elevation! * 2,
                  offset: Offset(0, elevation!),
                )
              ]
            : null,
      ),
      child: child,
    );

    // Add glass effect shine overlay similar to HTML ::before
    cardContent = ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius ?? T1Spacing.radiusXl),
      child: Stack(
        children: [
          cardContent,
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 1,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    isDark ? Colors.white.withOpacity(0.12) : Colors.white.withOpacity(0.9),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius ?? T1Spacing.radiusXl),
        child: cardContent,
      );
    }

    return cardContent;
  }
}
