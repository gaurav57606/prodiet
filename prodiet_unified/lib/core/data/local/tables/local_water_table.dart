import 'package:drift/drift.dart';

class LocalWaterLogs extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  IntColumn get amountMl => integer()();
  TextColumn get loggedAt => text()(); // ISO datetime
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
