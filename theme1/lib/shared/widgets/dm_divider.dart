import 'package:flutter/material.dart';
import '../../core/theme/app_spacing.dart';

class DmDivider extends StatelessWidget {
  final double? indent;
  final double? endIndent;
  final Color? color;

  const DmDivider({
    super.key,
    this.indent,
    this.endIndent,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Divider(
      height: AppSpacing.lg,
      thickness: 1,
      indent: indent,
      endIndent: endIndent,
      color: color ?? theme.colorScheme.outline.withValues(alpha: 0.1),
    );
  }
}
