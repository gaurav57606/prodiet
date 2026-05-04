import 'package:flutter_test/flutter_test.dart';
import 'package:prodiet_unified/features/water/domain/water_summary.dart';
import 'package:prodiet_unified/features/water/domain/water_log.dart';

void main() {
  group('WaterSummary', () {
    test('calculate should return correct total and percent', () {
      final logs = [
        WaterLog(id: '1', userId: 'u1', amountMl: 500, loggedAt: DateTime.now(), date: DateTime.now()),
        WaterLog(id: '2', userId: 'u1', amountMl: 250, loggedAt: DateTime.now(), date: DateTime.now()),
      ];

      final summary = WaterSummary.calculate(logs, 2000);

      expect(summary.totalMl, 750);
      expect(summary.targetMl, 2000);
      expect(summary.glasses, 3); // 750 / 250
      expect(summary.percentFilled, 0.375);
    });

    test('isGoalReached should be true when total >= target', () {
      const summary1 = WaterSummary(totalMl: 2000, targetMl: 2000, glasses: 8, targetGlasses: 8);
      const summary2 = WaterSummary(totalMl: 2100, targetMl: 2000, glasses: 8, targetGlasses: 8);
      const summary3 = WaterSummary(totalMl: 1900, targetMl: 2000, glasses: 7, targetGlasses: 8);

      expect(summary1.isGoalReached, true);
      expect(summary2.isGoalReached, true);
      expect(summary3.isGoalReached, false);
    });

    test('empty should return zero summary', () {
      final summary = WaterSummary.empty(1500);

      expect(summary.totalMl, 0);
      expect(summary.targetMl, 1500);
      expect(summary.glasses, 0);
      expect(summary.targetGlasses, 6);
    });
  });
}
