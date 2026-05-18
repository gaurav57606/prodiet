import 'package:flutter/material.dart';
import 'package:prodiet_unified/core/design_system/tokens/app_theme_tokens.dart';

class UnifiedVarietyToggle extends StatelessWidget {
  final String leftLabel;
  final String rightLabel;
  final bool isLeftSelected;
  final Function(bool)? onChanged;

  const UnifiedVarietyToggle({
    super.key,
    this.leftLabel = "Same as usual",
    this.rightLabel = "Experiment",
    this.isLeftSelected = true,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: tokens.colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: tokens.colors.outline.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          _buildOption(context, leftLabel, isLeftSelected),
          _buildOption(context, rightLabel, !isLeftSelected),
        ],
      ),
    );
  }

  Widget _buildOption(BuildContext context, String label, bool isSelected) {
    final tokens = context.tokens;
    final isT2 = tokens.dashboardLayout == AppDashboardLayout.curved;
    
    return Expanded(
      child: GestureDetector(
        onTap: () => onChanged?.call(label == leftLabel),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? tokens.colors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              isT2 ? label.toUpperCase() : label,
              style: tokens.typography.labelLarge.copyWith(
                color: isSelected ? Colors.black : tokens.colors.onSurfaceVariant,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
