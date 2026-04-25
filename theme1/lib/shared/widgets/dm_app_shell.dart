import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/router/app_router.dart';

class DmAppShell extends StatelessWidget {
  final Widget child;

  const DmAppShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final location = GoRouterState.of(context).uri.toString();

    // Mapping locations to indices
    int calculateSelectedIndex() {
      if (location.startsWith(AppRoutes.dashboard)) return 0;
      if (location.startsWith(AppRoutes.dietPlan) || location.startsWith(AppRoutes.mealPlanner)) return 1;
      if (location.startsWith(AppRoutes.inventory)) return 2;
      if (location.startsWith(AppRoutes.progress) || location.startsWith(AppRoutes.nutrition)) return 3;
      return 0;
    }

    void onItemSelected(int index) {
      switch (index) {
        case 0:
          context.go(AppRoutes.dashboard);
          break;
        case 1:
          context.go(AppRoutes.dietPlan);
          break;
        case 2:
          context.go(AppRoutes.inventory);
          break;
        case 3:
          context.go(AppRoutes.progress);
          break;
      }
    }

    return Scaffold(
      body: child,
      extendBody: true,
      bottomNavigationBar: Container(
        height: 70,
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface.withOpacity(0.9),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
          border: Border.all(color: Colors.white.withOpacity(0.08)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(context, 0, Icons.grid_view_rounded, calculateSelectedIndex() == 0, onItemSelected),
              _buildNavItem(context, 1, Icons.restaurant_rounded, calculateSelectedIndex() == 1, onItemSelected),
              _buildNavItem(context, 2, Icons.inventory_2_rounded, calculateSelectedIndex() == 2, onItemSelected),
              _buildNavItem(context, 3, Icons.insights_rounded, calculateSelectedIndex() == 3, onItemSelected),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRoutes.ocr),
        backgroundColor: theme.colorScheme.primary,
        shape: const CircleBorder(),
        elevation: 4,
        child: const Icon(Icons.camera_alt_rounded, color: Colors.white),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, int index, IconData icon, bool isSelected, Function(int) onTap) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () => onTap(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface.withOpacity(0.2),
          ),
          if (isSelected)
            Container(
              margin: const EdgeInsets.only(top: 4),
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }
}
