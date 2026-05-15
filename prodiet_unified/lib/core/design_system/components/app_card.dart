import 'package:flutter/material.dart';
import 'package:prodiet_unified/core/design_system/tokens/design_tokens.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final double? radius;
  final VoidCallback? onTap;
  final List<BoxShadow>? shadow;
  final BorderSide? border;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.color,
    this.radius,
    this.onTap,
    this.shadow,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    
    Widget content = Padding(
      padding: padding ?? EdgeInsets.all(tokens.spacing.md),
      child: child,
    );

    if (onTap != null) {
      content = InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(radius ?? tokens.radius.lg),
        child: content,
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: color ?? tokens.colors.surface,
        borderRadius: BorderRadius.circular(radius ?? tokens.radius.lg),
        border: border != null ? Border.fromBorderSide(border!) : null,
        boxShadow: shadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: content,
      ),
    );
  }
}
