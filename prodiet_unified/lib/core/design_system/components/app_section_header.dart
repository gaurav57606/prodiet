import 'package:flutter/material.dart';
import '../tokens/app_theme_tokens.dart';

class AppSectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;
  final EdgeInsetsGeometry? padding;

  const AppSectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title.toUpperCase(),
            style: tokens.typography.labelSmall.copyWith(
              color: tokens.colors.onSurface.withValues(alpha: 0.5),
              letterSpacing: 1.2,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (onAction != null)
            GestureDetector(
              onTap: onAction,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  actionLabel ?? 'Full view ›',
                  style: tokens.typography.labelLarge.copyWith(
                    color: tokens.colors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
