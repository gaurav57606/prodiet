import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prodiet_unified/core/data/local/app_database.dart';
import 'package:prodiet_unified/core/data/local/sync_service.dart';
import 'package:prodiet_unified/core/services/supabase_service.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final syncServiceProvider = Provider<SyncService>((ref) {
  return SyncService(
    ref.watch(appDatabaseProvider),
    ref.watch(supabaseServiceProvider),
    Connectivity(),
  );
});

