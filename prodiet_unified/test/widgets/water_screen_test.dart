import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';

import 'package:prodiet_unified/features/auth/application/auth_providers.dart';
import 'package:prodiet_unified/features/water/application/water_providers.dart';
import 'package:prodiet_unified/features/water/domain/water_summary.dart';
import 'package:prodiet_unified/features/water/domain/water_log.dart';
import 'package:prodiet_unified/features/water/presentation/screens/water_screen.dart';
import 'package:prodiet_unified/features/water/data/water_repository.dart';
import 'package:prodiet_unified/core/theme/active_theme_provider.dart';
import 'package:prodiet_unified/core/theme/app_theme.dart';
import 'package:prodiet_unified/core/theme/t1/t1_tokens.dart';
import 'package:prodiet_unified/core/theme/t2/t2_tokens.dart';

class MockWaterRepository extends Mock implements WaterRepository {}

class FakeActiveThemeNotifier extends ActiveThemeNotifier {
  final ActiveTheme _mockState;
  FakeActiveThemeNotifier(this._mockState);
  @override
  ActiveTheme build() => _mockState;
}

class FakeActiveThemeInitializedNotifier extends ActiveThemeInitializedNotifier {
  @override
  bool build() => true;
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    // Mock path_provider for GoogleFonts
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
            const MethodChannel('plugins.flutter.io/path_provider'),
            (methodCall) async {
      return '.';
    });
    // Safely ignore GoogleFonts HTTP requests
    GoogleFonts.config.allowRuntimeFetching = true;
  });

  const testSummary = WaterSummary(
    totalMl: 1500,
    targetMl: 2500,
    glasses: 6,
    targetGlasses: 10,
  );

  late MockWaterRepository mockWaterRepository;

  setUp(() {
    mockWaterRepository = MockWaterRepository();
    // Default mock behavior
    registerFallbackValue(DateTime.now());
    when(() => mockWaterRepository.watchTodayLogs(any()))
        .thenAnswer((_) => Stream.value([]));
  });

  Widget createWidgetUnderTest({
    ActiveTheme activeTheme = ActiveTheme.t2Dark,
    WaterSummary summary = testSummary,
    List<WaterLog> todayLogs = const [],
  }) {
    final tokens = (activeTheme == ActiveTheme.t2Dark ||
            activeTheme == ActiveTheme.t2Light ||
            activeTheme == ActiveTheme.t2Amoled)
        ? T2Tokens.dark
        : T1Tokens.dark;

    return ProviderScope(
      overrides: [
        waterSummaryProvider.overrideWith((ref) => Stream.value(summary)),
        todayWaterLogsProvider.overrideWith((ref) => Stream.value(todayLogs)),
        currentUserIdProvider.overrideWith((ref) => 'u1'),
        activeThemeProvider.overrideWith(() => FakeActiveThemeNotifier(activeTheme)),
        activeThemeInitializedProvider.overrideWith(() => FakeActiveThemeInitializedNotifier()),
        waterRepositoryProvider.overrideWithValue(mockWaterRepository),
      ],
      child: MaterialApp(
        theme: AppTheme.buildTheme(tokens, Brightness.dark),
        home: const WaterScreen(),
      ),
    );
  }

  group('WaterScreen Widget Tests - T2 Layout', () {
    testWidgets('renders hydration progress and glasses in T2', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(
        activeTheme: ActiveTheme.t2Dark,
      ));
      await tester.pumpAndSettle();

      // Check for the headline "WATER" in T2 Layout
      expect(find.text('WATER'), findsOneWidget);

      // Check for the progress text containing 1,500 and 2,500
      expect(find.textContaining('1,500', findRichText: true), findsWidgets);
      expect(find.textContaining('2,500', findRichText: true), findsWidgets);

      // Check for glasses left today (which is displayed as upper case)
      expect(find.text('4 GLASSES LEFT TODAY'), findsOneWidget); // 10 - 6 = 4
    });

    testWidgets('shows empty state when no water logged in T2', (tester) async {
      final emptySummary = WaterSummary.empty(2500);
      await tester.pumpWidget(createWidgetUnderTest(
        activeTheme: ActiveTheme.t2Dark,
        summary: emptySummary,
      ));
      await tester.pumpAndSettle();

      // When totalMl is 0, the screen shows empty state with EmptyStateConfigs.water values
      expect(find.text('Stay hydrated today'), findsOneWidget);
      expect(find.text('Log your first glass. Your goal is 8 glasses a day.'), findsOneWidget);
    });
  });

  group('WaterScreen Widget Tests - T1 Layout', () {
    testWidgets('renders hydration progress in T1', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(
        activeTheme: ActiveTheme.t1Dark,
      ));
      await tester.pumpAndSettle();

      // In T1 Layout, Appbar title is "Hydration Details"
      expect(find.text('Hydration Details'), findsOneWidget);

      // "WATER" big text is NOT rendered in T1
      expect(find.text('WATER'), findsNothing);

      // We should see total consumed and target in linear progress or accent card text
      expect(find.text('1,500'), findsOneWidget);
      expect(find.text('OF 2,500 ML TARGET'), findsOneWidget);
    });
  });
}
