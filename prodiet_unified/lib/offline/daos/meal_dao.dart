import 'package:drift/drift.dart';
import 'package:prodiet_unified/offline/app_database.dart';
import 'package:prodiet_unified/offline/tables/local_meals_table.dart';

part 'meal_dao.g.dart';

@DriftAccessor(tables: [LocalMeals])
class MealDao extends DatabaseAccessor<AppDatabase> with _$MealDaoMixin {
  MealDao(super.db);

  // Fetch today's meals for userId
  Future<List<LocalMeal>> getTodayMeals(String userId, String date) =>
      (select(localMeals)
            ..where((m) => m.userId.equals(userId) & m.date.equals(date)))
          .get();

  // Insert or update a meal
  Future<void> upsertMeal(LocalMealsCompanion entry) =>
      into(localMeals).insertOnConflictUpdate(entry);

  // Update meal status (completed/missed)
  Future<void> updateStatus(String id, String status) =>
      (update(localMeals)..where((m) => m.id.equals(id)))
          .write(LocalMealsCompanion(status: Value(status)));

  // Get all unsynced meals
  Future<List<LocalMeal>> getUnsynced(String userId) => (select(localMeals)
        ..where((m) => m.userId.equals(userId) & m.isSynced.equals(false)))
      .get();

  // Mark as synced after upload
  Future<void> markSynced(List<String> ids) =>
      (update(localMeals)..where((m) => m.id.isIn(ids)))
          .write(const LocalMealsCompanion(isSynced: Value(true)));

  // Delete synced records older than 7 days to keep DB lean
  Future<void> pruneOldSynced() {
    final cutoff = DateTime.now().subtract(const Duration(days: 7));
    return (delete(localMeals)
          ..where((m) =>
              m.isSynced.equals(true) &
              m.date.isSmallerThanValue(cutoff.toIso8601String())))
        .go();
  }
}
