import 'package:flutter/material.dart';
import 'package:prodiet_unified/core/theme/t1/t1_spacing.dart';
import 'package:prodiet_unified/shared/widgets/base_card.dart';

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

    final List<BoxShadow>? effectiveBoxShadow = elevation != null && elevation! > 0
        ? [
            BoxShadow(
              color: theme.colorScheme.shadow.withValues(alpha: 0.1),
              blurRadius: elevation! * 2,
              offset: Offset(0, elevation!),
            )
          ]
        : null;

    final effectiveRadius = borderRadius ?? T1Spacing.radiusXl;

    return BaseCard(
      color: color ?? theme.cardTheme.color,
      borderRadius: effectiveRadius,
      borderSide: side,
      boxShadow: effectiveBoxShadow,
      margin: margin,
      padding: EdgeInsets.zero, // Padding handled by internal child
      onTap: onTap,
      child: Stack(
        children: [
          Padding(
            padding: padding ?? const EdgeInsets.all(T1Spacing.md),
            child: child,
          ),
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
                    isDark ? theme.colorScheme.onSurface.withValues(alpha: 0.12) : theme.colorScheme.onSurface.withValues(alpha: 0.05),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
