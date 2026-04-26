import 'package:flutter/material.dart';
import '../../core/theme/app_spacing.dart';

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
    final theme = Theme.of(context);
    
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(borderRadius ?? AppSpacing.radiusLarge),
        border: borderSide != null 
          ? Border.fromBorderSide(borderSide!) 
          : Border.all(color: theme.colorScheme.outline, width: 1),
        boxShadow: boxShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius ?? AppSpacing.radiusLarge),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(AppSpacing.md),
            child: child,
          ),
        ),
      ),
    );
  }
}
