import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dietmate/core/utils/extensions.dart';

class MainShell extends StatelessWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _calculateSelectedIndex(context),
        onTap: (index) => _onItemTapped(index, context),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_rounded), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.restaurant_menu_rounded), label: 'Plans'),
          BottomNavigationBarItem(icon: Icon(Icons.add_box_rounded), label: 'Add'),
          BottomNavigationBarItem(icon: Icon(Icons.inventory_2_outlined), label: 'Stock'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline_rounded), label: 'Profile'),
        ],
      ),
    );
  }

  static int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith('/dashboard')) return 0;
    if (location.startsWith('/diet-plan')) return 1;
    if (location.startsWith('/ocr')) return 2;
    if (location.startsWith('/inventory')) return 3;
    if (location.startsWith('/progress')) return 4;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/dashboard');
        break;
      case 1:
        context.go('/diet-plan');
        break;
      case 2:
        context.go('/ocr');
        break;
      case 3:
        context.go('/inventory');
        break;
      case 4:
        context.go('/progress');
        break;
    }
  }
}

