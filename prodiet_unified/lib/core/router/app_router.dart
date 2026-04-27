// ═══════════════════════════════════════════════════════════
// UNIFIED ROUTER  —  Prompt 1 skeleton (routes added in Prompt 5)
// All route imports will be filled in after screens are placed
// in Prompts 3 & 4. This file is a compile-time placeholder.
// ═══════════════════════════════════════════════════════════
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> _rootKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

// Temporary single-route router so the app compiles during Prompt 1.
// Will be fully wired in Prompt 5.
final appRouter = GoRouter(
  navigatorKey: _rootKey,
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (_, __) => const _PlaceholderScreen(),
    ),
  ],
);

class _PlaceholderScreen extends StatelessWidget {
  const _PlaceholderScreen();
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'ProDiet Unified\nRoutes wiring in progress…',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
