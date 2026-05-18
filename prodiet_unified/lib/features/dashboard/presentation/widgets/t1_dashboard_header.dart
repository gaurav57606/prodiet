import 'package:flutter/material.dart';
import 'package:prodiet_unified/core/widgets/theme_toggle.dart';

class T1DashboardHeader extends StatelessWidget {
  const T1DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const SliverAppBar(
      floating: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Text('Dashboard'),
      actions: [
        ThemeToggle(),
        SizedBox(width: 8),
      ],
    );
  }
}
