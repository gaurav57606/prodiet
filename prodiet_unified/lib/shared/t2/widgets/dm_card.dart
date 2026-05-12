import 'package:flutter/material.dart';
import 'package:prodiet_unified/core/theme/t2/t2_spacing.dart';
import 'package:prodiet_unified/shared/widgets/base_card.dart';

class DmCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;
  final Color? backgroundColor;
  final BorderSide? borderSide;
  final VoidCallback? onTap;
  final List<BoxShadow>? boxShadow;

  const DmCard({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius,
    this.backgroundColor,
    this.borderSide,
    this.onTap,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    return BaseCard(
      color: backgroundColor,
      borderRadius: borderRadius ?? T2Spacing.radiusLarge,
      borderSide: borderSide ?? BorderSide(color: Theme.of(context).colorScheme.outline, width: 1),
      boxShadow: boxShadow,
      padding: padding ?? const EdgeInsets.all(T2Spacing.md),
      onTap: onTap,
      child: child,
    );
  }
}
