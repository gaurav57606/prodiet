import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/dm_card.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('My Progress')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatCard(context),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'WEEKLY COMPLIANCE',
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.25),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            _buildComplianceChart(context),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'ACHIEVEMENTS',
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.25),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            _buildAchievementList(context),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(BuildContext context) {
    final theme = Theme.of(context);
    return DmCard(
      color: theme.colorScheme.primary.withOpacity(0.08),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(theme, '-1.4kg', 'This week'),
          _buildStatItem(theme, '92%', 'Adherence'),
          _buildStatItem(theme, '4.8k', 'Avg Steps'),
        ],
      ),
    );
  }

  Widget _buildStatItem(ThemeData theme, String value, String label) {
    return Column(
      children: [
        Text(value, style: theme.textTheme.headlineSmall?.copyWith(color: theme.colorScheme.primary)),
        Text(label, style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.3))),
      ],
    );
  }

  Widget _buildComplianceChart(BuildContext context) {
    final theme = Theme.of(context);
    final days = ['S', 'S', 'M', 'T', 'W', 'T', 'F'];
    final values = [0.8, 0.4, 0.9, 0.95, 0.7, 0.85, 0.6];

    return DmCard(
      child: SizedBox(
        height: 150,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: List.generate(days.length, (index) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: 30,
                  height: 100 * values[index],
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        theme.colorScheme.primary.withOpacity(0.2),
                        theme.colorScheme.primary,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(height: 8),
                Text(days[index], style: theme.textTheme.labelSmall),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildAchievementList(BuildContext context) {
    return Column(
      children: [
        _buildAchievementTile(context, 'Consistent Crusader', '7 days of hitting protein goals', Icons.star_rounded, const Color(0xFFFFD700)),
        const SizedBox(height: AppSpacing.sm),
        _buildAchievementTile(context, 'Hydration Master', 'Drank 3L+ for 3 consecutive days', Icons.water_drop_rounded, const Color(0xFF40D8B8)),
        const SizedBox(height: AppSpacing.sm),
        _buildAchievementTile(context, 'Green Chef', 'Logged 10 unique vegetable types', Icons.eco_rounded, const Color(0xFF80C040)),
      ],
    );
  }

  Widget _buildAchievementTile(BuildContext context, String title, String subtitle, IconData icon, Color color) {
    final theme = Theme.of(context);
    return DmCard(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.titleSmall),
                Text(subtitle, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.4))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
