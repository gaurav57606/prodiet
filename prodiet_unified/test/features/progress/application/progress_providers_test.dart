import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prodiet_unified/features/auth/application/auth_providers.dart';
import 'package:prodiet_unified/features/progress/application/progress_providers.dart';
import 'package:prodiet_unified/features/progress/data/progress_repository.dart';
import 'package:prodiet_unified/features/progress/domain/progress_summary.dart';

class MockProgressRepository extends Mock implements ProgressRepository {}

void main() {
  late MockProgressRepository mockRepo;

  setUp(() {
    mockRepo = MockProgressRepository();
  });

  group('Progress Providers', () {
    test('progressSummaryProvider should call repository with correct parameters', () async {
      const tSummary = ProgressSummary(
        entries: [],
        targetWeightKg: 70,
        currentWeightKg: 75,
        startWeightKg: 75,
        streakDays: 0,
      );

      when(() => mockRepo.getProgressSummary('user_123', days: 30))
          .thenAnswer((_) async => tSummary);

      final container = ProviderContainer(
        overrides: [
          progressRepositoryProvider.overrideWithValue(mockRepo),
          currentUserIdProvider.overrideWithValue('user_123'),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(progressSummaryProvider.future);

      expect(result, tSummary);
      verify(() => mockRepo.getProgressSummary('user_123', days: 30)).called(1);
    });

    test('progressSummaryProvider should react to selectedRangeProvider', () async {
      const tSummary = ProgressSummary(
        entries: [],
        targetWeightKg: 70,
        currentWeightKg: 75,
        startWeightKg: 75,
        streakDays: 0,
      );

      when(() => mockRepo.getProgressSummary('user_123', days: 90))
          .thenAnswer((_) async => tSummary);

      final container = ProviderContainer(
        overrides: [
          progressRepositoryProvider.overrideWithValue(mockRepo),
          currentUserIdProvider.overrideWithValue('user_123'),
          selectedRangeProvider.overrideWith((ref) => 90),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(progressSummaryProvider.future);

      expect(result, tSummary);
      verify(() => mockRepo.getProgressSummary('user_123', days: 90)).called(1);
    });
  });
}
