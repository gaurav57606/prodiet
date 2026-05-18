import 'package:flutter/material.dart';
import '../tokens/app_theme_tokens.dart';

class AppBadge extends StatelessWidget {
  final String label;
  final Color? backgroundColor;
  final Color? textColor;

  const AppBadge({
    super.key,
    required this.label,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    
    final effectiveBgColor = backgroundColor ?? tokens.colors.primary.withValues(alpha: 0.1);
    final effectiveTextColor = textColor ?? tokens.colors.primary;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: tokens.spacing.sm,
        vertical: tokens.spacing.xs / 2,
      ),
      decoration: BoxDecoration(
        color: effectiveBgColor,
        borderRadius: BorderRadius.circular(tokens.radius.xs),
      ),
      child: Text(
        label,
        style: tokens.typography.labelSmall.copyWith(
          color: effectiveTextColor,
          fontWeight: FontWeight.w800,
          fontSize: 10,
        ),
      ),
    );
  }
}
