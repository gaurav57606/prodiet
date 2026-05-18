import 'package:flutter/material.dart';
import '../tokens/app_theme_tokens.dart';

class AppHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<Widget>? actions;
  final bool showBackButton;
  final VoidCallback? onBack;

  const AppHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.actions,
    this.showBackButton = false,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Container(
      padding: EdgeInsets.fromLTRB(
        tokens.spacing.lg,
        tokens.spacing.xl,
        tokens.spacing.lg,
        tokens.spacing.md,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (showBackButton)
                  GestureDetector(
                    onTap: onBack ?? () => Navigator.pop(context),
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      size: 20,
                      color: tokens.colors.onSurface,
                    ),
                  ),
                if (showBackButton) SizedBox(height: tokens.spacing.sm),
                Text(
                  title,
                  style: tokens.typography.headlineMedium.copyWith(
                    color: tokens.colors.onSurface,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                if (subtitle != null) ...[
                  SizedBox(height: tokens.spacing.xs),
                  Text(
                    subtitle!,
                    style: tokens.typography.bodySmall.copyWith(
                      color: tokens.colors.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (actions != null)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: actions!,
            ),
        ],
      ),
    );
  }
}
