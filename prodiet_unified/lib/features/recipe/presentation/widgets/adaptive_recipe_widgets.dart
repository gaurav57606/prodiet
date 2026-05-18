import 'package:flutter/material.dart';
import 'package:prodiet_unified/core/design_system/tokens/app_theme_tokens.dart';
import 'package:prodiet_unified/core/design_system/components/app_card.dart';
import 'package:prodiet_unified/core/design_system/components/app_badge.dart';
import 'package:prodiet_unified/core/design_system/app_accessibility.dart';

class AdaptiveRecipeCard extends StatelessWidget {
  final String title;
  final String type;
  final String match;
  final bool isExotic;
  final VoidCallback? onTap;

  const AdaptiveRecipeCard({
    super.key,
    required this.title,
    required this.type,
    required this.match,
    this.isExotic = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isT2 = tokens.dashboardLayout == AppDashboardLayout.t2;
    final useAcc = context.useAccessibilityLayout;

    return GestureDetector(
      onTap: onTap,
      child: AppCard(
        margin: EdgeInsets.symmetric(
          horizontal: isT2 ? 20 : 16,
          vertical: isT2 ? 6 : 8,
        ),
        padding: isT2 ? const EdgeInsets.all(20) : const EdgeInsets.all(16),
        color: isT2 ? tokens.colors.surfaceContainerLowest : null,
        border: isT2 ? BorderSide(
          color: isExotic ? tokens.colors.primary.withValues(alpha: 0.3) : tokens.colors.outline.withValues(alpha: 0.1),
        ) : null,
        child: useAcc
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            isT2 ? type.toUpperCase() : type,
                            style: tokens.typography.labelSmall.copyWith(
                              fontWeight: FontWeight.w900,
                              color: tokens.colors.onSurface.withValues(alpha: 0.4),
                              letterSpacing: isT2 ? 1.2 : null,
                            ),
                          ),
                          if (isExotic) ...[
                            const SizedBox(width: 8),
                            AppBadge(
                              label: 'EXOTIC',
                              backgroundColor: tokens.colors.primary.withValues(alpha: 0.1),
                              textColor: tokens.colors.primary,
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isT2 ? title.toUpperCase() : title,
                        style: (isT2 ? tokens.typography.titleLarge : tokens.typography.titleMedium).copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: tokens.colors.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          match,
                          style: tokens.typography.titleMedium.copyWith(
                            fontWeight: FontWeight.w900,
                            color: tokens.colors.primary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'MATCH',
                          style: tokens.typography.labelSmall.copyWith(
                            fontSize: 8,
                            fontWeight: FontWeight.w900,
                            color: tokens.colors.primary.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              isT2 ? type.toUpperCase() : type,
                              style: tokens.typography.labelSmall.copyWith(
                                fontWeight: FontWeight.w900,
                                color: tokens.colors.onSurface.withValues(alpha: 0.4),
                                letterSpacing: isT2 ? 1.2 : null,
                              ),
                            ),
                            if (isExotic) ...[
                              const SizedBox(width: 8),
                              AppBadge(
                                label: 'EXOTIC',
                                backgroundColor: tokens.colors.primary.withValues(alpha: 0.1),
                                textColor: tokens.colors.primary,
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isT2 ? title.toUpperCase() : title,
                          style: (isT2 ? tokens.typography.titleLarge : tokens.typography.titleMedium).copyWith(
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: tokens.colors.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          match,
                          style: tokens.typography.titleMedium.copyWith(
                            fontWeight: FontWeight.w900,
                            color: tokens.colors.primary,
                          ),
                        ),
                        Text(
                          'MATCH',
                          style: tokens.typography.labelSmall.copyWith(
                            fontSize: 8,
                            fontWeight: FontWeight.w900,
                            color: tokens.colors.primary.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
