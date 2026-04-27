import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/dm_card.dart';

class HydrationScreen extends StatelessWidget {
  const HydrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = const Color(0xFF40D8B8);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hydration Details'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHero(theme, statusColor),
            const SizedBox(height: AppSpacing.xl),
            Text(
              'QUICK ADD',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.3),
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            _buildQuickAddGrid(theme, statusColor),
            const SizedBox(height: AppSpacing.xl),
            Text(
              'TODAY\'S HISTORY',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.3),
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            _buildHistoryList(theme, statusColor),
          ],
        ),
      ),
    );
  }

  Widget _buildHero(ThemeData theme, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color.withOpacity(0.15), color.withOpacity(0.05)],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withOpacity(0.15)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '1,500',
                style: theme.textTheme.displayLarge?.copyWith(
                  color: color,
                  fontSize: 64,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'ml',
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: color.withOpacity(0.5),
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          Text(
            'OF 2,500 ML TARGET',
            style: theme.textTheme.labelSmall?.copyWith(
              color: color.withOpacity(0.6),
              fontWeight: FontWeight.w900,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 24),
          LinearProgressIndicator(
            value: 0.6,
            backgroundColor: color.withOpacity(0.1),
            color: color,
            minHeight: 12,
            borderRadius: BorderRadius.circular(6),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAddGrid(ThemeData theme, Color color) {
    final amounts = [
      {'val': '250', 'icon': Icons.local_drink_rounded},
      {'val': '500', 'icon': Icons.water_drop_rounded},
      {'val': '750', 'icon': Icons.wine_bar_rounded},
      {'val': '1000', 'icon': Icons.coffee_rounded},
    ];

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: amounts.map((a) {
        return DmCard(
          color: Colors.white.withOpacity(0.03),
          padding: const EdgeInsets.all(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(a['icon'] as IconData, color: color, size: 20),
              const SizedBox(width: 12),
              Text(
                '${a['val']} ml',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildHistoryList(ThemeData theme, Color color) {
    final history = [
      {'time': '08:30 AM', 'amount': '250 ml'},
      {'time': '10:15 AM', 'amount': '500 ml'},
      {'time': '12:45 PM', 'amount': '250 ml'},
      {'time': '02:30 PM', 'amount': '500 ml'},
    ];

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: history.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final item = history[index];
        return DmCard(
          color: Colors.white.withOpacity(0.02),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.history_rounded, size: 16, color: theme.colorScheme.onSurface.withOpacity(0.2)),
                  const SizedBox(width: 12),
                  Text(
                    item['time']!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              Text(
                item['amount']!,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: color,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
