import 'package:drift/drift.dart';

class LocalMeals extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get name => text()();
  TextColumn get mealType => text()();
  // 'breakfast' | 'lunch' | 'dinner' | 'snack'
  TextColumn get status => text().withDefault(const Constant('scheduled'))();
  // 'scheduled' | 'completed' | 'missed'
  TextColumn get date => text()(); // ISO date string
  TextColumn get ingredientsJson => text().nullable()(); // JSON string
  TextColumn get nutritionalValuesJson => text().nullable()(); // JSON string
  TextColumn get scheduledTime => text().nullable()(); // HH:mm string
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  TextColumn get createdAt => text()();

  @override
  Set<Column> get primaryKey => {id};
}
