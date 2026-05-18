import 'package:flutter/material.dart';
import '../tokens/app_theme_tokens.dart';

class AppLoader extends StatelessWidget {
  final String? message;
  final bool isOverlay;

  const AppLoader({
    super.key,
    this.message,
    this.isOverlay = false,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    final loader = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(tokens.colors.primary),
          strokeWidth: 3,
        ),
        if (message != null) ...[
          SizedBox(height: tokens.spacing.md),
          Text(
            message!,
            style: tokens.typography.bodyMedium.copyWith(
              color: tokens.colors.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ],
      ],
    );

    if (!isOverlay) return loader;

    return Container(
      color: tokens.colors.background.withValues(alpha: 0.8),
      child: Center(
        child: loader,
      ),
    );
  }
}
