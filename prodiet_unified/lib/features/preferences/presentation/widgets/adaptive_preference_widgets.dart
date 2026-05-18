import 'package:flutter/material.dart';
import 'package:prodiet_unified/core/design_system/tokens/app_theme_tokens.dart';
import 'package:prodiet_unified/core/design_system/components/app_chip.dart';

class AdaptivePreferenceSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const AdaptivePreferenceSection({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isT2 = tokens.dashboardLayout == AppDashboardLayout.t2;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isT2 ? title.toUpperCase() : title,
            style: tokens.typography.labelLarge.copyWith(
              color: tokens.colors.onSurface.withValues(alpha: 0.25),
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(spacing: 8, runSpacing: 8, children: children),
        ],
      ),
    );
  }
}

class AdaptivePreferenceRow extends StatelessWidget {
  final String label;
  final String? subLabel;
  final Widget? trailing;
  final bool hasToggle;
  final bool toggleValue;
  final ValueChanged<bool>? onToggle;
  final bool showBorder;

  const AdaptivePreferenceRow({
    super.key,
    required this.label,
    this.subLabel,
    this.trailing,
    this.hasToggle = false,
    this.toggleValue = false,
    this.onToggle,
    this.showBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isT2 = tokens.dashboardLayout == AppDashboardLayout.t2;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: showBorder ? Border(bottom: BorderSide(color: tokens.colors.outline.withValues(alpha: 0.1))) : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isT2 ? label.toUpperCase() : label,
                  style: tokens.typography.titleSmall.copyWith(
                    fontWeight: FontWeight.w700,
                    color: tokens.colors.onSurface,
                  ),
                ),
                if (subLabel != null)
                  Text(
                    subLabel!,
                    style: tokens.typography.bodySmall.copyWith(
                      color: tokens.colors.onSurface.withValues(alpha: 0.4),
                    ),
                  ),
              ],
            ),
          ),
          if (hasToggle)
            _buildToggle(context, toggleValue, onToggle)
          else if (trailing != null)
            trailing!,
        ],
      ),
    );
  }

  Widget _buildToggle(BuildContext context, bool isOn, ValueChanged<bool>? onToggle) {
    final tokens = context.tokens;
    return GestureDetector(
      onTap: () => onToggle?.call(!isOn),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 44,
        height: 24,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isOn ? tokens.colors.primary : tokens.colors.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(20),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          alignment: isOn ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 16,
            height: 16,
            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
          ),
        ),
      ),
    );
  }
}

class AdaptiveChoiceChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? color;

  const AdaptiveChoiceChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return AppChip(
      label: label,
      isSelected: isSelected,
      onTap: onTap,
      color: color,
    );
  }
}
