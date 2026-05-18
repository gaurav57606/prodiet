import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:prodiet_unified/core/data/local/app_database.dart';
import 'package:prodiet_unified/core/sync/sync_task.dart';

class SyncQueue {
  final AppDatabase _db;

  SyncQueue(this._db);

  /// Enqueue a new sync task
  Future<void> enqueue(SyncTask task) async {
    await _db.into(_db.localSyncQueue).insert(
      LocalSyncQueueCompanion.insert(
        operation: task.operation.name,
        targetTable: task.target.name,
        recordId: task.recordId,
        payloadJson: jsonEncode(task.payload),
        priority: Value(task.priority),
        createdAt: Value(task.createdAt),
      ),
    );
  }

  /// Get the next batch of tasks to process (FIFO)
  Future<List<SyncTask>> getPendingTasks({int limit = 10}) async {
    final now = DateTime.now();
    final query = _db.select(_db.localSyncQueue)
      ..where((t) => t.nextRetryAt.isNull() | t.nextRetryAt.isSmallerThanValue(now))
      ..orderBy([
        (t) => OrderingTerm(expression: t.priority, mode: OrderingMode.desc), 
        (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.asc)
      ])
      ..limit(limit);

    final rows = await query.get();
    return rows.map((row) => SyncTask(
      id: row.id,
      operation: SyncOperation.values.byName(row.operation),
      target: SyncTarget.values.byName(row.targetTable),
      recordId: row.recordId,
      payload: jsonDecode(row.payloadJson) as Map<String, dynamic>,
      priority: row.priority,
      retryCount: row.retryCount,
      lastError: row.lastError,
      createdAt: row.createdAt,
      nextRetryAt: row.nextRetryAt,
    )).toList();
  }

  /// Check count of pending tasks in queue
  Future<int> getPendingCount() async {
    final countExpr = _db.localSyncQueue.id.count();
    final query = _db.selectOnly(_db.localSyncQueue)..addColumns([countExpr]);
    final row = await query.getSingle();
    return row.read(countExpr) ?? 0;
  }

  /// Remove task from queue on success
  Future<void> removeTask(int id) async {
    await (_db.delete(_db.localSyncQueue)..where((t) => t.id.equals(id))).go();
  }

  /// Update retry properties of a task on failure
  Future<void> updateRetry(int id, int retryCount, DateTime? nextRetryAt, String error) async {
    await (_db.update(_db.localSyncQueue)..where((t) => t.id.equals(id))).write(
      LocalSyncQueueCompanion(
        retryCount: Value(retryCount),
        nextRetryAt: Value(nextRetryAt),
        lastError: Value(error),
      ),
    );
  }
}

/// Backward compatibility alias
typedef SyncQueueRepository = SyncQueue;
