import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:prodiet_unified/core/theme/pro_diet_theme_extension.dart';
import 'package:prodiet_unified/shared/widgets/app_card.dart';

class HydrationCard extends StatefulWidget {
  final int consumed;
  final int target;
  final double progress;
  final VoidCallback? onAddGlass;

  const HydrationCard({
    super.key,
    required this.consumed,
    required this.target,
    required this.progress,
    this.onAddGlass,
  });

  @override
  State<HydrationCard> createState() => _HydrationCardState();
}

class _HydrationCardState extends State<HydrationCard> {
  int _filterIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<ProDietThemeExtension>()!;
    
    Color statusColor;
    switch (_filterIndex) {
      case 0:
        statusColor = ext.water;
        break;
      case 1:
        statusColor = const Color(0xFFFFB040);
        break;
      case 2:
        statusColor = const Color(0xFFFF6080);
        break;
      default:
        statusColor = ext.water;
    }

    return AppCard(
      color: statusColor.withValues(alpha: 0.06),
      borderSide: BorderSide(color: statusColor.withValues(alpha: 0.15)),
      padding: EdgeInsets.zero,
      onTap: () => context.push('/t1/hydration'),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'HYDRATION',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: statusColor.withValues(alpha: 0.6),
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _filterIndex == 0 ? 'ON TRACK' : (_filterIndex == 1 ? 'ALMOST TIME' : 'OVERDUE'),
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      _filterIndex == 0 ? '42' : (_filterIndex == 1 ? '05' : '00'),
                      style: theme.textTheme.displayLarge?.copyWith(
                        color: statusColor,
                        fontSize: 56,
                        fontWeight: FontWeight.w900,
                        height: 1,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'm',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: statusColor.withValues(alpha: 0.5),
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'UNTIL YOUR NEXT DRINK',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.35),
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  height: 5,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: widget.progress.clamp(0.0, 1.0),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: _filterIndex == 0 ? ext.waterGradient : [statusColor, statusColor.withValues(alpha: 0.6)],
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
              horizontal: 16,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.05),
              border: Border(
                top: BorderSide(color: theme.colorScheme.onSurface.withValues(alpha: 0.05)),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatItem(theme, 'CONSUMED', '${widget.consumed} ml', statusColor),
                _buildStatItem(theme, 'TARGET', '${widget.target} ml', theme.colorScheme.onSurface.withValues(alpha: 0.5), textAlign: TextAlign.right),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _filterPill('On track', 0, ext.water),
                _filterPill('Almost', 1, const Color(0xFFFFB040)),
                _filterPill('Overdue', 2, const Color(0xFFFF6080)),
              ],
            ),
          ),
          if (widget.onAddGlass != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: TextButton.icon(
                onPressed: widget.onAddGlass,
                icon: const Icon(Icons.add_circle_outline_rounded, size: 18),
                label: const Text('+ 250ml'),
                style: TextButton.styleFrom(
                  foregroundColor: theme.colorScheme.primary,
                  textStyle: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12),
                ),
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
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isActive ? color.withValues(alpha: 0.15) : Colors.white.withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive ? color.withValues(alpha: 0.4) : Colors.white.withValues(alpha: 0.08),
          ),
        ),
        child: Text(
          label.toUpperCase(),
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w900,
            color: isActive ? color : Colors.white.withValues(alpha: 0.25),
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(ThemeData theme, String label, String value, Color valueColor, {TextAlign textAlign = TextAlign.left}) {
    return Column(
      crossAxisAlignment: textAlign == TextAlign.left ? CrossAxisAlignment.start : CrossAxisAlignment.end,
      children: [
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
            fontSize: 8,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w900,
            color: valueColor,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}

  Widget _filterPill(String label, int index, Color color) {
    final isActive = _filterIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _filterIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isActive ? color.withValues(alpha: 0.15) : Colors.white.withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive ? color.withValues(alpha: 0.4) : Colors.white.withValues(alpha: 0.08),
          ),
        ),
        child: Text(
          label.toUpperCase(),
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w900,
            color: isActive ? color : Colors.white.withValues(alpha: 0.25),
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(ThemeData theme, String label, String value, Color valueColor, {TextAlign textAlign = TextAlign.left}) {
    return Column(
      crossAxisAlignment: textAlign == TextAlign.left ? CrossAxisAlignment.start : CrossAxisAlignment.end,
      children: [
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
            fontSize: 8,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w900,
            color: valueColor,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}
