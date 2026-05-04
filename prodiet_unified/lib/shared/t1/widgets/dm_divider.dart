import 'package:flutter/material.dart';
import 'package:prodiet_unified/core/theme/t1/t1_spacing.dart';

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
      height: T1Spacing.lg,
      thickness: 1,
      indent: indent,
      endIndent: endIndent,
      color: color ?? theme.colorScheme.outline.withOpacity(0.1),
    );
  }
}
