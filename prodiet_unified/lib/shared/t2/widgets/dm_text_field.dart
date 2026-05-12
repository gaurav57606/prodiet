import 'package:flutter/material.dart';
import 'package:prodiet_unified/core/theme/t2/t2_spacing.dart';
import 'package:prodiet_unified/shared/widgets/base_text_field.dart';

class DmTextField extends StatelessWidget {
  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final int? maxLength;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;

  const DmTextField({
    super.key,
    this.label,
    this.hint,
    this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
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
      hint: hint,
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      validator: validator,
      maxLength: maxLength,
      onChanged: onChanged,
      focusNode: focusNode,
      labelStyle: theme.textTheme.titleSmall?.copyWith(
        color: theme.colorScheme.onSurfaceVariant,
      ),
      textStyle: theme.textTheme.bodyLarge,
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.symmetric(
          vertical: T2Spacing.md,
          horizontal: T2Spacing.md,
        ),
      ),
      labelSpacing: T2Spacing.xs,
    );
  }
}
