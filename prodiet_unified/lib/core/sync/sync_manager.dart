import 'dart:async';
import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:prodiet_unified/core/data/local/app_database.dart';
import 'package:prodiet_unified/core/sync/connection_monitor.dart';
import 'package:prodiet_unified/core/sync/sync_queue.dart';
import 'package:prodiet_unified/core/sync/sync_task.dart';
import 'package:prodiet_unified/core/sync/retry_policy.dart';
import 'package:prodiet_unified/core/sync/sync_logger.dart';
import 'package:prodiet_unified/core/sync/conflict_resolver.dart';
import 'package:prodiet_unified/core/sync/sync_scheduler.dart';
import 'package:prodiet_unified/core/services/supabase_service.dart';

class SyncManager {
  final SyncQueue _queue;
  final SupabaseService _supabase;
  final ConnectionMonitor _monitor;
  final AppDatabase _db;
  final RetryPolicy _retryPolicy;
  final ConflictResolver _conflictResolver;
  late final SyncScheduler _scheduler;
  
  bool _isProcessing = false;

  SyncManager({
    required SyncQueue queue,
    required SupabaseService supabase,
    required ConnectionMonitor monitor,
    required AppDatabase db,
    RetryPolicy? retryPolicy,
    ConflictResolver? conflictResolver,
  }) : _queue = queue,
       _supabase = supabase,
       _monitor = monitor,
       _db = db,
       _retryPolicy = retryPolicy ?? RetryPolicy.defaultPolicy,
       _conflictResolver = conflictResolver ?? ConflictResolver() {
    _scheduler = SyncScheduler(
      monitor: _monitor,
      onSyncTrigger: processQueue,
    );
  }

  void start() {
    _scheduler.start();
  }

  void stop() {
    _scheduler.stop();
  }

  void triggerSync() {
    _scheduler.triggerDebounced();
  }

  Future<void> processQueue() async {
    if (_isProcessing) return;
    
    final isOnline = await _monitor.isOnline();
    if (!isOnline) return;

    _isProcessing = true;

    try {
      final tasks = await _queue.getPendingTasks(limit: 10);
      if (tasks.isEmpty) return;

      SyncLogger.logBatchStarted(tasks.length);

      for (final task in tasks) {
        final startTime = DateTime.now();
        try {
          await _processTask(task);
          SyncLogger.logTaskSuccess(task, DateTime.now().difference(startTime));
        } catch (e) {
          await _handleTaskFailure(task, e);
          // FIFO Hardening: Break batch processing on failure to preserve chronological order
          break; 
        }
      }
      
      // If we successfully processed a full batch, schedule next sweep immediately
      if (tasks.length == 10) {
        Future.microtask(processQueue);
      }
    } catch (e) {
      // Catch-all to ensure the sync manager never crashes or leaks
    } finally {
      _isProcessing = false;
    }
  }

  Future<void> _processTask(SyncTask task) async {
    SyncLogger.logTaskStarted(task);
    
    final table = task.target.name;
    final data = task.payload;
    
    switch (task.operation) {
      case SyncOperation.insert:
      case SyncOperation.update:
        // Enterprise Strategy: Remote check + Timestamp Conflict Resolution
        final remoteRow = await _supabase.perform((client) async {
          return await client.from(table).select().eq('id', task.recordId).maybeSingle();
        }, context: 'sync.checkRemoteRow');
        
        if (remoteRow == null) {
          // No remote record exists, safe to push directly
          await _supabase.perform((client) async {
            await client.from(table).upsert(data);
          }, context: 'sync.insertRemoteRow');
          await _markLocalSynced(task.target, task.recordId);
        } else {
          // Conflict Resolution: compare local vs remote updated_at timestamps
          final localTime = _conflictResolver.parseClientUpdatedAt(data);
          final remoteTime = _conflictResolver.parseClientUpdatedAt(remoteRow);

          final resolved = _conflictResolver.resolve(
            localData: data,
            remoteData: remoteRow,
            localUpdatedAt: localTime,
            remoteUpdatedAt: remoteTime,
            strategy: ConflictStrategy.clientWins,
          );

          if (identical(resolved, data) || resolved['client_updated_at'] == data['client_updated_at']) {
            // Local wins: push local to remote
            await _supabase.perform((client) async {
              await client.from(table).upsert(data);
            }, context: 'sync.updateRemoteRow');
            await _markLocalSynced(task.target, task.recordId);
          } else {
            // Remote wins: update local database and drop local outbox task
            await _updateLocalDatabase(task.target, resolved);
          }
        }
        break;
        
      case SyncOperation.delete:
        await _supabase.perform((client) async {
          await client.from(table).delete().eq('id', task.recordId);
        }, context: 'sync.deleteRemoteRow');
        break;
    }

    await _queue.removeTask(task.id);
  }

  Future<void> _markLocalSynced(SyncTarget target, String recordId) async {
    switch (target) {
      case SyncTarget.meals:
        await _db.mealDao.markSynced([recordId]);
        break;
      case SyncTarget.water_logs:
        await _db.waterDao.markSynced([recordId]);
        break;
      case SyncTarget.inventory:
        await _db.inventoryDao.markSynced([recordId]);
        break;
      case SyncTarget.shopping_list:
        await _db.shoppingDao.markSynced([recordId]);
        break;
    }
  }

