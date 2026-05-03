import 'package:flutter/material.dart';
import 'package:prodiet_unified/core/theme/t2/t2_colors.dart';
import 'package:prodiet_unified/core/theme/t2/t2_spacing.dart';

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
    return Divider(
      height: T2Spacing.lg,
      thickness: 1,
      indent: indent,
      endIndent: endIndent,
      color: color ?? T2Colors.border,
    );
  }
}
