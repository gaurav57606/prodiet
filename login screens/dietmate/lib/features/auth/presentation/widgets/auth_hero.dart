import 'package:flutter/material.dart';
import 'package:dietmate/core/constants/app_constants.dart';
import 'package:dietmate/core/theme/app_spacing.dart';
import 'package:dietmate/core/utils/extensions.dart';

class AuthHero extends StatelessWidget {
  final String? title;
  final String? subtitle;

  const AuthHero({
    super.key,
    this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 60, bottom: 40, left: 28, right: 28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primary.withValues(alpha: 0.15),
            colorScheme.background,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              gradient: LinearGradient(
                colors: [
                  colorScheme.primary.withValues(alpha: 0.2),
                  colorScheme.primary.withValues(alpha: 0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(color: colorScheme.primary.withValues(alpha: 0.3)),
            ),
            child: Icon(Icons.auto_awesome_rounded, color: colorScheme.primary, size: 36),
          ),
          const SizedBox(height: AppSpacing.md),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: textTheme.displayMedium,
              children: [
                TextSpan(text: title ?? 'Diet'),
                TextSpan(
                  text: 'Master',
                  style: TextStyle(color: colorScheme.primary),
                ),
                if (title == null) const TextSpan(text: ' Pro'),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            subtitle ?? AppConstants.appTagline,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

