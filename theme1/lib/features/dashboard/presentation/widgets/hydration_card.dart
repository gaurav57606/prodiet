import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/dm_card.dart';
import '../../../../shared/widgets/dm_chip.dart';
import '../mock/dashboard_mock.dart';

class HydrationCard extends StatelessWidget {
  const HydrationCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final data = DashboardMockData.hydration;
    
    // Status color mapping
    Color statusColor;
    switch (data.status) {
      case 'On track':
        statusColor = const Color(0xFF40D8B8);
        break;
      case 'Almost time':
        statusColor = const Color(0xFFFFB040);
        break;
      default:
        statusColor = const Color(0xFFFF6080);
    }

    return DmCard(
      color: statusColor.withOpacity(0.07),
      borderSide: BorderSide(color: statusColor.withOpacity(0.18)),
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'HYDRATION',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: statusColor.withOpacity(0.6),
                        letterSpacing: 1.2,
                      ),
                    ),
                    DmChip(
                      label: data.status,
                      isSelected: true,
                      backgroundColor: statusColor.withOpacity(0.15),
                      textColor: statusColor,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      data.timerValue,
                      style: theme.textTheme.displayLarge?.copyWith(
                        color: statusColor,
                        fontSize: 50,
                        height: 1,
                      ),
                    ),
                    Text(
                      data.timerUnit,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Text(
                  data.subText,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.4),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Container(
                  height: 6,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onSurface.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: data.percentage,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [statusColor, statusColor.withOpacity(0.5)],
                        ),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.03),
              border: Border(
                top: BorderSide(color: Colors.white.withOpacity(0.05)),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatItem(theme, 'Consumed', '${data.consumed.toInt()} ml'),
                _buildStatItem(theme, 'Target', '${data.target.toInt()} ml', textAlign: TextAlign.right),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(ThemeData theme, String label, String value, {TextAlign textAlign = TextAlign.left}) {
    return Column(
      crossAxisAlignment: textAlign == TextAlign.left ? CrossAxisAlignment.start : CrossAxisAlignment.end,
      children: [
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.25),
          ),
        ),
        Text(
          value,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
