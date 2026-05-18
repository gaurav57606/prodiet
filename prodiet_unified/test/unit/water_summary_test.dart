import 'package:flutter_test/flutter_test.dart';
import 'package:prodiet_unified/features/water/domain/water_log.dart';
import 'package:prodiet_unified/features/water/domain/water_summary.dart';

void main() {
  // Helper to create a WaterLog with a given amount.
  WaterLog makeLog(int ml) => WaterLog(
        id: 'id_$ml',
        userId: 'u1',
        amountMl: ml,
        loggedAt: DateTime.now(),
        date: DateTime.now(),
      );

  group('WaterSummary.calculate', () {
    test('empty logs produce zero totals with correct target', () {
      final s = WaterSummary.calculate([], 2000);
      expect(s.totalMl,      0);
      expect(s.targetMl,     2000);
      expect(s.glasses,      0);
      expect(s.targetGlasses,8);    // 2000 / 250
      expect(s.percentFilled,0.0);
      expect(s.isGoalReached,false);
    });

    test('sums amountMl across multiple logs', () {
      final logs = [makeLog(250), makeLog(500), makeLog(250)];
      final s = WaterSummary.calculate(logs, 2000);
      expect(s.totalMl, 1000);
      expect(s.glasses,  4);   // 1000 / 250
    });

    test('percentFilled is exactly 0.5 at half goal', () {
      final s = WaterSummary.calculate([makeLog(1000)], 2000);
      expect(s.percentFilled, closeTo(0.5, 0.001));
    });

    test('percentFilled is clamped to 1.0 when over goal', () {
      final s = WaterSummary.calculate([makeLog(3000)], 2000);
      expect(s.percentFilled, 1.0);
    });

    test('percentFilled is 0.0 when targetMl is 0 (div-by-zero guard)', () {
      final s = WaterSummary.calculate([], 0);
      expect(s.percentFilled, 0.0);
    });

    test('isGoalReached is true exactly at goal', () {
      final s = WaterSummary.calculate([makeLog(2000)], 2000);
      expect(s.isGoalReached, true);
    });

    test('isGoalReached is true when over goal', () {
      final s = WaterSummary.calculate([makeLog(2500)], 2000);
      expect(s.isGoalReached, true);
    });

    test('isGoalReached is false when under goal', () {
      final s = WaterSummary.calculate([makeLog(1999)], 2000);
      expect(s.isGoalReached, false);
    });

    test('targetGlasses rounds down (2500ml target = 10 glasses)', () {
      final s = WaterSummary.calculate([], 2500);
      expect(s.targetGlasses, 10);
    });

    test('single log of exactly one glass', () {
      final s = WaterSummary.calculate([makeLog(250)], 2000);
      expect(s.glasses, 1);
      expect(s.totalMl, 250);
    });
  });

  group('WaterSummary.empty', () {
    test('creates all-zero summary with correct target and glasses', () {
      final s = WaterSummary.empty(3000);
      expect(s.totalMl,       0);
      expect(s.glasses,       0);
      expect(s.targetMl,      3000);
      expect(s.targetGlasses, 12);   // 3000 / 250
      expect(s.isGoalReached, false);
      expect(s.percentFilled, 0.0);
    });
  });

  group('WaterLog.fromJson', () {
    test('parses all fields correctly', () {
      final now  = DateTime(2026, 5, 5);
      final json = <String, dynamic>{
        'id':         'wl1',
        'userId':    'u1',
        'amountMl':  300,
        'loggedAt':  now.toIso8601String(),
        'date':       now.toIso8601String(),
      };
      final log = WaterLog.fromJson(json);
      expect(log.id,       'wl1');
      expect(log.userId,   'u1');
      expect(log.amountMl, 300);
    });
  });
}
