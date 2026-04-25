import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dietmate_pro/core/router/app_router.dart';

class ScaffoldWithNavBar extends StatelessWidget {
  const ScaffoldWithNavBar({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedIndex = _calculateSelectedIndex(context);

    return Scaffold(
      body: child,
      extendBody: true, // Allows content to be visible behind the nav bar
      bottomNavigationBar: Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface.withOpacity(0.85),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: theme.colorScheme.outline.withOpacity(0.1)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: NavigationBar(
            selectedIndex: selectedIndex,
            onDestinationSelected: (index) => _onItemTapped(index, context),
            backgroundColor: Colors.transparent,
            indicatorColor: theme.colorScheme.primary.withOpacity(0.15),
            labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
            height: 65,
            destinations: [
              _buildDestination(Icons.home_outlined, Icons.home, "Home", selectedIndex == 0, theme),
              _buildDestination(Icons.restaurant_menu_outlined, Icons.restaurant_menu, "Meals", selectedIndex == 1, theme),
              _buildDestination(Icons.mic_none_outlined, Icons.mic, "Voice", selectedIndex == 2, theme),
              _buildDestination(Icons.inventory_2_outlined, Icons.inventory_2, "Stock", selectedIndex == 3, theme),
              _buildDestination(Icons.assignment_outlined, Icons.assignment, "Plan", selectedIndex == 4, theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDestination(IconData icon, IconData activeIcon, String label, bool isSelected, ThemeData theme) {
    return NavigationDestination(
      icon: Icon(icon, color: theme.colorScheme.onSurfaceVariant),
      selectedIcon: Icon(activeIcon, color: theme.colorScheme.primary),
      label: label,
    );
  }

  static int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location.startsWith(AppRoutes.dashboard)) return 0;
    if (location.startsWith(AppRoutes.meals)) return 1;
    if (location.startsWith(AppRoutes.voice)) return 2;
    if (location.startsWith(AppRoutes.inventory)) return 3;
    if (location.startsWith(AppRoutes.dietPlan)) return 4;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0: context.goNamed('dashboard'); break;
      case 1: context.goNamed('meals'); break;
      case 2: context.goNamed('voice'); break;
      case 3: context.goNamed('inventory'); break;
      case 4: context.goNamed('dietPlan'); break;
    }
  }
}
