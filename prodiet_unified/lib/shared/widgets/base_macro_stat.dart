import 'package:flutter/material.dart';

class BaseMacroStat extends StatelessWidget {
  final String value;
  final String label;
  final TextStyle? valueStyle;
  final TextStyle? labelStyle;
  final Decoration? valueDecoration;
  final EdgeInsetsGeometry? valuePadding;
  final double spacing;
  final CrossAxisAlignment crossAxisAlignment;

  const BaseMacroStat({
    super.key,
    required this.value,
    required this.label,
    this.valueStyle,
    this.labelStyle,
    this.valueDecoration,
    this.valuePadding,
    this.spacing = 4.0,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: crossAxisAlignment,
      children: [
        if (valueDecoration != null || valuePadding != null)
          Container(
            padding: valuePadding,
            decoration: valueDecoration,
            child: Text(
              value,
              style: valueStyle,
            ),
          )
        else
          Text(
            value,
            style: valueStyle,
          ),
        SizedBox(height: spacing),
        Text(
          label,
          style: labelStyle,
        ),
      ],
    );
  }
}
