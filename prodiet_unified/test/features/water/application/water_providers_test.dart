import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prodiet_unified/features/auth/application/auth_providers.dart';
import 'package:prodiet_unified/features/water/application/water_providers.dart';
import 'package:prodiet_unified/features/water/data/water_repository.dart';
import 'package:prodiet_unified/features/water/domain/water_summary.dart';
import 'package:prodiet_unified/features/water/domain/water_log.dart';

class MockWaterRepository extends Mock implements WaterRepository {}

void main() {
  late MockWaterRepository mockRepo;

  setUp(() {
    mockRepo = MockWaterRepository();
  });

  group('Water Providers', () {
    test('waterSummaryProvider should calculate summary from repository logs', () async {
      final tLogs = [
        WaterLog(id: '1', userId: 'u1', amountMl: 250, loggedAt: DateTime.now(), date: DateTime(2024, 1, 1)),
        WaterLog(id: '2', userId: 'u1', amountMl: 500, loggedAt: DateTime.now(), date: DateTime(2024, 1, 1)),
      ];

      when(() => mockRepo.watchTodayLogs('user_123'))
          .thenAnswer((_) => Stream.value(tLogs));

      final container = ProviderContainer(
        overrides: [
          waterRepositoryProvider.overrideWithValue(mockRepo),
          currentUserIdProvider.overrideWithValue('user_123'),
          userWaterTargetProvider.overrideWithValue(2000),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(waterSummaryProvider.future);

      expect(result.totalMl, 750);
      expect(result.targetMl, 2000);
      verify(() => mockRepo.watchTodayLogs('user_123')).called(1);
    });

    test('waterSummaryProvider should handle empty logs', () async {
      when(() => mockRepo.watchTodayLogs('user_123'))
          .thenAnswer((_) => Stream.value([]));

      final container = ProviderContainer(
        overrides: [
          waterRepositoryProvider.overrideWithValue(mockRepo),
          currentUserIdProvider.overrideWithValue('user_123'),
          userWaterTargetProvider.overrideWithValue(2000),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(waterSummaryProvider.future);

      expect(result.totalMl, 0);
      expect(result.targetMl, 2000);
    });
  });
}
