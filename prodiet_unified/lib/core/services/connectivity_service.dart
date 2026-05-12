import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:prodiet_unified/core/data/local/offline_providers.dart';

enum ConnectivityStatus { online, offline }

class ConnectivityNotifier extends AsyncNotifier<ConnectivityStatus> {
  late StreamSubscription _sub;

  @override
  Future<ConnectivityStatus> build() async {
    final connectivity = Connectivity();
    final result = await connectivity.checkConnectivity();
    final initial = result.contains(ConnectivityResult.none)
        ? ConnectivityStatus.offline
        : ConnectivityStatus.online;

    _sub = connectivity.onConnectivityChanged.listen((results) {
      final isOnline = !results.contains(ConnectivityResult.none);
      state = AsyncData(isOnline ? ConnectivityStatus.online : ConnectivityStatus.offline);
      // When coming back online, trigger sync
      if (isOnline) {
        _triggerSync();
      }
    });

    ref.onDispose(() => _sub.cancel());
    return initial;
  }

  void _triggerSync() {
    // Read userId from auth state and trigger SyncService
    // This is fire-and-forget
    try {
      final supabase = Supabase.instance.client;
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) return;
      ref.read(syncServiceProvider).syncAll(userId);
    } catch (_) {}
  }
}

final connectivityProvider = AsyncNotifierProvider<ConnectivityNotifier, ConnectivityStatus>(
  ConnectivityNotifier.new,
);

