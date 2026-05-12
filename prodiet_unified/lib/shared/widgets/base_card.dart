import 'package:flutter/material.dart';
import 'package:prodiet_unified/core/design_system/radius.dart';
import 'package:prodiet_unified/core/design_system/spacing.dart';

class BaseCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? borderRadius;
  final Color? color;
  final BorderSide? borderSide;
  final List<BoxShadow>? boxShadow;
  final VoidCallback? onTap;
  final Clip clipBehavior;

  const BaseCard({
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius,
    this.color,
    this.borderSide,
    this.boxShadow,
    this.onTap,
    this.clipBehavior = Clip.antiAlias,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveRadius = borderRadius ?? AppRadius.lg;

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: color ?? theme.cardTheme.color,
        borderRadius: BorderRadius.circular(effectiveRadius),
        border: borderSide != null ? Border.fromBorderSide(borderSide!) : null,
        boxShadow: boxShadow,
      ),
      child: Material(
        color: Colors.transparent,
        clipBehavior: clipBehavior,
        borderRadius: BorderRadius.circular(effectiveRadius),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(effectiveRadius),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(AppSpacing.md),
            child: child,
          ),
        ),
      ),
    );
  }
}
