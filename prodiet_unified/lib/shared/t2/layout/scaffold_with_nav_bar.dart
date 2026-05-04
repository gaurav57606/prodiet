import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prodiet_unified/core/router/app_router.dart';
import 'package:prodiet_unified/core/theme/t2/t2_colors.dart';
import 'package:prodiet_unified/features/auth/application/auth_providers.dart';

class ScaffoldWithNavBar extends ConsumerWidget {
  const ScaffoldWithNavBar({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = _calculateSelectedIndex(context);

    return Scaffold(
      backgroundColor: T2Colors.bgDefault,
      extendBody: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton.large(
        onPressed: () => context.go(AppRoutes.t2Voice),
        backgroundColor: T2Colors.lime,
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
            border: Border(top: BorderSide(color: T2Colors.border, width: 1.0)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildNavItem(context, 0, Icons.home_outlined, Icons.home, 'Home',
                  selectedIndex == 0),
              _buildNavItem(context, 1, Icons.restaurant_menu_outlined,
                  Icons.restaurant_menu, 'Meals', selectedIndex == 1),
              const SizedBox(width: 80),
              _buildNavItem(context, 2, Icons.inventory_2_outlined,
                  Icons.inventory_2, 'Stock', selectedIndex == 2),
              _buildNavItem(context, 3, Icons.assignment_outlined,
                  Icons.assignment, 'Plan', selectedIndex == 3),
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
              color: T2Colors.bgDefault,
              child: Row(
                children: [
                  const SizedBox(width: 8),
                  Text('PRODIET',
                      style: GoogleFonts.barlowCondensed(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: T2Colors.lime)),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.more_vert_rounded,
                        color: Colors.white),
                    onPressed: () => _showMoreSheet(context, ref),
                  ),
                ],
              ),
            ),
          ),
          const Divider(color: T2Colors.border, height: 1, thickness: 1),
          Expanded(child: child),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, int index, IconData icon,
      IconData activeIcon, String label, bool isSelected) {
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
            Text(label,
                style: GoogleFonts.barlowCondensed(
                    color: color,
                    fontSize: 11,
                    fontWeight:
                        isSelected ? FontWeight.w700 : FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  void _showMoreSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: T2Colors.bgElevated,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                    color: T2Colors.border,
                    borderRadius: BorderRadius.circular(2))),
            _sheetItem(context, ctx, Icons.tune_rounded, 'Preferences',
                AppRoutes.t2Preferences),
            _sheetItem(context, ctx, Icons.restaurant_menu_outlined, 'Recipes',
                AppRoutes.t2Recipe),
            _sheetItem(context, ctx, Icons.store_outlined, 'Order & Restock',
                AppRoutes.t2Vendor),
            _sheetItem(context, ctx, Icons.watch_outlined, 'Fitband & Activity',
                AppRoutes.t2Fitband),
            const Divider(color: T2Colors.border, height: 28),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading:
                  const Icon(Icons.logout_rounded, color: Color(0xFFFF5C3A)),
              title: Text('Sign Out',
                  style: GoogleFonts.barlowCondensed(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
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

  Widget _sheetItem(BuildContext context, BuildContext sheetCtx, IconData icon,
      String label, String route) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: Colors.white),
      title: Text(label,
          style: GoogleFonts.barlowCondensed(
              fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white)),
      onTap: () {
        Navigator.pop(sheetCtx);
        context.go(route);
      },
    );
  }

  static int _calculateSelectedIndex(BuildContext context) {
    final loc = GoRouterState.of(context).uri.path;
    if (loc.startsWith(AppRoutes.t2Dashboard)) return 0;
    if (loc.startsWith(AppRoutes.t2Meals)) return 1;
    if (loc.startsWith(AppRoutes.t2Inventory)) return 2;
    if (loc.startsWith(AppRoutes.t2DietPlan)) return 3;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go(AppRoutes.t2Dashboard);
        break;
      case 1:
        context.go(AppRoutes.t2Meals);
        break;
      case 2:
        context.go(AppRoutes.t2Inventory);
        break;
      case 3:
        context.go(AppRoutes.t2DietPlan);
        break;
    }
  }
}
