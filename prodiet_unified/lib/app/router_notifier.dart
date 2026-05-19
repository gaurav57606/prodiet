import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prodiet_unified/app/navigation_state.dart';

/// Bridges Riverpod navigation state machine changes into GoRouter's
/// refreshListenable so redirects fire automatically and deterministically.
class RouterNotifier extends ChangeNotifier {
  RouterNotifier(Ref ref) {
    _listenToNavigationState(ref);
  }

  void _listenToNavigationState(Ref ref) {
    ref.listen<AppNavigationState>(
      navigationStateProvider,
      (_, __) {
        notifyListeners();
      },
      fireImmediately: true,
    );
  }
}

final routerNotifierProvider = Provider<RouterNotifier>((ref) {
  return RouterNotifier(ref);
});

