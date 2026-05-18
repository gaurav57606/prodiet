import 'package:drift/drift.dart';

class LocalInventory extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get ingredientName => text()();
  RealColumn get quantity => real()();
  TextColumn get unit => text()();
  RealColumn get reorderThreshold => real().nullable()();
  IntColumn get shelfLifeDays => integer().nullable()();
  TextColumn get category => text().nullable()();
  TextColumn get lastRestocked => text().nullable()(); // ISO datetime
  BoolColumn get isDirty => boolean().withDefault(const Constant(true))();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  DateTimeColumn get clientUpdatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
