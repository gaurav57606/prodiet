import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:prodiet_unified/core/design_system/tokens/app_theme_tokens.dart';
import 'package:prodiet_unified/core/design_system/components/app_card.dart';

class UnifiedHydrationCard extends StatefulWidget {
  final int consumed;
  final int target;
  final double progress;
  final VoidCallback? onAddGlass;

  const UnifiedHydrationCard({
    super.key,
    required this.consumed,
    required this.target,
    required this.progress,
    this.onAddGlass,
  });

  @override
  State<UnifiedHydrationCard> createState() => _UnifiedHydrationCardState();
}

class _UnifiedHydrationCardState extends State<UnifiedHydrationCard> {
  int _filterIndex = 0;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    
    if (tokens.dashboardLayout == AppDashboardLayout.curved) {
      return _buildT2WaterBanner(context);
    }
    
    return _buildT1HydrationCard(context);
  }

  Widget _buildT1HydrationCard(BuildContext context) {
    final tokens = context.tokens;
    
    Color statusColor;
    switch (_filterIndex) {
      case 0: statusColor = tokens.colors.waterOk; break;
      case 1: statusColor = tokens.colors.waterWarning; break;
      case 2: statusColor = tokens.colors.waterDanger; break;
      default: statusColor = tokens.colors.waterOk;
    }

    return AppCard(
      color: statusColor.withValues(alpha: 0.06),
      border: BorderSide(color: statusColor.withValues(alpha: 0.15)),
      padding: EdgeInsets.zero,
      onTap: () => context.push('/t1/hydration'),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(tokens.spacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'HYDRATION',
                      style: tokens.typography.labelSmall.copyWith(
                        color: statusColor.withValues(alpha: 0.6),
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    _buildStatusBadge(statusColor),
                  ],
                ),
                SizedBox(height: tokens.spacing.sm),
                _buildTimeRemaining(statusColor),
                SizedBox(height: tokens.spacing.md),
                _buildProgressBar(statusColor),
              ],
            ),
          ),
          _buildStatRow(statusColor),
          _buildFilterPills(tokens),
          if (widget.onAddGlass != null) _buildAddButton(tokens),
        ],
      ),
    );
  }

  Widget _buildT2WaterBanner(BuildContext context) {
    final tokens = context.tokens;
    final skyColor = tokens.colors.waterOk;
    
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: tokens.spacing.lg, vertical: tokens.spacing.md),
      decoration: BoxDecoration(
        color: skyColor.withValues(alpha: 0.10),
        border: Border.symmetric(
          horizontal: BorderSide(color: skyColor.withValues(alpha: 0.18), width: 1),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: skyColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(tokens.radius.sm),
            ),
            child: Icon(Icons.water_drop, color: skyColor, size: 16),
          ),
          SizedBox(width: tokens.spacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Almost time — prepare',
                  style: tokens.typography.labelLarge.copyWith(
                    fontSize: 14,
                    color: skyColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  '${(widget.consumed / 1000).toStringAsFixed(1)}L of ${(widget.target / 1000).toStringAsFixed(1)}L · On track',
                  style: tokens.typography.labelSmall.copyWith(
                    fontSize: 12,
                    color: tokens.colors.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${(widget.progress * 100).toInt()}%',
                style: tokens.typography.headlineSmall.copyWith(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: skyColor,
                ),
              ),
              Text(
                'GOAL',
                style: tokens.typography.labelSmall.copyWith(
                  fontSize: 7,
                  letterSpacing: 1.2,
                  color: skyColor.withValues(alpha: 0.5),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // T1 Sub-widgets
  Widget _buildStatusBadge(Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        _filterIndex == 0 ? 'ON TRACK' : (_filterIndex == 1 ? 'ALMOST TIME' : 'OVERDUE'),
        style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 0.5),
      ),
    );
  }

  Widget _buildTimeRemaining(Color color) {
    final tokens = context.tokens;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          _filterIndex == 0 ? '42' : (_filterIndex == 1 ? '05' : '00'),
          style: tokens.typography.displayLarge.copyWith(color: color, fontSize: 56, fontWeight: FontWeight.w900, height: 1),
        ),
        const SizedBox(width: 4),
        Text('m', style: tokens.typography.headlineSmall.copyWith(color: color.withValues(alpha: 0.5), fontWeight: FontWeight.w900)),
      ],
    );
  }

  Widget _buildProgressBar(Color color) {
    final tokens = context.tokens;
    return Container(
      height: 5,
      width: double.infinity,
      decoration: BoxDecoration(color: tokens.colors.onSurface.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(3)),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: widget.progress.clamp(0.0, 1.0),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: _filterIndex == 0 ? [tokens.colors.waterOk, tokens.colors.waterOk.withValues(alpha: 0.8)] : [color, color.withValues(alpha: 0.6)],
            ),
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      ),
    );
  }

  Widget _buildStatRow(Color statusColor) {
    final tokens = context.tokens;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: tokens.spacing.md, vertical: tokens.spacing.sm),
      decoration: BoxDecoration(
        color: tokens.colors.onSurface.withValues(alpha: 0.05),
        border: Border(top: BorderSide(color: tokens.colors.onSurface.withValues(alpha: 0.05))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildStatItem('CONSUMED', '${widget.consumed} ml', statusColor),
          _buildStatItem('TARGET', '${widget.target} ml', tokens.colors.onSurface.withValues(alpha: 0.5), alignEnd: true),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color, {bool alignEnd = false}) {
    final tokens = context.tokens;
    return Column(
      crossAxisAlignment: alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(label, style: tokens.typography.labelSmall.copyWith(color: tokens.colors.onSurface.withValues(alpha: 0.3), fontSize: 8, fontWeight: FontWeight.w800)),
        const SizedBox(height: 2),
        Text(value, style: tokens.typography.titleSmall.copyWith(fontWeight: FontWeight.w900, color: color, fontSize: 13)),
      ],
    );
  }

  Widget _buildFilterPills(AppThemeTokens tokens) {
    return Padding(
      padding: EdgeInsets.all(tokens.spacing.sm),
      child: Wrap(
        spacing: tokens.spacing.xs,
        runSpacing: tokens.spacing.xs,
        children: [
          _filterPill('On track', 0, tokens.colors.waterOk),
          _filterPill('Almost', 1, tokens.colors.waterWarning),
          _filterPill('Overdue', 2, tokens.colors.waterDanger),
        ],
      ),
    );
  }

  Widget _filterPill(String label, int index, Color color) {
    final tokens = context.tokens;
    final isActive = _filterIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _filterIndex = index),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: tokens.spacing.md, vertical: tokens.spacing.xs),
        decoration: BoxDecoration(
          color: isActive ? color.withValues(alpha: 0.15) : tokens.colors.onSurface.withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(tokens.radius.md),
          border: Border.all(color: isActive ? color.withValues(alpha: 0.4) : tokens.colors.onSurface.withValues(alpha: 0.08)),
        ),
        child: Text(label.toUpperCase(), style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: isActive ? color : tokens.colors.onSurface.withValues(alpha: 0.25))),
      ),
    );
  }

  Widget _buildAddButton(AppThemeTokens tokens) {
    return Padding(
      padding: EdgeInsets.only(bottom: tokens.spacing.md),
      child: TextButton.icon(
        onPressed: widget.onAddGlass,
        icon: const Icon(Icons.add_circle_outline_rounded, size: 18),
        label: const Text('+ 250ml'),
        style: TextButton.styleFrom(foregroundColor: tokens.colors.primary, textStyle: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12)),
      ),
    );
  }
}
