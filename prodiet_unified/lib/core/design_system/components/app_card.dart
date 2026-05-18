import 'package:flutter/material.dart';
import '../tokens/app_theme_tokens.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final double? radius;
  final VoidCallback? onTap;
  final List<BoxShadow>? shadow;
  final BorderSide? border;
  final Clip clipBehavior;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.color,
    this.radius,
    this.onTap,
    this.shadow,
    this.border,
    this.clipBehavior = Clip.antiAlias,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    
    final effectiveRadius = radius ?? tokens.radius.card;
    final effectiveColor = color ?? tokens.colors.surface;
    final effectiveShadow = shadow ?? tokens.shadows.low;

    Widget content = Padding(
      padding: padding ?? EdgeInsets.all(tokens.spacing.md),
      child: child,
    );

    if (onTap != null) {
      content = InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(effectiveRadius),
        child: content,
      );
    }

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: effectiveColor,
        borderRadius: BorderRadius.circular(effectiveRadius),
        border: border != null ? Border.fromBorderSide(border!) : Border.all(
          color: tokens.colors.primary.withValues(alpha: 0.1),
          width: 1,
        ),
        boxShadow: effectiveShadow,
      ),
      child: Material(
        color: Colors.transparent,
        clipBehavior: clipBehavior,
        borderRadius: BorderRadius.circular(effectiveRadius),
        child: content,
      ),
    );
  }
}

