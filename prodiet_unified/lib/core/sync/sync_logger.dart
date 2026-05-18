import 'package:prodiet_unified/core/observability/logger/app_logger.dart';
import 'package:prodiet_unified/core/sync/sync_task.dart';

class SyncLogger {
  static void logTaskStarted(SyncTask task) {
    AppLogger.info('[Sync] Starting: ${task.operation.name} on ${task.target.name} (${task.recordId})');
  }

  static void logTaskSuccess(SyncTask task, Duration duration) {
    AppLogger.info('[Sync] Success: ${task.target.name} (${task.recordId}) in ${duration.inMilliseconds}ms');
  }

  static void logTaskFailed(SyncTask task, Object error, int retryCount, DateTime? nextRetry) {
    AppLogger.error(
      '[Sync] Failed: ${task.target.name} (${task.recordId}). '
      'Retry #$retryCount. Next retry: ${nextRetry?.toIso8601String() ?? 'none'}',
      error: error,
      feature: 'sync_engine',
    );
  }

  static void logBatchStarted(int size) {
    AppLogger.info('[Sync] Processing batch of $size tasks');
  }

  static void logConflict(String target, String recordId, String strategy) {
    AppLogger.warning('[Sync] Conflict detected on $target ($recordId). Strategy: $strategy');
  }

  static void logQueueSize(int size) {
    if (size > 0) {
      AppLogger.info('[Sync] Queue size: $size');
    }
  }
}
