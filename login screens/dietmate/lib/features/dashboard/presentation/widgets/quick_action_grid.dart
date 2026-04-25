import 'package:flutter/material.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/extensions.dart';
import '../../../shared/widgets/dm_card.dart';

class QuickActionGrid extends StatelessWidget {
  const QuickActionGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('QUICK ACTIONS', style: context.textTheme.labelLarge),
        const SizedBox(height: AppSpacing.md),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 4,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          children: [
            _buildAction(context, 'Scan', Icons.qr_code_scanner_rounded),
            _buildAction(context, 'Log', Icons.add_circle_outline_rounded),
            _buildAction(context, 'Plan', Icons.calendar_today_rounded),
            _buildAction(context, 'Shop', Icons.shopping_basket_outlined),
          ],
        ),
      ],
    );
  }

  Widget _buildAction(BuildContext context, String label, IconData icon) {
    return Column(
      children: [
        Expanded(
          child: DmCard(
            padding: 0,
            borderRadius: 16,
            child: Center(
              child: Icon(icon, color: context.colorScheme.primary),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(label, style: context.textTheme.labelSmall),
      ],
    );
  }
}
