import 'package:flutter/material.dart';
import 'package:prodiet_unified/core/theme/pro_diet_theme_extension.dart';

class AppSectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onAction;
  final String? actionLabel;
  final EdgeInsetsGeometry? padding;

  const AppSectionHeader({
    super.key,
    required this.title,
    this.onAction,
    this.actionLabel,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<ProDietThemeExtension>()!;
    
    return Padding(
      padding: padding ?? const EdgeInsets.fromLTRB(24, 24, 24, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title.toUpperCase(),
            style: ext.sectionLabelStyle,
          ),
          if (onAction != null)
            GestureDetector(
              onTap: onAction,
              child: Text(
                actionLabel ?? 'Full view',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
