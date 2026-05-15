import 'package:drift/drift.dart';
import 'package:prodiet_unified/core/data/local/app_database.dart';
import 'package:prodiet_unified/core/services/supabase_service.dart';
import 'package:prodiet_unified/core/services/sync_worker.dart';
import 'package:uuid/uuid.dart';
import '../domain/water_log.dart';
import '../domain/water_summary.dart';

class WaterRepository {
  final SupabaseService _supabase;
  final AppDatabase _db;
  final SyncWorker _syncWorker;

  WaterRepository(this._supabase, this._db, this._syncWorker);

  Future<WaterSummary> getTodaySummary(String userId) async {
    final today = DateTime.now().toIso8601String().split('T')[0];
    
    // Hardened: Fetch user goal from Supabase (can be cached locally later)
    final userData = await _supabase.client
        .from('users')
        .select('daily_water_goal_ml')
        .eq('id', userId)
        .single();
        
    final targetMl = (userData['daily_water_goal_ml'] as num? ?? 2000).toInt();

    // Fetch total from local DB
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
    
    // 1. Write to local DB first (Optimistic)
    await _db.waterDao.insertLog(LocalWaterLogsCompanion(
      id: Value(id),
      userId: Value(userId),
      amountMl: Value(ml),
      date: Value(today),
      loggedAt: Value(now.toIso8601String()),
      isSynced: const Value(false),
    ));

    // 2. Trigger background sync (non-blocking)
    _syncWorker.performFullSync();
  }

  Future<void> deleteLog(String id) async {
    // 1. Delete locally
    await _db.waterDao.deleteLog(id);
    
    // 2. Attempt remote delete (Hardened: This should ideally be handled by the sync worker too)
    try {
      await _supabase.client.from('water_logs').delete().eq('id', id);
    } catch (_) {
      // If offline, the remote record might persist until a full reconciliation
    }
  }

  Stream<List<WaterLog>> watchTodayLogs(String userId) {
    final today = DateTime.now().toIso8601String().split('T')[0];

    // Hardened: Watch local Drift DB instead of Supabase Realtime
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
