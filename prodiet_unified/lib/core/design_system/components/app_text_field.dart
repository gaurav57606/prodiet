import 'package:flutter/material.dart';
import '../tokens/app_theme_tokens.dart';

class AppTextField extends StatelessWidget {
  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final int? maxLength;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onFieldSubmitted;
  final Iterable<String>? autofillHints;
  final bool enableSuggestions;
  final bool autocorrect;

  const AppTextField({
    super.key,
    this.label,
    this.hint,
    this.controller,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.maxLength,
    this.onChanged,
    this.focusNode,
    this.textInputAction,
    this.onFieldSubmitted,
    this.autofillHints,
    this.enableSuggestions = true,
    this.autocorrect = true,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: tokens.typography.labelMedium.copyWith(
              color: tokens.colors.onSurface.withValues(alpha: 0.6),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: tokens.spacing.xs),
        ],
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          onFieldSubmitted: onFieldSubmitted,
          autofillHints: autofillHints,
          enableSuggestions: enableSuggestions,
          autocorrect: autocorrect,
          validator: validator,
          onChanged: onChanged,
          focusNode: focusNode,
          maxLength: maxLength,
          style: tokens.typography.bodyLarge.copyWith(
            color: tokens.colors.onSurface,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: tokens.typography.bodyLarge.copyWith(
              color: tokens.colors.onSurface.withValues(alpha: 0.3),
            ),
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: tokens.colors.surface,
            contentPadding: EdgeInsets.symmetric(
              horizontal: tokens.spacing.md,
              vertical: tokens.spacing.md,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(tokens.radius.md),
              borderSide: BorderSide(color: tokens.colors.primary.withValues(alpha: 0.1)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(tokens.radius.md),
              borderSide: BorderSide(color: tokens.colors.primary.withValues(alpha: 0.1)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(tokens.radius.md),
              borderSide: BorderSide(color: tokens.colors.primary, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(tokens.radius.md),
              borderSide: BorderSide(color: tokens.colors.error, width: 1),
            ),
            counterText: "",
          ),
        ),
      ],
    );
  }
}
