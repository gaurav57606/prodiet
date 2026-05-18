import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:prodiet_unified/core/design_system/tokens/app_theme_tokens.dart';
import 'package:prodiet_unified/app/app_routes.dart';
import 'package:prodiet_unified/features/auth/application/auth_providers.dart';

class AdaptiveAppShell extends ConsumerWidget {
  final Widget child;
  const AdaptiveAppShell({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = context.tokens;
    
    if (tokens.dashboardLayout == AppDashboardLayout.curved) {
      return _T2Scaffold(child: child);
    }
    
    return _T1Scaffold(child: child);
  }
}

class _T1Scaffold extends ConsumerStatefulWidget {
  final Widget child;
  const _T1Scaffold({required this.child});

  @override
  ConsumerState<_T1Scaffold> createState() => _T1ScaffoldState();
}

class _T1ScaffoldState extends ConsumerState<_T1Scaffold> {
  int get _currentIndex {
    final location = GoRouterState.of(context).matchedLocation;
    if (location.contains('dashboard')) return 0;
    if (location.contains('meal-planner') || location.contains('meals')) return 1;
    if (location.contains('diet-plan')) return 2;
    if (location.contains('progress')) return 3;
    if (location.contains('nutrition')) return 4;
    return 0;
  }

  void _onTap(int index) {
    final tokens = context.tokens;
    final isT2 = tokens.dashboardLayout == AppDashboardLayout.curved;
    
    switch (index) {
      case 0:
        context.go(isT2 ? AppRoutes.t2Dashboard : AppRoutes.t1Dashboard);
        break;
      case 1:
        context.go(isT2 ? AppRoutes.t2Meals : AppRoutes.t1MealPlanner);
        break;
      case 2:
        context.go(isT2 ? AppRoutes.t2DietPlan : AppRoutes.t1DietPlan);
        break;
      case 3:
        context.go(isT2 ? AppRoutes.t2Fitband : AppRoutes.t1Progress);
        break;
      case 4:
        context.go(AppRoutes.t1Nutrition);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomAppBar(
        color: tokens.colors.surface,
        elevation: 8,
        padding: EdgeInsets.zero,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _navItem('Home', 0, Icons.dashboard_rounded, Icons.dashboard_outlined),
            _navItem('Meals', 1, Icons.restaurant_rounded, Icons.restaurant_outlined),
            _navItem('Plan', 2, Icons.calendar_month_rounded, Icons.calendar_month_outlined),
            _navItem('Progress', 3, Icons.bar_chart_rounded, Icons.bar_chart_outlined),
            _navItem('Stats', 4, Icons.analytics_rounded, Icons.analytics_outlined),
          ],
        ),
      ),
    );
  }

  Widget _navItem(String label, int index, IconData filled, IconData outlined) {
    final isActive = _currentIndex == index;
    final tokens = context.tokens;
    final color = isActive ? tokens.colors.primary : tokens.colors.onSurface.withValues(alpha: 0.4);
    
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _onTap(index),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(isActive ? filled : outlined, color: color, size: 24),
            const SizedBox(height: 4),
            Text(label,
              style: tokens.typography.labelSmall.copyWith(
                fontSize: 9,
                fontWeight: isActive ? FontWeight.w800 : FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _T2Scaffold extends ConsumerWidget {
  final Widget child;
  const _T2Scaffold({required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = context.tokens;
    final selectedIndex = _calculateSelectedIndex(context);

    return Scaffold(
      backgroundColor: tokens.colors.surface,
      extendBody: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton.large(
        onPressed: () => context.go(AppRoutes.t2Voice),
        backgroundColor: const Color(0xFFC6FF00),
        foregroundColor: Colors.black,
        shape: const CircleBorder(),
        child: const Icon(Icons.mic, size: 36),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        color: tokens.colors.surface,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: 64,
        clipBehavior: Clip.antiAlias,
        child: Container(
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: tokens.colors.outline.withValues(alpha: 0.1), width: 1.0)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildNavItem(context, 0, Icons.home_outlined, Icons.home, 'Home', selectedIndex == 0),
              _buildNavItem(context, 1, Icons.restaurant_menu_outlined, Icons.restaurant_menu, 'Meals', selectedIndex == 1),
              const SizedBox(width: 80),
              _buildNavItem(context, 2, Icons.inventory_2_outlined, Icons.inventory_2, 'Stock', selectedIndex == 2),
              _buildNavItem(context, 3, Icons.assignment_outlined, Icons.assignment, 'Plan', selectedIndex == 3),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          SafeArea(
            bottom: false,
            child: Container(
              height: 52,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              color: tokens.colors.surface,
              child: Row(
                children: [
                  const SizedBox(width: 8),
                  Text('PRODIET', style: tokens.typography.titleMedium.copyWith(
                    fontSize: 22, fontWeight: FontWeight.w900, color: const Color(0xFFC6FF00))),
                  const Spacer(),
                  IconButton(
                    icon: Icon(Icons.more_vert_rounded, color: tokens.colors.onSurface),
                    onPressed: () => _showMoreSheet(context, ref),
                  ),
                ],
              ),
            ),
          ),
          Divider(color: tokens.colors.outline.withValues(alpha: 0.1), height: 1, thickness: 1),
          Expanded(child: child),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, int index, IconData icon,
      IconData activeIcon, String label, bool isSelected) {
    final tokens = context.tokens;
    final color = isSelected ? const Color(0xFFC6FF00) : tokens.colors.onSurface.withValues(alpha: 0.4);
    return Expanded(
      child: InkWell(
        onTap: () => _onItemTapped(index, context),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(isSelected ? activeIcon : icon, color: color, size: 26),
            const SizedBox(height: 4),
            Text(label, style: tokens.typography.labelSmall.copyWith(
              color: color, fontSize: 11,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  void _showMoreSheet(BuildContext context, WidgetRef ref) {
    final tokens = context.tokens;
    showModalBottomSheet(
      context: context,
      backgroundColor: tokens.colors.surfaceContainerHigh,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36, height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(color: tokens.colors.outline.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(2))),
            _sheetItem(context, ctx, Icons.tune_rounded, 'Preferences', AppRoutes.t2Preferences),
            _sheetItem(context, ctx, Icons.restaurant_menu_outlined, 'Recipes', AppRoutes.t2Recipe),
            _sheetItem(context, ctx, Icons.store_outlined, 'Order & Restock', AppRoutes.t2Vendor),
            _sheetItem(context, ctx, Icons.watch_outlined, 'Fitband & Activity', AppRoutes.t2Fitband),
            Divider(color: tokens.colors.outline.withValues(alpha: 0.1), height: 28),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.logout_rounded, color: Color(0xFFFF5C3A)),
              title: Text('Sign Out', style: tokens.typography.titleSmall.copyWith(
                fontSize: 18, fontWeight: FontWeight.w700,
                color: const Color(0xFFFF5C3A))),
              onTap: () async {
                Navigator.pop(ctx);
                await ref.read(authProvider.notifier).signOut();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _sheetItem(BuildContext context, BuildContext sheetCtx,
      IconData icon, String label, String route) {
    final tokens = context.tokens;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: tokens.colors.onSurface),
      title: Text(label, style: tokens.typography.titleSmall.copyWith(
        fontSize: 18, fontWeight: FontWeight.w700, color: tokens.colors.onSurface)),
      onTap: () {
        Navigator.pop(sheetCtx);
        context.go(route);
      },
    );
  }

  int _calculateSelectedIndex(BuildContext context) {
    final loc = GoRouterState.of(context).uri.path;
    if (loc.contains('dashboard')) return 0;
    if (loc.contains('meal-planner') || loc.contains('meals')) return 1;
    if (loc.contains('inventory')) return 2;
    if (loc.contains('diet-plan')) return 3;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    final tokens = context.tokens;
    final isT2 = tokens.dashboardLayout == AppDashboardLayout.curved;

    switch (index) {
      case 0: context.go(isT2 ? AppRoutes.t2Dashboard : AppRoutes.t1Dashboard); break;
      case 1: context.go(isT2 ? AppRoutes.t2Meals : AppRoutes.t1MealPlanner); break;
      case 2: context.go(isT2 ? AppRoutes.t2Inventory : AppRoutes.t1Inventory); break;
      case 3: context.go(isT2 ? AppRoutes.t2DietPlan : AppRoutes.t1DietPlan); break;
    }
  }
}
