import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:logger/logger.dart';
import 'package:prodiet_unified/core/data/local/app_database.dart';

class SyncService {
  final AppDatabase _db;
  final SupabaseClient _supabase;
  final Connectivity _connectivity;
  final _logger = Logger();
  static const _tag = 'SyncService';

  SyncService(this._db, this._supabase, this._connectivity);

  // Call this on app resume + on connectivity restored
  Future<void> syncAll(String userId) async {
    final hasNet = await _isOnline();
    if (!hasNet) { 
      _logger.w('[$_tag] Offline — skipping sync'); 
      return; 
    }

    await Future.wait([
      _syncMeals(userId),
      _syncInventory(userId),
      _syncWater(userId),
    ]);
    _logger.i('[$_tag] Sync complete for $userId');
  }

  Future<void> _syncMeals(String userId) async {
    final unsynced = await _db.mealDao.getUnsynced(userId);
    if (unsynced.isEmpty) return;
    // Upsert all unsynced to Supabase meals table
    final rows = unsynced.map((m) => {
      'id': m.id, 'user_id': m.userId,
      'name': m.name, 'meal_type': m.mealType,
      'status': m.status, 'date': m.date,
    }).toList();
    await _supabase.from('meals').upsert(rows);
    await _db.mealDao.markSynced(unsynced.map((m) => m.id).toList());
    await _db.mealDao.pruneOldSynced();
  }

  Future<void> _syncInventory(String userId) async {
    final unsynced = await _db.inventoryDao.getUnsynced(userId);
    if (unsynced.isEmpty) return;
    final rows = unsynced.map((i) => {
      'id': i.id, 'user_id': i.userId,
      'ingredient_name': i.ingredientName,
      'quantity': i.quantity, 'unit': i.unit,
    }).toList();
    await _supabase.from('inventory').upsert(rows);
    await _db.inventoryDao.markSynced(unsynced.map((i) => i.id).toList());
  }

  Future<void> _syncWater(String userId) async {
    final unsynced = await _db.waterDao.getUnsynced(userId);
    if (unsynced.isEmpty) return;
    final rows = unsynced.map((w) => {
      'id': w.id, 'user_id': w.userId,
      'amount_ml': w.amountMl, 'logged_at': w.loggedAt,
    }).toList();
    await _supabase.from('water_logs').upsert(rows);
    await _db.waterDao.markSynced(unsynced.map((w) => w.id).toList());
  }

  Future<bool> _isOnline() async {
    final result = await _connectivity.checkConnectivity();
    // In connectivity_plus 6.0.0+, checkConnectivity returns List<ConnectivityResult>
    return !result.contains(ConnectivityResult.none);
  }
}

