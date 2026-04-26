import 'package:flutter/material.dart';
import 'package:dietmate/core/theme/app_spacing.dart';
import 'package:dietmate/core/utils/extensions.dart';

class DmCard extends StatelessWidget {
  final Widget child;
  final double padding;
  final double? borderRadius;
  final double elevation;
  final VoidCallback? onTap;
  final Color? color;
  final BorderSide? borderSide;

  const DmCard({
    super.key,
    required this.child,
    this.padding = AppSpacing.md,
    this.borderRadius,
    this.elevation = 0,
    this.onTap,
    this.color,
    this.borderSide,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(borderRadius ?? 16),
      child: Container(
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
          color: color ?? context.colorScheme.surface,
          borderRadius: BorderRadius.circular(borderRadius ?? 16),
          border: Border.fromBorderSide(
            borderSide ?? BorderSide(color: context.colorScheme.outline, width: 1),
          ),
          boxShadow: elevation > 0
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: elevation * 2,
                    offset: Offset(0, elevation),
                  )
                ]
              : null,
        ),
        child: child,
      ),
    );
  }
}

