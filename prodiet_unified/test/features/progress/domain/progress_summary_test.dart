import 'package:flutter_test/flutter_test.dart';
import 'package:prodiet_unified/features/progress/domain/progress_summary.dart';
import 'package:prodiet_unified/features/progress/domain/weight_entry.dart';

void main() {
  group('ProgressSummary Model', () {
    test('calculate should return initial summary when no entries', () {
      final summary = ProgressSummary.calculate([], 70.0, 75.0);
      
      expect(summary.entries, isEmpty);
      expect(summary.currentWeightKg, 75.0);
      expect(summary.startWeightKg, 75.0);
      expect(summary.totalChange, 0.0);
      expect(summary.streakDays, 0);
    });

    test('calculate should correctly identify streak', () {
      final now = DateTime(2026, 5, 4);
      final entries = [
        WeightEntry(id: '1', userId: 'u1', weightKg: 80.0, loggedAt: DateTime(2026, 5, 4)),
        WeightEntry(id: '2', userId: 'u1', weightKg: 79.5, loggedAt: DateTime(2026, 5, 3)),
        WeightEntry(id: '3', userId: 'u1', weightKg: 79.0, loggedAt: DateTime(2026, 5, 2)),
        // Gap at May 1st
        WeightEntry(id: '4', userId: 'u1', weightKg: 78.5, loggedAt: DateTime(2026, 4, 30)),
      ];

      final summary = ProgressSummary.calculate(entries, 70.0, 80.0, now);
      
      expect(summary.streakDays, 3); // 4th, 3rd, 2nd
    });

    test('calculate should correctly identify total change and current weight', () {
      final entries = [
        WeightEntry(id: '1', userId: 'u1', weightKg: 85.0, loggedAt: DateTime(2026, 4, 1)),
        WeightEntry(id: '2', userId: 'u1', weightKg: 82.0, loggedAt: DateTime(2026, 4, 15)),
        WeightEntry(id: '3', userId: 'u1', weightKg: 80.0, loggedAt: DateTime(2026, 5, 1)),
      ];

      final summary = ProgressSummary.calculate(entries, 70.0, 85.0);
      
      expect(summary.startWeightKg, 85.0);
      expect(summary.currentWeightKg, 80.0);
      expect(summary.totalChange, -5.0);
      expect(summary.remainingToGoal, 10.0);
    });

    test('isGoingRight should return true for weight loss when losing weight', () {
      final entries = [
        WeightEntry(id: '1', userId: 'u1', weightKg: 100.0, loggedAt: DateTime(2026, 1, 1)),
        WeightEntry(id: '2', userId: 'u1', weightKg: 95.0, loggedAt: DateTime(2026, 1, 2)),
      ];
      final summary = ProgressSummary.calculate(entries, 80.0, 100.0);
      expect(summary.isGoingRight, isTrue);
    });

    test('isGoingRight should return true for weight gain when gaining weight', () {
      final entries = [
        WeightEntry(id: '1', userId: 'u1', weightKg: 60.0, loggedAt: DateTime(2026, 1, 1)),
        WeightEntry(id: '2', userId: 'u1', weightKg: 65.0, loggedAt: DateTime(2026, 1, 2)),
      ];
      final summary = ProgressSummary.calculate(entries, 75.0, 60.0);
      expect(summary.isGoingRight, isTrue);
    });
  });
}
