import 'package:flutter/material.dart';
import 'package:prodiet_unified/core/theme/pro_diet_theme_extension.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final VoidCallback? onTap;
  final double? radius;
  final bool showBorder;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.color,
    this.onTap,
    this.radius,
    this.showBorder = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<ProDietThemeExtension>()!;

    return Container(
      decoration: BoxDecoration(
        color: color ?? theme.cardColor,
        borderRadius: BorderRadius.circular(radius ?? ext.cardRadius),
        border: showBorder ? Border.fromBorderSide(ext.cardBorder) : null,
        boxShadow: [
          BoxShadow(
            color: ext.shadowColor.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(radius ?? ext.cardRadius),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(16.0),
            child: child,
          ),
        ),
      ),
    );
  }
}
