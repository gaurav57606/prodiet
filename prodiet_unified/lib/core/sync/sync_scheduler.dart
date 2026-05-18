import 'dart:async';
import 'package:prodiet_unified/core/sync/connection_monitor.dart';

class SyncScheduler {
  final ConnectionMonitor _monitor;
  final Future<void> Function() _onSyncTrigger;
  
  Timer? _periodicTimer;
  Timer? _debounceTimer;
  StreamSubscription? _connectionSub;

  SyncScheduler({
    required ConnectionMonitor monitor,
    required Future<void> Function() onSyncTrigger,
  }) : _monitor = monitor,
       _onSyncTrigger = onSyncTrigger;

  void start() {
    // 1. Periodic sync every 45 seconds when online
    _periodicTimer = Timer.periodic(const Duration(seconds: 45), (_) {
      triggerDebounced();
    });

    // 2. Immediate sync on connection restored
    _connectionSub = _monitor.statusChanges.listen((status) {
      if (status == ConnectionStatus.online) {
        triggerNow();
      }
    });

    // 3. Initial trigger
    triggerNow();
  }

  void stop() {
    _periodicTimer?.cancel();
    _debounceTimer?.cancel();
    _connectionSub?.cancel();
  }

  /// Debounce consecutive sync triggers to avoid overlapping processing sweeps
  void triggerDebounced() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 1500), () {
      _onSyncTrigger();
    });
  }

  /// Trigger sync immediately
  void triggerNow() {
    _debounceTimer?.cancel();
    _onSyncTrigger();
  }
}
