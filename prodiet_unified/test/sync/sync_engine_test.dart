import 'package:flutter_test/flutter_test.dart';
import 'package:prodiet_unified/core/sync/conflict_resolver.dart';

void main() {
  late ConflictResolver resolver;

  setUp(() {
    resolver = ConflictResolver();
  });

  group('ConflictResolver - Date Parsing', () {
    test('parses dynamic DateTime, string ISO 8601, and null values gracefully', () {
      final now = DateTime.now();
      expect(resolver.parseClientUpdatedAt({'client_updated_at': now}), now);
      expect(resolver.parseClientUpdatedAt({'client_updated_at': now.toIso8601String()}), isA<DateTime>());
      expect(resolver.parseClientUpdatedAt({}), DateTime.fromMillisecondsSinceEpoch(0));
    });
  });

  group('ConflictResolver - Strategies', () {
    test('clientWins returns client data when client has newer timestamp', () {
      final localData = {'id': '1', 'name': 'Local Apple', 'client_updated_at': '2026-05-17T12:00:00Z'};
      final remoteData = {'id': '1', 'name': 'Remote Apple', 'updated_at': '2026-05-17T10:00:00Z'};
      
      final result = resolver.resolve(
        localData: localData,
        remoteData: remoteData,
        localUpdatedAt: DateTime.parse('2026-05-17T12:00:00Z'),
        remoteUpdatedAt: DateTime.parse('2026-05-17T10:00:00Z'),
        strategy: ConflictStrategy.clientWins,
      );

      expect(result['name'], 'Local Apple');
    });

    test('clientWins returns server data when server has newer timestamp', () {
      final localData = {'id': '1', 'name': 'Local Apple', 'client_updated_at': '2026-05-17T10:00:00Z'};
      final remoteData = {'id': '1', 'name': 'Remote Apple', 'updated_at': '2026-05-17T12:00:00Z'};
      
      final result = resolver.resolve(
        localData: localData,
        remoteData: remoteData,
        localUpdatedAt: DateTime.parse('2026-05-17T10:00:00Z'),
        remoteUpdatedAt: DateTime.parse('2026-05-17T12:00:00Z'),
        strategy: ConflictStrategy.clientWins,
      );

      expect(result['name'], 'Remote Apple');
    });

    test('serverWins always returns remote server data', () {
      final localData = {'id': '1', 'name': 'Local Apple', 'client_updated_at': '2026-05-17T15:00:00Z'};
      final remoteData = {'id': '1', 'name': 'Remote Apple', 'updated_at': '2026-05-17T10:00:00Z'};
      
      final result = resolver.resolve(
        localData: localData,
        remoteData: remoteData,
        localUpdatedAt: DateTime.parse('2026-05-17T15:00:00Z'),
        remoteUpdatedAt: DateTime.parse('2026-05-17T10:00:00Z'),
        strategy: ConflictStrategy.serverWins,
      );

      expect(result['name'], 'Remote Apple');
    });

    test('merge strategy blends local and remote data fields correctly', () {
      final localData = {'id': '1', 'name': 'Local Apple', 'category': 'Fruit'};
      final remoteData = {'id': '1', 'name': 'Remote Apple', 'unit': 'pieces'};
      
      final result = resolver.resolve(
        localData: localData,
        remoteData: remoteData,
        localUpdatedAt: DateTime.parse('2026-05-17T10:00:00Z'),
        remoteUpdatedAt: DateTime.parse('2026-05-17T11:00:00Z'),
        strategy: ConflictStrategy.merge,
      );

      expect(result['id'], '1');
      expect(result['name'], 'Local Apple'); // Local field wins conflict inside standard map spread
      expect(result['unit'], 'pieces');      // Blended remote field preserved
      expect(result['category'], 'Fruit');    // Local field preserved
    });
  });
}
