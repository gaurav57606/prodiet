import 'package:flutter/material.dart';
import 'package:prodiet_unified/core/theme/pro_diet_theme_extension.dart';

class AppSectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  const AppSectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<ProDietThemeExtension>()!;

    return Row(
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
              actionLabel ?? 'Full view ›',
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ),
      ],
    );
  }
}
