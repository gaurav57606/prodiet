import 'package:flutter/material.dart';
import 'package:prodiet_unified/core/design_system/dimensions.dart';
import 'package:prodiet_unified/core/design_system/spacing.dart';

/// Style configuration for [BaseButton].
class BaseButtonStyle {
  final Color backgroundColor;
  final Color foregroundColor;
  final double elevation;
  final Color? shadowColor;
  final BorderRadius borderRadius;
  final BorderSide borderSide;
  final EdgeInsets padding;
  final TextStyle? textStyle;
  final Size? minimumSize;

  const BaseButtonStyle({
    required this.backgroundColor,
    required this.foregroundColor,
    this.elevation = 0,
    this.shadowColor,
    required this.borderRadius,
    this.borderSide = BorderSide.none,
    required this.padding,
    this.textStyle,
    this.minimumSize,
  });
}

/// A generic button widget that handles common logic like loading states and icons.
class BaseButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final BaseButtonStyle style;
  final IconData? icon;
  final bool isLoading;
  final double? width;
  final double? height;
  final bool isFullWidth;
  final double? loadingSize;

  const BaseButton({
    super.key,
    required this.label,
    this.onPressed,
    required this.style,
    this.icon,
    this.isLoading = false,
    this.width,
    this.height,
    this.isFullWidth = false,
    this.loadingSize,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveWidth = isFullWidth ? double.infinity : width;
    final effectiveLoadingSize = loadingSize ?? AppDimensions.buttonLoadingSize;

    return SizedBox(
      width: effectiveWidth,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: style.backgroundColor,
          foregroundColor: style.foregroundColor,
          elevation: style.elevation,
          shadowColor: style.shadowColor,
          minimumSize: style.minimumSize,
          shape: RoundedRectangleBorder(
            borderRadius: style.borderRadius,
            side: style.borderSide,
          ),
          padding: style.padding,
          textStyle: style.textStyle,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              SizedBox(
                height: effectiveLoadingSize,
                width: effectiveLoadingSize,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(style.foregroundColor),
                ),
              )
            else ...[
              if (icon != null) ...[
                Icon(icon, size: AppDimensions.buttonIconSize),
                const SizedBox(width: AppSpacing.sm),
              ],
              Text(
                label,
                style: style.textStyle?.copyWith(color: style.foregroundColor) ??
                    Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: style.foregroundColor,
                          fontWeight: FontWeight.w700,
                        ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
