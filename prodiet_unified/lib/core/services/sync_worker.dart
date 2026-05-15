import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prodiet_unified/core/data/local/app_database.dart';
import 'package:prodiet_unified/core/services/supabase_service.dart';
import 'package:logger/logger.dart';

class SyncWorker {
  final AppDatabase _db;
  final SupabaseService _supabase;
  final _logger = Logger();
  
  StreamSubscription? _connectivitySub;
  bool _isSyncing = false;

  SyncWorker(this._db, this._supabase);

  void initialize() {
    _connectivitySub = Connectivity().onConnectivityChanged.listen((result) {
      if (result != ConnectivityResult.none) {
        _logger.i('[SyncWorker] Connection restored, triggering sync...');
        performFullSync();
      }
    });
  }

  void dispose() {
    _connectivitySub?.cancel();
  }

  Future<void> performFullSync() async {
    if (_isSyncing) return;
    _isSyncing = true;
    
    try {
      await Future.wait([
        _syncMeals(),
        _syncWater(),
        _syncInventory(),
      ]);
      _logger.i('[SyncWorker] Full sync completed successfully');
    } catch (e) {
      _logger.e('[SyncWorker] Sync failed: $e');
    } finally {
      _isSyncing = false;
    }
  }

  Future<void> _syncMeals() async {
    final userId = _supabase.currentUser?.id;
    if (userId == null) return;

    final unsynced = await _db.mealDao.getUnsynced(userId);
    if (unsynced.isEmpty) return;

    for (final meal in unsynced) {
      try {
        await _supabase.client.from('meals').upsert({
          'id': meal.id,
          'user_id': meal.userId,
          'name': meal.name,
          'calories': meal.calories,
          'protein_g': meal.proteinG,
          'carbs_g': meal.carbsG,
          'fat_g': meal.fatG,
          'status': meal.status,
          'planned_date': meal.date,
          'updated_at': DateTime.now().toIso8601String(),
        });
        await _db.mealDao.markSynced([meal.id]);
      } catch (e) {
        _logger.e('[SyncWorker] Failed to sync meal ${meal.id}: $e');
      }
    }
  }

  Future<void> _syncWater() async {
    final userId = _supabase.currentUser?.id;
    if (userId == null) return;

    final unsynced = await _db.waterDao.getUnsynced(userId);
    if (unsynced.isEmpty) return;

    for (final log in unsynced) {
      try {
        await _supabase.client.from('water_logs').upsert({
          'id': log.id,
          'user_id': log.userId,
          'amount_ml': log.amountMl,
          'date': log.date,
          'logged_at': log.loggedAt,
        });
        await _db.waterDao.markSynced([log.id]);
      } catch (e) {
        _logger.e('[SyncWorker] Failed to sync water log ${log.id}: $e');
      }
    }
  }

  Future<void> _syncInventory() async {
    final userId = _supabase.currentUser?.id;
    if (userId == null) return;

    final unsynced = await _db.inventoryDao.getUnsynced(userId);
    if (unsynced.isEmpty) return;

    for (final item in unsynced) {
      try {
        await _supabase.client.from('inventory').upsert({
          'id': item.id,
          'user_id': item.userId,
          'name': item.name,
          'quantity': item.quantity,
          'unit': item.unit,
          'category': item.category,
          'expiry_date': item.expiryDate,
          'updated_at': DateTime.now().toIso8601String(),
        });
        await _db.inventoryDao.markSynced([item.id]);
      } catch (e) {
        _logger.e('[SyncWorker] Failed to sync inventory item ${item.id}: $e');
      }
    }
  }
}

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

final syncWorkerProvider = Provider<SyncWorker>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final supabase = ref.watch(supabaseServiceProvider);
  return SyncWorker(db, supabase);
});
