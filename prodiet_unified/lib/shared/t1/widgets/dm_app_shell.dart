import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:prodiet_unified/core/router/app_router.dart';

class DmAppShell extends StatefulWidget {
  final Widget child;

  const DmAppShell({super.key, required this.child});

  @override
  State<DmAppShell> createState() => _DmAppShellState();
}

class _DmAppShellState extends State<DmAppShell> {
  int get _currentIndex {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith(AppRoutes.t1Dashboard)) return 0;
    if (location.startsWith(AppRoutes.t1MealPlanner)) return 1;
    if (location.startsWith(AppRoutes.t1Inventory)) return 2;
    if (location.startsWith(AppRoutes.t1DietPlan)) return 3;
    return 0;
  }

  void _onTap(int index) {
    switch (index) {
      case 0:
        context.go(AppRoutes.t1Dashboard);
        break;
      case 1:
        context.go(AppRoutes.t1MealPlanner);
        break;
      case 2:
        context.go(AppRoutes.t1Inventory);
        break;
      case 3:
        context.go(AppRoutes.t1DietPlan);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Scaffold(
      body: widget.child,
      extendBody: true,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Voice entry coming soon'),
              duration: Duration(seconds: 2),
            ),
          );
        },
        backgroundColor: scheme.primary,
        elevation: 6,
        shape: const CircleBorder(),
        child: Icon(Icons.mic_rounded, color: scheme.onPrimary, size: 28),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: scheme.surface,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        padding: EdgeInsets.zero,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _navItem(context, Icons.home_rounded, Icons.home_outlined, 'Home', 0),
            _navItem(context, Icons.restaurant_rounded, Icons.restaurant_outlined, 'Meals', 1),
            const SizedBox(width: 56), // space for FAB
            _navItem(context, Icons.inventory_2_rounded, Icons.inventory_2_outlined, 'Pantry', 2),
            _navItem(context, Icons.calendar_month_rounded, Icons.calendar_month_outlined, 'Program', 3),
          ],
        ),
      ),
    );
  }

  Widget _navItem(BuildContext ctx, IconData filled, IconData outlined, 
                  String label, int index) {
    final isActive = _currentIndex == index;
    final theme = Theme.of(ctx);
    final scheme = theme.colorScheme;
    final activeColor = scheme.primary;
    final inactiveColor = scheme.onSurface.withOpacity(0.4);
    return GestureDetector(
      onTap: () => _onTap(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(isActive ? filled : outlined,
              color: isActive ? activeColor : inactiveColor,
              size: 24),
          const SizedBox(height: 2),
          Text(label,
            style: theme.textTheme.labelSmall?.copyWith(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: isActive ? activeColor : inactiveColor,
            ),
          ),
        ],
      ),
    );
  }
}
