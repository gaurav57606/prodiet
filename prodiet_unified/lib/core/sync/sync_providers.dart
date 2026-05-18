import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prodiet_unified/core/data/local/offline_providers.dart';
import 'package:prodiet_unified/core/sync/connection_monitor.dart';
import 'package:prodiet_unified/core/sync/sync_queue.dart';
import 'package:prodiet_unified/core/sync/sync_manager.dart';
import 'package:prodiet_unified/core/services/supabase_service.dart';

final syncQueueRepositoryProvider = Provider<SyncQueueRepository>((ref) {
  return SyncQueueRepository(ref.watch(appDatabaseProvider));
});

final syncManagerProvider = Provider<SyncManager>((ref) {
  return SyncManager(
    queue: ref.watch(syncQueueRepositoryProvider),
    supabase: ref.watch(supabaseServiceProvider),
    monitor: ref.watch(connectionMonitorProvider.notifier),
    db: ref.watch(appDatabaseProvider),
  );
});
