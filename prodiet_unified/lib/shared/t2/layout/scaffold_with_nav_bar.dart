import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prodiet_unified/core/router/app_router.dart';
import 'package:prodiet_unified/core/theme/t2/t2_colors.dart';

class ScaffoldWithNavBar extends StatelessWidget {
  const ScaffoldWithNavBar({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedIndex = _calculateSelectedIndex(context);

    return Scaffold(
      body: child,
      extendBody: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton.large(
        onPressed: () => context.goNamed('t2Voice'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.black,
        shape: const CircleBorder(),
        child: const Icon(Icons.mic, size: 36),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        color: T2Colors.bgDefault,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: 64,
        clipBehavior: Clip.antiAlias,
        child: Container(
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(color: T2Colors.border, width: 1.0),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildNavItem(context, 0, Icons.home_outlined, Icons.home, "Home", selectedIndex == 0),
              _buildNavItem(context, 1, Icons.restaurant_menu_outlined, Icons.restaurant_menu, "Meals", selectedIndex == 1),
              const SizedBox(width: 80), // Space for FAB
              _buildNavItem(context, 2, Icons.inventory_2_outlined, Icons.inventory_2, "Stock", selectedIndex == 2),
              _buildNavItem(context, 3, Icons.assignment_outlined, Icons.assignment, "Plan", selectedIndex == 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, int index, IconData icon, IconData activeIcon, String label, bool isSelected) {
    final color = isSelected ? T2Colors.lime : T2Colors.textMuted;
    
    return Expanded(
      child: InkWell(
        onTap: () => _onItemTapped(index, context),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(isSelected ? activeIcon : icon, color: color, size: 26),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.barlowCondensed(
                color: color,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location.startsWith(AppRoutes.t2Dashboard)) return 0;
    if (location.startsWith(AppRoutes.t2Meals)) return 1;
    if (location.startsWith(AppRoutes.t2Inventory)) return 2;
    if (location.startsWith(AppRoutes.t2DietPlan)) return 3;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0: context.goNamed('t2Dashboard'); break;
      case 1: context.goNamed('t2Meals'); break;
      case 2: context.goNamed('t2Inventory'); break;
      case 3: context.goNamed('t2DietPlan'); break;
    }
  }
}
