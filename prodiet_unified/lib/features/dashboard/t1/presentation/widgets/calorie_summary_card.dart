import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prodiet_unified/core/theme/t1/t1_spacing.dart';
import 'package:prodiet_unified/core/theme/t1/t1_colors.dart';
import 'package:prodiet_unified/features/auth/application/auth_providers.dart';
import 'package:intl/intl.dart';

class CalorieSummaryCard extends ConsumerWidget {
  final int caloriesConsumed;
  final int caloriesGoal;
  final int streakDays;
  final String? activePlanName;

  const CalorieSummaryCard({
    super.key,
    required this.caloriesConsumed,
    required this.caloriesGoal,
    required this.streakDays,
    this.activePlanName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final user = ref.watch(currentUserProvider);
    
    final caloriesRemaining = (caloriesGoal - caloriesConsumed).clamp(0, caloriesGoal);
    final dateString = DateFormat('EEEE, d MMM').format(DateTime.now());

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: scheme.brightness == Brightness.light
            ? T1ColorSchemes.heroGradientLightMode
            : T1ColorSchemes.heroGradient,
        ),
      ),
      padding: const EdgeInsets.fromLTRB(
        T1Spacing.lg,
        T1Spacing.lg,
        T1Spacing.lg,
        T1Spacing.lg,
      ),
      child: Stack(
        children: [
          Positioned(
            top: -60,
            right: -40,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    theme.colorScheme.primary.withValues(alpha: 0.2),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                (activePlanName ?? 'No Active Plan').toUpperCase(),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.primary.withValues(alpha: 0.8),
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 12),
              RichText(
                text: TextSpan(
                  style: theme.textTheme.displayMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    fontSize: 34,
                    color: theme.colorScheme.onSurface,
                    letterSpacing: -0.5,
                  ),
                  children: [
                    TextSpan(text: '${user?.name?.split(' ').first ?? 'Hello'} '),
                    TextSpan(
                      text: user?.name?.split(' ').skip(1).join(' ') ?? '',
                      style: TextStyle(color: theme.colorScheme.primary),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                dateString.toUpperCase(),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                  letterSpacing: 1.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 32),
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
                          style: theme.textTheme.displayLarge?.copyWith(
                            fontSize: 64,
                            fontWeight: FontWeight.w900,
                            height: 1,
                            letterSpacing: -1.5,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'KCAL REMAINING TODAY',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.0,
                          ),
                        ),
                        if (streakDays > 0)
                          Container(
                            margin: const EdgeInsets.only(top: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.orange.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
                            ),
                            child: Text('🔥 $streakDays day streak',
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.orange)),
                          ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFD070).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFFFFD070).withValues(alpha: 0.25),
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '$streakDays',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            color: const Color(0xFFFFD070),
                            fontWeight: FontWeight.w900,
                            height: 1,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'DAY STREAK',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: const Color(0xFFFFD070).withValues(alpha: 0.6),
                            fontSize: 8,
                            letterSpacing: 1.2,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
