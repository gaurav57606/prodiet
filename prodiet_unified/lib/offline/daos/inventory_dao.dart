import 'package:drift/drift.dart';
import 'package:prodiet_unified/offline/app_database.dart';
import 'package:prodiet_unified/offline/tables/local_inventory_table.dart';

part 'inventory_dao.g.dart';

@DriftAccessor(tables: [LocalInventory])
class InventoryDao extends DatabaseAccessor<AppDatabase>
    with _$InventoryDaoMixin {
  InventoryDao(super.db);

  Future<List<LocalInventoryData>> getAll(String userId) =>
    (select(localInventory)
      ..where((i) => i.userId.equals(userId)))
      .get();

  Future<void> upsertItem(LocalInventoryCompanion entry) =>
    into(localInventory).insertOnConflictUpdate(entry);

  Future<void> deleteItem(String id) =>
    (delete(localInventory)..where((i) => i.id.equals(id))).go();

  Future<List<LocalInventoryData>> getUnsynced(String userId) =>
    (select(localInventory)
      ..where((i) => i.userId.equals(userId) & i.isSynced.equals(false)))
      .get();

  Future<void> markSynced(List<String> ids) =>
    (update(localInventory)..where((i) => i.id.isIn(ids)))
      .write(const LocalInventoryCompanion(isSynced: Value(true)));
}
