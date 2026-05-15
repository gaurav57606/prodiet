import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:prodiet_unified/core/data/local/sync_service.dart';
import 'package:prodiet_unified/core/observability/logger/app_logger.dart';

enum SyncStatus { idle, syncing, failed, offline }

class SyncManager {
  final SyncService _syncService;
  final Connectivity _connectivity;
  final String _userId;

  SyncStatus _status = SyncStatus.idle;
  SyncStatus get status => _status;

  final _statusController = StreamController<SyncStatus>.broadcast();
  Stream<SyncStatus> get statusStream => _statusController.stream;

  SyncManager(this._syncService, this._connectivity, this._userId) {
    _initConnectivityListener();
  }

  void _initConnectivityListener() {
    _connectivity.onConnectivityChanged.listen((result) {
      final isOnline = !result.contains(ConnectivityResult.none);
      if (isOnline && _status == SyncStatus.offline) {
        AppLogger.info('Network restored, triggering auto-sync');
        triggerSync();
      } else if (!isOnline) {
        _updateStatus(SyncStatus.offline);
      }
    });
  }

  Future<void> triggerSync() async {
    if (_status == SyncStatus.syncing) return;

    _updateStatus(SyncStatus.syncing);
    try {
      await _syncService.syncAll(_userId);
      _updateStatus(SyncStatus.idle);
    } catch (e, stack) {
      AppLogger.error('Sync failed', e, stack);
      _updateStatus(SyncStatus.failed);
    }
  }

  void _updateStatus(SyncStatus newStatus) {
    _status = newStatus;
    _statusController.add(_status);
  }

  void dispose() {
    _statusController.close();
  }
}
