import 'package:flutter/material.dart';
import 'package:prodiet_unified/core/design_system/tokens/app_theme_tokens.dart';
import 'package:google_fonts/google_fonts.dart';

class AdaptiveOcrActionBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const AdaptiveOcrActionBtn({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isT2 = tokens.dashboardLayout == AppDashboardLayout.t2;

    if (isT2) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 24),
          decoration: BoxDecoration(
            color: tokens.colors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: tokens.colors.outline.withValues(alpha: 0.1)),
          ),
          child: Column(
            children: [
              Icon(icon, color: tokens.colors.primary, size: 32),
              const SizedBox(height: 12),
              Text(
                label.toUpperCase(),
                style: GoogleFonts.barlowCondensed(
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                  color: tokens.colors.onSurface,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ElevatedButton.icon(
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      onPressed: onTap,
    );
  }
}

class AdaptiveOcrResultTile extends StatelessWidget {
  final String name;
  final String quantity;
  final String unit;
  final String category;
  final bool isSelected;
  final VoidCallback onTap;

  const AdaptiveOcrResultTile({
    super.key,
    required this.name,
    required this.quantity,
    required this.unit,
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isT2 = tokens.dashboardLayout == AppDashboardLayout.t2;

    if (isT2) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: tokens.colors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? tokens.colors.primary : tokens.colors.outline.withValues(alpha: 0.1),
            ),
          ),
          child: Row(
            children: [
              Icon(
                isSelected ? Icons.check_circle_rounded : Icons.circle_outlined,
                color: isSelected ? tokens.colors.primary : tokens.colors.onSurface.withValues(alpha: 0.2),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name.toUpperCase(),
                      style: GoogleFonts.barlowCondensed(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: tokens.colors.onSurface,
                      ),
                    ),
                    Text(
                      '$quantity $unit',
                      style: tokens.typography.labelSmall.copyWith(
                        color: tokens.colors.onSurface.withValues(alpha: 0.5),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: tokens.colors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  category.toUpperCase(),
                  style: GoogleFonts.barlowCondensed(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    color: tokens.colors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return CheckboxListTile(
      value: isSelected,
      onChanged: (_) => onTap(),
      title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text('$quantity $unit'),
      secondary: Chip(
        label: Text(category, style: const TextStyle(fontSize: 10)),
      ),
    );
  }
}
