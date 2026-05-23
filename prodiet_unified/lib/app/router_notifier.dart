import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prodiet_unified/app/navigation_state.dart';
import 'package:prodiet_unified/core/observability/logger/app_logger.dart';

/// Bridges Riverpod navigation state machine changes into GoRouter's
/// refreshListenable so redirects fire automatically and deterministically.
class RouterNotifier extends ChangeNotifier {
  void triggerUpdate() {
    notifyListeners();
  }
}

final routerNotifierProvider = Provider<RouterNotifier>((ref) {
  final notifier = RouterNotifier();
  ref.listen<AppNavigationState>(
    navigationStateProvider,
    (previous, next) {
      AppLogger.debug('[RouterNotifier] navigationStateProvider changed from $previous to $next');
      notifier.triggerUpdate();
    },
    fireImmediately: true,
  );
  return notifier;
});

