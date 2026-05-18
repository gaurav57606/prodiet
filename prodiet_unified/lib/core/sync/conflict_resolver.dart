import 'package:prodiet_unified/core/sync/sync_logger.dart';

enum ConflictStrategy { clientWins, serverWins, merge }

class ConflictResolver {
  /// Resolves conflicts between local and remote data.
  /// 
  /// [localData] - The current state in the Drift database.
  /// [remoteData] - The state fetched from Supabase.
  /// [localUpdatedAt] - When the local record was last changed.
  /// [remoteUpdatedAt] - When the remote record was last changed.
  Map<String, dynamic> resolve({
    required Map<String, dynamic> localData,
    required Map<String, dynamic> remoteData,
    required DateTime localUpdatedAt,
    required DateTime remoteUpdatedAt,
    ConflictStrategy strategy = ConflictStrategy.clientWins,
  }) {
    final recordId = localData['id'] ?? remoteData['id'] ?? 'unknown';
    
    switch (strategy) {
      case ConflictStrategy.clientWins:
        if (localUpdatedAt.isAfter(remoteUpdatedAt)) {
          SyncLogger.logConflict('data', recordId, 'clientWins (local is newer)');
          return localData;
        } else {
          SyncLogger.logConflict('data', recordId, 'serverWins (server is newer)');
          return remoteData;
        }
      case ConflictStrategy.serverWins:
        SyncLogger.logConflict('data', recordId, 'serverWins (forced strategy)');
        return remoteData;
      case ConflictStrategy.merge:
        SyncLogger.logConflict('data', recordId, 'merge (combining fields)');
        final merged = <String, dynamic>{...remoteData, ...localData};
        // Ensure standard keys are correctly chosen based on newer time
        if (remoteUpdatedAt.isAfter(localUpdatedAt)) {
          merged['client_updated_at'] = remoteData['client_updated_at'] ?? remoteData['updated_at'];
          merged['updated_at'] = remoteData['updated_at'];
        } else {
          merged['client_updated_at'] = localData['client_updated_at'];
          merged['updated_at'] = remoteData['updated_at'];
        }
        return merged;
    }
  }

  /// Helper to extract/parse client_updated_at safely from a payload map.
  DateTime parseClientUpdatedAt(Map<String, dynamic> data) {
    final val = data['client_updated_at'] ?? data['updated_at'];
    if (val == null) return DateTime.fromMillisecondsSinceEpoch(0);
    if (val is DateTime) return val;
    try {
      return DateTime.parse(val.toString());
    } catch (_) {
      return DateTime.fromMillisecondsSinceEpoch(0);
    }
  }
}
