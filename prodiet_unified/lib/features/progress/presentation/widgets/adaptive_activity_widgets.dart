import 'package:flutter/material.dart';
import 'package:prodiet_unified/core/design_system/tokens/app_theme_tokens.dart';
import 'package:prodiet_unified/core/design_system/components/app_card.dart';

class AdaptiveActivityStatTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const AdaptiveActivityStatTile({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isT2 = tokens.dashboardLayout == AppDashboardLayout.t2;

    return AppCard(
      padding: const EdgeInsets.all(16),
      color: isT2 ? tokens.colors.surfaceContainerLowest : color.withValues(alpha: 0.08),
      border: BorderSide(
        color: isT2 ? tokens.colors.outline.withValues(alpha: 0.1) : color.withValues(alpha: 0.15),
      ),
      child: Column(
        crossAxisAlignment: isT2 ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          if (isT2) ...[
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 12),
          ],
          if (!isT2) 
            Text(
              value, 
              style: tokens.typography.titleLarge.copyWith(color: color, fontWeight: FontWeight.w900)
            ),
          Text(
            label.toUpperCase(),
            style: tokens.typography.labelSmall.copyWith(
              color: isT2 ? tokens.colors.onSurface.withValues(alpha: 0.4) : color.withValues(alpha: 0.4), 
              letterSpacing: isT2 ? 1.0 : 0.4, 
              fontWeight: FontWeight.w900
            ),
          ),
          if (isT2)
            Text(
              value,
              style: tokens.typography.headlineSmall.copyWith(
                fontWeight: FontWeight.w900,
                color: tokens.colors.onSurface,
              ),
            ),
        ],
      ),
    );
  }
}

class AdaptiveDeviceConnectionCard extends StatelessWidget {
  final String deviceName;
  final String status;
  final bool isActive;

  const AdaptiveDeviceConnectionCard({
    super.key,
    required this.deviceName,
    required this.status,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isT2 = tokens.dashboardLayout == AppDashboardLayout.t2;

    return AppCard(
      padding: EdgeInsets.all(isT2 ? 20 : 16),
      color: isT2 ? tokens.colors.surfaceContainerLow : tokens.colors.onSurface.withValues(alpha: 0.04),
      border: isT2 ? BorderSide(color: tokens.colors.primary.withValues(alpha: 0.2)) : null,
      child: Row(
        children: [
          Container(
            width: isT2 ? 48 : 44,
            height: isT2 ? 48 : 44,
            decoration: BoxDecoration(
              color: tokens.colors.primary.withValues(alpha: 0.1),
              shape: isT2 ? BoxShape.circle : BoxShape.rectangle,
              borderRadius: isT2 ? null : BorderRadius.circular(12),
              border: isT2 ? null : Border.all(color: tokens.colors.primary.withValues(alpha: 0.2)),
            ),
            child: Icon(
              isT2 ? Icons.watch_rounded : Icons.fitness_center_rounded, 
              color: tokens.colors.primary, 
              size: 22
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isT2 ? deviceName.toUpperCase() : deviceName, 
                  style: (isT2 ? tokens.typography.titleLarge : tokens.typography.titleMedium).copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  status,
                  style: tokens.typography.bodySmall.copyWith(
                    color: tokens.colors.onSurface.withValues(alpha: isT2 ? 0.5 : 0.4)
                  ),
                ),
              ],
            ),
          ),
          if (isActive)
            if (isT2)
              Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(color: Color(0xFFB8FF00), shape: BoxShape.circle),
              )
            else
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF40D8B8).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF40D8B8).withValues(alpha: 0.2)),
                ),
                child: const Text(
                  'Active',
                  style: TextStyle(color: Color(0xFF40D8B8), fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
        ],
      ),
    );
  }
}

