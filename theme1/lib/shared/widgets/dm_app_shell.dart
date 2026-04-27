import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/router/app_router.dart';

class DmAppShell extends StatefulWidget {
  final Widget child;

  const DmAppShell({super.key, required this.child});

  @override
  State<DmAppShell> createState() => _DmAppShellState();
}

class _DmAppShellState extends State<DmAppShell> {
  int get _currentIndex {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith(AppRoutes.dashboard)) return 0;
    if (location.startsWith(AppRoutes.mealPlanner)) return 1;
    if (location.startsWith(AppRoutes.inventory)) return 2;
    if (location.startsWith(AppRoutes.dietPlan)) return 3;
    return 0;
  }

  void _onTap(int index) {
    switch (index) {
      case 0:
        context.go(AppRoutes.dashboard);
        break;
      case 1:
        context.go(AppRoutes.mealPlanner);
        break;
      case 2:
        context.go(AppRoutes.inventory);
        break;
      case 3:
        context.go(AppRoutes.dietPlan);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      extendBody: true,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFF8B5CF6),
        elevation: 6,
        shape: const CircleBorder(),
        child: const Icon(Icons.mic_rounded, color: Colors.white, size: 28),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFF0A0A0F),
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        padding: EdgeInsets.zero,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _navItem(context, Icons.home_rounded, Icons.home_outlined, 'Home', 0),
            _navItem(context, Icons.restaurant_rounded, Icons.restaurant_outlined, 'Meals', 1),
            const SizedBox(width: 56), // space for FAB
            _navItem(context, Icons.inventory_2_rounded, Icons.inventory_2_outlined, 'Stock', 2),
            _navItem(context, Icons.calendar_month_rounded, Icons.calendar_month_outlined, 'Plan', 3),
          ],
        ),
      ),
    );
  }

  Widget _navItem(BuildContext ctx, IconData filled, IconData outlined, 
                  String label, int index) {
    final isActive = _currentIndex == index;
    const activeColor = Color(0xFF8B5CF6);
    const inactiveColor = Color(0x40FFFFFF);
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
            style: TextStyle(
              fontFamily: 'Outfit',
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
