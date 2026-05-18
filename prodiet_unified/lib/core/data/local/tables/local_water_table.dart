import 'package:drift/drift.dart';

class LocalWaterLogs extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  IntColumn get amountMl => integer()();
  TextColumn get date => text()(); // YYYY-MM-DD
  TextColumn get loggedAt => text()(); // ISO datetime

  BoolColumn get isDirty => boolean().withDefault(const Constant(true))();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  DateTimeColumn get clientUpdatedAt => dateTime().withDefault(currentDateAndTime)();


  @override
  Set<Column> get primaryKey => {id};
}
