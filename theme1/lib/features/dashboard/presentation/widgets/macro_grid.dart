import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import '../mock/dashboard_mock.dart';

class MacroGrid extends StatelessWidget {
  const MacroGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 9,
          mainAxisSpacing: 9,
          childAspectRatio: 1.4,
        ),
        itemCount: 4, // 3 macros + 1 fat tile (custom styled in HTML)
        itemBuilder: (context, index) {
          if (index < 3) {
            final data = DashboardMockData.macros[index];
            return _buildMacroTile(context, data);
          }
          // The 4th tile is the 'Fat' tile which has a different background in HTML
          return _buildFatTile(context);
        },
      ),
    );
  }

  Widget _buildMacroTile(BuildContext context, MacroData data) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: data.gradientColors.cast<Color>(),
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildIcon(context, data.label),
              Text(
                '${data.percentage.toInt() * 100}%',
                style: theme.textTheme.labelSmall?.copyWith(color: Colors.white.withOpacity(0.5)),
              ),
            ],
          ),
          const Spacer(),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '${data.value.toInt()}',
                  style: theme.textTheme.headlineMedium?.copyWith(color: Colors.white, fontSize: 24),
                ),
                TextSpan(
                  text: data.unit,
                  style: theme.textTheme.labelSmall?.copyWith(color: Colors.white.withOpacity(0.6)),
                ),
              ],
            ),
          ),
          Text(
            data.label,
            style: theme.textTheme.labelSmall?.copyWith(color: Colors.white.withOpacity(0.4)),
          ),
        ],
      ),
    );
  }

  Widget _buildFatTile(BuildContext context) {
    final theme = Theme.of(context);
    const fatColor = Color(0xFF40D8C0);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: fatColor.withOpacity(0.07),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: fatColor.withOpacity(0.13)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildIcon(context, 'Fat', isFat: true),
          const Spacer(),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '28',
                  style: theme.textTheme.headlineMedium?.copyWith(color: fatColor, fontSize: 24),
                ),
                TextSpan(
                  text: 'g',
                  style: theme.textTheme.labelSmall?.copyWith(color: fatColor.withOpacity(0.5)),
                ),
              ],
            ),
          ),
          Text(
            'Fat',
            style: theme.textTheme.labelSmall?.copyWith(color: fatColor.withOpacity(0.4)),
          ),
        ],
      ),
    );
  }

  Widget _buildIcon(BuildContext context, String label, {bool isFat = false}) {
    IconData icon;
    switch (label) {
      case 'Protein':
        icon = Icons.favorite_rounded;
        break;
      case 'Carbs':
        icon = Icons.bolt_rounded;
        break;
      case 'Fat':
        icon = Icons.water_drop_rounded;
        break;
      default:
        icon = Icons.restaurant_rounded;
    }

    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: isFat ? const Color(0xFF40D8C0).withOpacity(0.1) : Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Icon(icon, size: 16, color: isFat ? const Color(0xFF40D8C0) : Colors.white),
    );
  }
}
