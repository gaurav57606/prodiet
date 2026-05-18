import 'package:flutter/material.dart';
import '../tokens/app_theme_tokens.dart';

enum AppButtonVariant { primary, secondary, outline, ghost, danger }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final IconData? icon;
  final bool isLoading;
  final double? width;
  final double? height;
  final bool isFullWidth;
  final Color? backgroundColor;
  final Color? textColor;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.icon,
    this.isLoading = false,
    this.width,
    this.height,
    this.isFullWidth = false,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    
    Color bgColor;
    Color fgColor;
    BorderSide? border;

    switch (variant) {
      case AppButtonVariant.primary:
        bgColor = tokens.colors.primary;
        fgColor = tokens.colors.onPrimary;
        break;
      case AppButtonVariant.secondary:
        bgColor = tokens.colors.secondary;
        fgColor = tokens.colors.onSecondary;
        break;
      case AppButtonVariant.outline:
        bgColor = Colors.transparent;
        fgColor = tokens.colors.primary;
        border = BorderSide(color: tokens.colors.primary, width: 1.5);
        break;
      case AppButtonVariant.ghost:
        bgColor = Colors.transparent;
        fgColor = tokens.colors.primary;
        break;
      case AppButtonVariant.danger:
        bgColor = tokens.colors.error.withValues(alpha: 0.1);
        fgColor = tokens.colors.error;
        border = BorderSide(color: tokens.colors.error.withValues(alpha: 0.2));
        break;
    }

    if (backgroundColor != null) bgColor = backgroundColor!;
    if (textColor != null) fgColor = textColor!;

    final effectiveWidth = isFullWidth ? double.infinity : width;

    return SizedBox(
      width: effectiveWidth,
      height: height ?? 52,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: fgColor,
          disabledBackgroundColor: bgColor.withValues(alpha: 0.5),
          disabledForegroundColor: fgColor.withValues(alpha: 0.5),
          elevation: variant == AppButtonVariant.primary ? 2 : 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(tokens.radius.button),
            side: border ?? BorderSide.none,
          ),
          padding: EdgeInsets.symmetric(horizontal: tokens.spacing.lg),
        ),
        child: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(fgColor),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20),
                    SizedBox(width: tokens.spacing.sm),
                  ],
                  Text(
                    label,
                    style: tokens.typography.labelLarge.copyWith(
                      color: fgColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

