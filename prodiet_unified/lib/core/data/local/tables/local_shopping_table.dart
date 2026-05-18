import 'package:drift/drift.dart';

class LocalShoppingList extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get ingredientName => text()();
  RealColumn get quantity => real()();
  TextColumn get unit => text()();
  BoolColumn get isPurchased => boolean().withDefault(const Constant(false))();
  TextColumn get source => text().withDefault(const Constant('manual'))(); // 'manual', 'auto'
  
  BoolColumn get isDirty => boolean().withDefault(const Constant(true))();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  DateTimeColumn get clientUpdatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
