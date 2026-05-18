import 'package:flutter/material.dart';
import '../tokens/app_theme_tokens.dart';
import 'app_button.dart';

class AppDialog extends StatelessWidget {
  final String title;
  final String message;
  final String? primaryActionLabel;
  final VoidCallback? onPrimaryAction;
  final String? secondaryActionLabel;
  final VoidCallback? onSecondaryAction;
  final Widget? content;

  const AppDialog({
    super.key,
    required this.title,
    required this.message,
    this.primaryActionLabel,
    this.onPrimaryAction,
    this.secondaryActionLabel,
    this.onSecondaryAction,
    this.content,
  });

  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required String message,
    String? primaryActionLabel,
    VoidCallback? onPrimaryAction,
    String? secondaryActionLabel,
    VoidCallback? onSecondaryAction,
    Widget? content,
  }) {
    return showDialog<T>(
      context: context,
      builder: (context) => AppDialog(
        title: title,
        message: message,
        primaryActionLabel: primaryActionLabel,
        onPrimaryAction: onPrimaryAction,
        secondaryActionLabel: secondaryActionLabel,
        onSecondaryAction: onSecondaryAction,
        content: content,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Dialog(
      backgroundColor: tokens.colors.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(tokens.radius.lg),
      ),
      child: Padding(
        padding: EdgeInsets.all(tokens.spacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: tokens.typography.headlineSmall.copyWith(
                color: tokens.colors.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: tokens.spacing.sm),
            Text(
              message,
              style: tokens.typography.bodyMedium.copyWith(
                color: tokens.colors.onSurface.withValues(alpha: 0.7),
              ),
            ),
            if (content != null) ...[
              SizedBox(height: tokens.spacing.md),
              content!,
            ],
            SizedBox(height: tokens.spacing.xl),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (secondaryActionLabel != null)
                  TextButton(
                    onPressed: onSecondaryAction ?? () => Navigator.pop(context),
                    child: Text(
                      secondaryActionLabel!,
                      style: tokens.typography.labelLarge.copyWith(
                        color: tokens.colors.primary,
                      ),
                    ),
                  ),
                if (primaryActionLabel != null) ...[
                  SizedBox(width: tokens.spacing.sm),
                  AppButton(
                    label: primaryActionLabel!,
                    onPressed: onPrimaryAction,
                    width: 120,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