  Future<void> _updateLocalDatabase(SyncTarget target, Map<String, dynamic> remoteData) async {
    final now = DateTime.now();
    final clientUpdatedAtStr = remoteData['client_updated_at'] ?? remoteData['updated_at'];
    final clientUpdatedAt = clientUpdatedAtStr != null 
        ? DateTime.parse(clientUpdatedAtStr.toString()) 
        : now;

    switch (target) {
      case SyncTarget.meals:
        final id = remoteData['id'] as String;
        final ingredientsJson = remoteData['ingredients'] != null ? jsonEncode(remoteData['ingredients']) : null;
        final nutritionalValuesJson = jsonEncode({
          'calories': (remoteData['calories'] as num?)?.toDouble() ?? 0.0,
          'protein': (remoteData['protein_g'] as num?)?.toDouble() ?? 0.0,
          'carbs': (remoteData['carbs_g'] as num?)?.toDouble() ?? 0.0,
          'fat': (remoteData['fat_g'] as num?)?.toDouble() ?? 0.0,
        });
        
        await _db.mealDao.upsertMeal(LocalMealsCompanion(
          id: Value(id),
          userId: Value(remoteData['user_id'] as String),
          name: Value(remoteData['name'] as String),
          mealType: Value(remoteData['meal_type'] as String),
          status: Value(remoteData['status'] as String),
          date: Value(remoteData['planned_date'] as String),
          ingredientsJson: Value(ingredientsJson),
          nutritionalValuesJson: Value(nutritionalValuesJson),
          createdAt: Value(remoteData['created_at'] as String),
          updatedAt: Value(now),
          clientUpdatedAt: Value(clientUpdatedAt),
          isDirty: const Value(false),
        ));
        break;

      case SyncTarget.water_logs:
        final id = remoteData['id'] as String;
        await _db.waterDao.upsertLog(LocalWaterLogsCompanion(
          id: Value(id),
          userId: Value(remoteData['user_id'] as String),
          amountMl: Value((remoteData['amount_ml'] as num).toInt()),
          date: Value(remoteData['date'] as String),
          loggedAt: Value(remoteData['logged_at'] as String),
          updatedAt: Value(now),
          clientUpdatedAt: Value(clientUpdatedAt),
          isDirty: const Value(false),
        ));
        break;

      case SyncTarget.inventory:
        final id = remoteData['id'] as String;
        await _db.inventoryDao.upsertItem(LocalInventoryCompanion(
          id: Value(id),
          userId: Value(remoteData['user_id'] as String),
          ingredientName: Value(remoteData['ingredient_name'] as String),
          quantity: Value((remoteData['quantity'] as num).toDouble()),
          unit: Value(remoteData['unit'] as String),
          category: Value(remoteData['category'] as String?),
          reorderThreshold: Value((remoteData['reorder_threshold'] as num?)?.toDouble()),
          updatedAt: Value(now),
          clientUpdatedAt: Value(clientUpdatedAt),
          isDirty: const Value(false),
        ));
        break;

      case SyncTarget.shopping_list:
        final id = remoteData['id'] as String;
        await _db.shoppingDao.upsertItem(LocalShoppingListCompanion(
          id: Value(id),
          userId: Value(remoteData['user_id'] as String),
          ingredientName: Value(remoteData['ingredient_name'] as String),
          quantity: Value((remoteData['quantity'] as num).toDouble()),
          unit: Value(remoteData['unit'] as String),
          isPurchased: Value(remoteData['is_purchased'] as bool? ?? false),
          source: Value(remoteData['source'] as String? ?? 'manual'),
          isDirty: const Value(false),
          updatedAt: Value(now),
          clientUpdatedAt: Value(clientUpdatedAt),
        ));
        break;
    }
  }

  Future<void> _handleTaskFailure(SyncTask task, Object error) async {
    final nextRetryCount = task.retryCount + 1;
    
    // Check if error is network-related and mark connection degraded
    if (error.toString().contains('SocketException') || 
        error.toString().contains('TimeoutException') || 
        error.toString().contains('connection')) {
      _monitor.markDegraded();
    }

    if (_retryPolicy.shouldRetry(nextRetryCount)) {
      final nextRetryAt = DateTime.now().add(_retryPolicy.getNextDelay(nextRetryCount));
      SyncLogger.logTaskFailed(task, error, nextRetryCount, nextRetryAt);
      
      await _queue.updateRetry(
        task.id, 
        nextRetryCount, 
        nextRetryAt, 
        error.toString()
      );
    } else {
      // Max retries reached
      SyncLogger.logTaskFailed(task, 'MAX RETRIES REACHED: $error', nextRetryCount, null);
      await _queue.updateRetry(
        task.id,
        nextRetryCount,
        null, // No more retries
        'DEAD_LETTER: $error'
      );
    }
  }
}
