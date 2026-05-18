import 'package:drift/drift.dart';
import 'package:prodiet_unified/core/data/local/app_database.dart';
import 'package:prodiet_unified/core/data/local/tables/local_shopping_table.dart';

part 'shopping_dao.g.dart';

@DriftAccessor(tables: [LocalShoppingList])
class ShoppingDao extends DatabaseAccessor<AppDatabase> with _$ShoppingDaoMixin {
  ShoppingDao(super.db);

  Stream<List<LocalShoppingListData>> watchList(String userId) =>
    (select(localShoppingList)
      ..where((s) => s.userId.equals(userId))
      ..orderBy([(s) => OrderingTerm.asc(s.ingredientName)]))
      .watch();

  Future<void> upsertItem(LocalShoppingListCompanion entry) =>
    into(localShoppingList).insertOnConflictUpdate(entry);

  Future<void> deleteItem(String id) =>
    (delete(localShoppingList)..where((s) => s.id.equals(id))).go();

  Future<List<LocalShoppingListData>> getUnsynced(String userId) =>
    (select(localShoppingList)
      ..where((s) => s.userId.equals(userId) & s.isDirty.equals(true)))
      .get();

  Future<void> markSynced(List<String> ids) =>
    (update(localShoppingList)..where((s) => s.id.isIn(ids)))
      .write(const LocalShoppingListCompanion(isDirty: Value(false)));
}
