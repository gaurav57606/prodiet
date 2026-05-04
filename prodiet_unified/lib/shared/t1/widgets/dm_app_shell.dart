import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:prodiet_unified/core/router/app_router.dart';

class DmAppShell extends ConsumerStatefulWidget {
  final Widget child;

  const DmAppShell({super.key, required this.child});

  @override
  ConsumerState<DmAppShell> createState() => _DmAppShellState();
}

class _DmAppShellState extends ConsumerState<DmAppShell> {
  int get _currentIndex {
    final location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith(AppRoutes.t1Dashboard)) return 0;
    if (location.startsWith(AppRoutes.t1MealPlanner)) return 1;
    if (location.startsWith(AppRoutes.t1DietPlan)) return 2;
    if (location.startsWith(AppRoutes.t1Progress)) return 3;
    if (location.startsWith(AppRoutes.t1Nutrition)) return 4;
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
        context.go(AppRoutes.t1DietPlan);
        break;
      case 3:
        context.go(AppRoutes.t1Progress);
        break;
      case 4:
        context.go(AppRoutes.t1Nutrition);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomAppBar(
        color: scheme.surface,
        elevation: 8,
        padding: EdgeInsets.zero,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _navItem(context, Icons.dashboard_rounded, Icons.dashboard_outlined, 'Home', 0),
            _navItem(context, Icons.restaurant_rounded, Icons.restaurant_outlined, 'Meals', 1),
            _navItem(context, Icons.calendar_month_rounded, Icons.calendar_month_outlined, 'Plan', 2),
            _navItem(context, Icons.bar_chart_rounded, Icons.bar_chart_outlined, 'Progress', 3),
            _navItem(context, Icons.analytics_rounded, Icons.analytics_outlined, 'Stats', 4),
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
    final inactiveColor = scheme.onSurface.withValues(alpha: 0.4);
    
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _onTap(index),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(isActive ? filled : outlined,
                color: isActive ? activeColor : inactiveColor,
                size: 24),
            const SizedBox(height: 4),
            Text(label,
              style: theme.textTheme.labelSmall?.copyWith(
                fontSize: 9,
                fontWeight: isActive ? FontWeight.w800 : FontWeight.w500,
                color: isActive ? activeColor : inactiveColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

