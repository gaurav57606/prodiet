import 'package:flutter/material.dart';
import 'package:prodiet_unified/core/design_system/tokens/app_theme_tokens.dart';
import 'package:intl/intl.dart';

class UnifiedActivitySection extends StatelessWidget {
  final int steps;
  final int burned;
  final int net;
  final int activeMinutes;
  final int heartRate;

  const UnifiedActivitySection({
    super.key,
    required this.steps,
    required this.burned,
    required this.net,
    this.activeMinutes = 42,
    this.heartRate = 74,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    
    if (tokens.dashboardLayout == AppDashboardLayout.curved) {
      return _buildT2ActivityRow(context);
    }
    
    return _buildT1ActivityGrid(context);
  }

  Widget _buildT1ActivityGrid(BuildContext context) {
    final tokens = context.tokens;
    final stepFormat = NumberFormat('#,###');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _buildT1Tile(context, stepFormat.format(steps), 'STEPS', null, Colors.white, gradient: LinearGradient(colors: tokens.gradients.activity)),
          const SizedBox(width: 8),
          _buildT1Tile(context, '$burned', 'BURNED', const Color(0xFFC6FF00).withValues(alpha: 0.08), const Color(0xFFC6FF00), border: Border.all(color: const Color(0xFFC6FF00).withValues(alpha: 0.15))),
          const SizedBox(width: 8),
          _buildT1Tile(context, '$net', 'NET KCAL', const Color(0xFFFF4081).withValues(alpha: 0.07), const Color(0xFFFF4081), border: Border.all(color: const Color(0xFFFF4081).withValues(alpha: 0.13))),
        ],
      ),
    );
  }

  Widget _buildT2ActivityRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          _buildT2Item(context, 'STEPS', '8,420', Icons.directions_walk, context.tokens.colors.primary),
          const SizedBox(width: 6),
          _buildT2Item(context, 'ACTIVE', '$activeMinutes min', Icons.timer, const Color(0xFFC6FF00)),
          const SizedBox(width: 6),
          _buildT2Item(context, 'BURNED', '$burned kcal', Icons.whatshot, const Color(0xFF00E5FF)),
          const SizedBox(width: 6),
          _buildT2Item(context, 'HEART', '$heartRate bpm', Icons.favorite, const Color(0xFFFF4081)),
        ],
      ),
    );
  }

  // T1 Helpers
  Widget _buildT1Tile(BuildContext context, String value, String label, Color? bgColor, Color textColor, {BoxBorder? border, Gradient? gradient}) {
    final tokens = context.tokens;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(color: bgColor, gradient: gradient, borderRadius: BorderRadius.circular(24), border: border),
        child: Column(
          children: [
            Text(value, style: tokens.typography.headlineSmall.copyWith(color: textColor, fontSize: 20, fontWeight: FontWeight.w900)),
            const SizedBox(height: 2),
            Text(label, style: tokens.typography.labelSmall.copyWith(color: textColor.withValues(alpha: 0.4), letterSpacing: 0.4, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }

  // T2 Helpers
  Widget _buildT2Item(BuildContext context, String label, String value, IconData iconData, Color tileColor) {
    final tokens = context.tokens;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: tokens.colors.surfaceContainerLowest, borderRadius: BorderRadius.circular(tokens.radius.md), border: Border.all(color: tokens.colors.outline.withValues(alpha: 0.1))),
        child: Stack(
          children: [
            Positioned(top: 0, right: 0, child: Icon(iconData, color: tileColor, size: 14)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: tokens.typography.labelSmall.copyWith(fontSize: 8, letterSpacing: 1.2, color: tokens.colors.onSurface.withValues(alpha: 0.4), fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(value, style: tokens.typography.headlineSmall.copyWith(fontSize: 20, fontWeight: FontWeight.w800, color: tileColor)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
