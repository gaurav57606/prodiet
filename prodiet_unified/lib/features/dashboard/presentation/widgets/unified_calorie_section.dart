import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prodiet_unified/core/design_system/tokens/app_theme_tokens.dart';
import 'package:prodiet_unified/features/auth/application/auth_providers.dart';
import 'package:prodiet_unified/core/utils/date_providers.dart';
import 'package:intl/intl.dart';

class UnifiedCalorieSection extends ConsumerWidget {
  final int consumed;
  final int goal;
  final int burned;
  final int net;
  final int streak;
  final String? planName;

  const UnifiedCalorieSection({
    super.key,
    required this.consumed,
    required this.goal,
    required this.burned,
    required this.net,
    required this.streak,
    this.planName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = context.tokens;
    
    if (tokens.dashboardLayout == AppDashboardLayout.curved) {
      return _buildT2CalorieStat(context);
    }
    
    return _buildT1CalorieSummary(context, ref);
  }

  Widget _buildT1CalorieSummary(BuildContext context, WidgetRef ref) {
    final tokens = context.tokens;
    final user = ref.watch(currentUserProvider);
    final now = ref.watch(nowProvider);
    
    final caloriesRemaining = (goal - consumed).clamp(0, goal);
    final dateString = DateFormat('EEEE, d MMM').format(now);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: tokens.gradients.hero),
      ),
      padding: EdgeInsets.all(tokens.spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            (planName ?? 'No Active Plan').toUpperCase(),
            style: tokens.typography.labelSmall.copyWith(
              color: tokens.colors.primary.withValues(alpha: 0.8),
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
            ),
          ),
          SizedBox(height: tokens.spacing.md),
          RichText(
            text: TextSpan(
              style: tokens.typography.headlineMedium.copyWith(
                fontWeight: FontWeight.w900,
                fontSize: 34,
                color: tokens.colors.onSurface,
                letterSpacing: -0.5,
              ),
              children: [
                TextSpan(text: '${user?.name?.split(' ').first ?? 'Hello'} '),
                TextSpan(
                  text: user?.name?.split(' ').skip(1).join(' ') ?? '',
                  style: TextStyle(color: tokens.colors.primary),
                ),
              ],
            ),
          ),
          const SizedBox(height: 2),
          Text(
            dateString.toUpperCase(),
            style: tokens.typography.labelSmall.copyWith(
              color: tokens.colors.onSurface.withValues(alpha: 0.3),
              letterSpacing: 1.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: tokens.spacing.xl),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$caloriesRemaining',
                      style: tokens.typography.displayLarge.copyWith(
                        fontSize: 64,
                        fontWeight: FontWeight.w900,
                        height: 1,
                        letterSpacing: -1.5,
                        color: tokens.colors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'KCAL REMAINING TODAY',
                      style: tokens.typography.labelSmall.copyWith(
                        color: tokens.colors.onSurface.withValues(alpha: 0.4),
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
              _buildStreakBadge(context, streak),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildT2CalorieStat(BuildContext context) {
    final tokens = context.tokens;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: tokens.spacing.lg, vertical: tokens.spacing.md),
      decoration: BoxDecoration(
        color: tokens.colors.surfaceContainerLowest,
        border: Border.symmetric(
          horizontal: BorderSide(color: tokens.colors.outline.withValues(alpha: 0.1), width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _statCell(context, 'CONSUMED', consumed.toString(), tokens.colors.primary),
          _vDivider(context),
          _statCell(context, 'BURNED', burned.toString(), tokens.colors.calories),
          _vDivider(context),
          _statCell(context, 'NET', net.toString(), tokens.colors.onSurface),
        ],
      ),
    );
  }

  Widget _statCell(BuildContext context, String label, String value, Color color) {
    final tokens = context.tokens;
    return Column(
      children: [
        Text(
          label,
          style: tokens.typography.labelSmall.copyWith(
            fontSize: 8,
            letterSpacing: 1.4,
            color: tokens.colors.onSurface.withValues(alpha: 0.4),
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: tokens.typography.headlineSmall.copyWith(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _vDivider(BuildContext context) {
    final tokens = context.tokens;
    return Container(
      height: 36,
      width: 1,
      color: tokens.colors.outline.withValues(alpha: 0.1),
    );
  }

  Widget _buildStreakBadge(BuildContext context, int streak) {
    final tokens = context.tokens;
    final badgeColor = tokens.colors.carbs;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: tokens.spacing.md, vertical: tokens.spacing.sm),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(tokens.radius.md),
        border: Border.all(color: badgeColor.withValues(alpha: 0.25)),
      ),
      child: Column(
        children: [
          Text(
            '$streak',
            style: tokens.typography.headlineSmall.copyWith(
              color: badgeColor,
              fontWeight: FontWeight.w900,
              height: 1,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'DAY STREAK',
            style: tokens.typography.labelSmall.copyWith(
              color: badgeColor.withValues(alpha: 0.6),
              fontSize: 8,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}
