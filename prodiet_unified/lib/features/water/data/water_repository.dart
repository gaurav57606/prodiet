import 'package:drift/drift.dart';
import 'package:prodiet_unified/core/data/local/app_database.dart';
import 'package:prodiet_unified/core/sync/sync_queue.dart';
import 'package:prodiet_unified/core/sync/sync_task.dart';
import 'package:prodiet_unified/core/services/supabase_service.dart';
import 'package:uuid/uuid.dart';
import '../domain/water_log.dart';
import '../domain/water_summary.dart';

class WaterRepository {
  final SupabaseService _supabase;
  final AppDatabase _db;
  final SyncQueueRepository _syncQueue;

  WaterRepository(this._supabase, this._db, this._syncQueue);

  Future<WaterSummary> getTodaySummary(String userId) async {
    final today = DateTime.now().toIso8601String().split('T')[0];
    
    // Fetch user goal (can be cached locally later)
    final userData = await _supabase.perform((client) async {
      return await client
          .from('users')
          .select('daily_water_goal_ml')
          .eq('id', userId)
          .single();
    }, context: 'water.getTodaySummary');
        
    final targetMl = (userData['daily_water_goal_ml'] as num? ?? 2000).toInt();

    // Fetch total from local DB (Single Source of Truth)
    final total = await _db.waterDao.getTodayTotal(userId, today);

    return WaterSummary(
      totalMl: total,
      targetMl: targetMl,
      glasses: (total / 250).floor(),
      targetGlasses: (targetMl / 250).floor(),
    );
  }

  Future<void> logCustomAmount(String userId, int ml) async {
    final now = DateTime.now();
    final today = now.toIso8601String().split('T')[0];
    final id = const Uuid().v4();
    
    // 1. Write to local DB first (Optimistic UI)
    await _db.waterDao.insertLog(LocalWaterLogsCompanion.insert(
      id: id,
      userId: userId,
      amountMl: ml,
      date: today,
      loggedAt: now.toIso8601String(),
      updatedAt: Value(now),
      clientUpdatedAt: Value(now),
      isDirty: const Value(true),
    ));

    // 2. Enqueue Sync Task
    await _syncQueue.enqueue(SyncTask(
      id: 0,
      createdAt: now,
      operation: SyncOperation.insert,
      target: SyncTarget.water_logs,
      recordId: id,
      payload: {
        'id': id,
        'user_id': userId,
        'amount_ml': ml,
        'date': today,
        'logged_at': now.toIso8601String(),
        'client_updated_at': now.toIso8601String(),
      },
    ));
  }

  Future<void> deleteLog(String id) async {
    // 1. Delete locally
    await _db.waterDao.deleteLog(id);
    
    // 2. Enqueue Sync Task for deletion
    await _syncQueue.enqueue(SyncTask(
      id: 0,
      createdAt: DateTime.now(),
      operation: SyncOperation.delete,
      target: SyncTarget.water_logs,
      recordId: id,
      payload: {},
    ));
  }

  Future<void> logGlass(String userId) async {
    await logCustomAmount(userId, 250);
  }

  Future<void> deleteLastLog(String userId) async {
    final today = DateTime.now().toIso8601String().split('T')[0];
    final lastLog = await _db.waterDao.getLastLog(userId, today);
    if (lastLog != null) {
      await deleteLog(lastLog.id);
    }
  }


  Stream<List<WaterLog>> watchTodayLogs(String userId) {
    final today = DateTime.now().toIso8601String().split('T')[0];

    // Watch local Drift DB
    return _db.waterDao.watchTodayLogs(userId, today).map((localLogs) {
      return localLogs.map((l) => WaterLog(
        id: l.id,
        userId: l.userId,
        amountMl: l.amountMl,
        loggedAt: DateTime.parse(l.loggedAt),
        date: DateTime.parse(l.date),
      )).toList();
    });
  }
}
