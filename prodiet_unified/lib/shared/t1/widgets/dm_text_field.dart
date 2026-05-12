import 'package:flutter/material.dart';
import 'package:prodiet_unified/core/theme/t1/t1_spacing.dart';
import 'package:prodiet_unified/shared/widgets/base_text_field.dart';

class DmTextField extends StatelessWidget {
  final String? label;
  final String? hintText;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final int? maxLength;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;

  const DmTextField({
    super.key,
    this.label,
    this.hintText,
    this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.maxLength,
    this.onChanged,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BaseTextField(
      label: label,
      hint: hintText,
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType ?? TextInputType.text,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      validator: validator,
      maxLength: maxLength,
      onChanged: onChanged,
      focusNode: focusNode,
      labelStyle: theme.textTheme.labelLarge?.copyWith(
        color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
      ),
      textStyle: theme.textTheme.bodyLarge,
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.symmetric(
          horizontal: T1Spacing.md,
          vertical: T1Spacing.md,
        ),
      ),
      labelSpacing: T1Spacing.xs,
    );
  }
}
