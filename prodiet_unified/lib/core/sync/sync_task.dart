// ignore_for_file: constant_identifier_names
enum SyncOperation {
  insert,
  update,
  delete,
}

enum SyncTarget {
  meals,
  inventory,
  water_logs,
  shopping_list,
}

class SyncTask {
  final int id;
  final SyncOperation operation;
  final SyncTarget target;
  final String recordId;
  final Map<String, dynamic> payload;
  final int priority;
  final int retryCount;
  final String? lastError;
  final DateTime createdAt;
  final DateTime? nextRetryAt;

  const SyncTask({
    required this.id,
    required this.operation,
    required this.target,
    required this.recordId,
    required this.payload,
    this.priority = 0,
    this.retryCount = 0,
    this.lastError,
    required this.createdAt,
    this.nextRetryAt,
  });

  SyncTask copyWith({
    int? id,
    SyncOperation? operation,
    SyncTarget? target,
    String? recordId,
    Map<String, dynamic>? payload,
    int? priority,
    int? retryCount,
    String? lastError,
    DateTime? createdAt,
    DateTime? nextRetryAt,
  }) {
    return SyncTask(
      id: id ?? this.id,
      operation: operation ?? this.operation,
      target: target ?? this.target,
      recordId: recordId ?? this.recordId,
      payload: payload ?? this.payload,
      priority: priority ?? this.priority,
      retryCount: retryCount ?? this.retryCount,
      lastError: lastError ?? this.lastError,
      createdAt: createdAt ?? this.createdAt,
      nextRetryAt: nextRetryAt ?? this.nextRetryAt,
    );
  }
}
