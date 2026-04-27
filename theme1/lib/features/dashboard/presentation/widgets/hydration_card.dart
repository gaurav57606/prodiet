import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/dm_card.dart';
import '../../../../shared/widgets/dm_chip.dart';
import '../mock/dashboard_mock.dart';

class HydrationCard extends StatefulWidget {
  const HydrationCard({super.key});

  @override
  State<HydrationCard> createState() => _HydrationCardState();
}

class _HydrationCardState extends State<HydrationCard> {
  int _filterIndex = 0;

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
                    color: theme.colorScheme.onSurface.withOpacity(0.12),
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
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
            child: Row(
              children: [
                _filterPill('On track', 0, const Color(0xFF40D8B8)),
                const SizedBox(width: 8),
                _filterPill('Almost', 1, const Color(0xFFFFB040)),
                const SizedBox(width: 8),
                _filterPill('Overdue', 2, const Color(0xFFFF6080)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterPill(String label, int index, Color color) {
    final isActive = _filterIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _filterIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? color.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? color.withOpacity(0.5) : Colors.white.withOpacity(0.1),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: isActive ? color : Colors.white.withOpacity(0.3),
          ),
        ),
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
            color: theme.colorScheme.onSurface.withOpacity(0.45),
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
