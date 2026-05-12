import 'package:drift/drift.dart';
import 'package:prodiet_unified/core/data/local/app_database.dart';
import 'package:prodiet_unified/core/data/local/tables/local_water_table.dart';

part 'water_dao.g.dart';

@DriftAccessor(tables: [LocalWaterLogs])
class WaterDao extends DatabaseAccessor<AppDatabase> with _$WaterDaoMixin {
  WaterDao(super.db);

  Future<int> getTodayTotal(String userId, String date) async {
    final logs = await (select(localWaterLogs)
      ..where((w) =>
        w.userId.equals(userId) &
        w.loggedAt.like('$date%')))
      .get();
    return logs.fold<int>(0, (sum, l) => sum + l.amountMl);
  }

  Future<void> insertLog(LocalWaterLogsCompanion entry) =>
    into(localWaterLogs).insert(entry);

  Future<void> deleteLog(String id) =>
    (delete(localWaterLogs)..where((w) => w.id.equals(id))).go();

  Future<List<LocalWaterLog>> getUnsynced(String userId) =>
    (select(localWaterLogs)
      ..where((w) => w.userId.equals(userId) & w.isSynced.equals(false)))
      .get();

  Future<void> markSynced(List<String> ids) =>
    (update(localWaterLogs)..where((w) => w.id.isIn(ids)))
      .write(const LocalWaterLogsCompanion(isSynced: Value(true)));
}

