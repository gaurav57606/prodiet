import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prodiet_unified/features/dashboard/application/dashboard_providers.dart';
import 'package:prodiet_unified/features/dashboard/data/dashboard_repository.dart';
import 'package:prodiet_unified/features/dashboard/domain/models/dashboard_summary.dart';

class MockDashboardRepository extends Mock implements DashboardRepository {}

void main() {
  late MockDashboardRepository mockRepo;

  setUp(() {
    mockRepo = MockDashboardRepository();
  });

  group('Dashboard Providers', () {
    test('dashboardProvider should call repository with userId', () async {
      final tSummary = DashboardSummary.empty();

      when(() => mockRepo.getTodaySummary('user_123'))
          .thenAnswer((_) async => tSummary);

      final container = ProviderContainer(
        overrides: [
          dashboardRepositoryProvider.overrideWithValue(mockRepo),
          currentUserIdProvider.overrideWithValue('user_123'),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(dashboardProvider.future);

      expect(result, tSummary);
      verify(() => mockRepo.getTodaySummary('user_123')).called(1);
    });

    test('dashboardProvider should return empty summary when userId is empty', () async {
      final container = ProviderContainer(
        overrides: [
          dashboardRepositoryProvider.overrideWithValue(mockRepo),
          currentUserIdProvider.overrideWithValue(''),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(dashboardProvider.future);

      expect(result.caloriesConsumed, 0);
      verifyNever(() => mockRepo.getTodaySummary(any()));
    });
  });
}
