import 'package:flutter/material.dart';
import '../tokens/app_theme_tokens.dart';

class AppModal extends StatelessWidget {
  final String? title;
  final Widget child;
  final List<Widget>? actions;

  const AppModal({
    super.key,
    this.title,
    required this.child,
    this.actions,
  });

  static Future<T?> show<T>({
    required BuildContext context,
    String? title,
    required Widget child,
    List<Widget>? actions,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AppModal(
        title: title,
        actions: actions,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: BoxDecoration(
        color: tokens.colors.background,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(tokens.radius.xl),
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        tokens.spacing.lg,
        tokens.spacing.md,
        tokens.spacing.lg,
        tokens.spacing.lg + bottomPadding,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: tokens.colors.onSurface.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(tokens.radius.xs),
              ),
            ),
          ),
          SizedBox(height: tokens.spacing.lg),
          if (title != null) ...[
            Text(
              title!,
              style: tokens.typography.headlineSmall.copyWith(
                color: tokens.colors.onSurface,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: tokens.spacing.lg),
          ],
          Flexible(child: child),
          if (actions != null && actions!.isNotEmpty) ...[
            SizedBox(height: tokens.spacing.xl),
            ...actions!,
          ],
        ],
      ),
    );
  }
}
