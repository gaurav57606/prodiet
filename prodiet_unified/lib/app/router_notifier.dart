import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prodiet_unified/features/auth/application/auth_providers.dart';
import 'package:prodiet_unified/core/theme/active_theme_provider.dart';

/// Bridges Riverpod auth and theme state changes into GoRouter's
/// refreshListenable so redirects fire automatically.
class RouterNotifier extends ChangeNotifier {
  RouterNotifier(Ref ref) {
    _listenToAuth(ref);
    _listenToTheme(ref);
  }

  void _listenToAuth(Ref ref) {
    ref.listen<AuthState>(
      authProvider,
      (_, __) => notifyListeners(),
      fireImmediately: true,
    );
  }

  void _listenToTheme(Ref ref) {
    ref.listen<ActiveTheme>(
      activeThemeProvider,
      (_, __) => notifyListeners(),
      fireImmediately: true,
    );
  }
}

final routerNotifierProvider = Provider<RouterNotifier>((ref) {
  return RouterNotifier(ref);
});
