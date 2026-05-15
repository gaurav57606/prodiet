import 'package:flutter/material.dart';
import 'package:prodiet_unified/core/design_system/tokens/design_tokens.dart';

enum AppButtonVariant { primary, secondary, outline, ghost }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final IconData? icon;
  final bool isLoading;
  final double? width;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.icon,
    this.isLoading = false,
    this.width,
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
    }

    return SizedBox(
      width: width,
      height: 52,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: fgColor,
          elevation: variant == AppButtonVariant.primary ? 2 : 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(tokens.radius.md),
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
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.2,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
