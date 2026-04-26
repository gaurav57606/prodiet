import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/router/app_router.dart';

class DmAppShell extends StatelessWidget {
  final Widget child;

  const DmAppShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final location = GoRouterState.of(context).uri.toString();

    return Scaffold(
      body: child,
      extendBody: true,
      floatingActionButton: FloatingActionButton(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        elevation: 8,
        onPressed: () => context.push(AppRoutes.ocr),
        child: const Icon(Icons.mic_rounded, size: 26),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: scheme.surface,
        elevation: 0,
        shape: const CircularNotchedRectangle(),
        notchMargin: 6,
        padding: EdgeInsets.zero,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavItem(
              icon: Icons.home_rounded,
              label: 'Home',
              route: AppRoutes.dashboard,
              isSelected: location.startsWith(AppRoutes.dashboard),
            ),
            _NavItem(
              icon: Icons.restaurant_menu_rounded,
              label: 'Meals',
              route: AppRoutes.mealPlanner,
              isSelected: location.startsWith(AppRoutes.mealPlanner),
            ),
            const SizedBox(width: 56), // notch space
            _NavItem(
              icon: Icons.kitchen_rounded,
              label: 'Stock',
              route: AppRoutes.inventory,
              isSelected: location.startsWith(AppRoutes.inventory),
            ),
            _NavItem(
              icon: Icons.calendar_today_rounded,
              label: 'Plan',
              route: AppRoutes.dietPlan,
              isSelected: location.startsWith(AppRoutes.dietPlan),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String route;
  final bool isSelected;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.route,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return InkWell(
      onTap: () => context.go(route),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: isSelected ? 24 : 22,
            color: isSelected ? scheme.primary : scheme.onSurface.withOpacity(0.25),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              fontSize: 10,
              color: isSelected ? scheme.primary : scheme.onSurface.withOpacity(0.25),
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
