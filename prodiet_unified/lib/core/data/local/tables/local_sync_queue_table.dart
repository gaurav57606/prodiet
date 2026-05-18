import 'package:drift/drift.dart';

class LocalSyncQueue extends Table {
  IntColumn get id => integer().autoIncrement()();
  
  /// Type of operation: 'insert', 'update', 'delete'
  TextColumn get operation => text()();
  
  /// Target table: 'meals', 'inventory', 'water'
  TextColumn get targetTable => text()();
  
  /// The local ID of the record being synced
  TextColumn get recordId => text()();
  
  /// JSON payload of the changes/record
  TextColumn get payloadJson => text()();
  
  /// High priority tasks (like direct user actions) are processed first
  IntColumn get priority => integer().withDefault(const Constant(0))();
  
  /// Number of times this task has failed
  IntColumn get retryCount => integer().withDefault(const Constant(0))();
  
  /// Last error message if failed
  TextColumn get lastError => text().nullable()();
  
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  
  /// When this task should be retried (for exponential backoff)
  DateTimeColumn get nextRetryAt => dateTime().nullable()();
}
