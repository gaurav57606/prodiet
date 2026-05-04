import 'weight_entry.dart';

class ProgressSummary {
  final List<WeightEntry> entries; // Sorted oldest -> newest
  final double targetWeightKg;
  final double currentWeightKg;
  final double startWeightKg;
  final int streakDays;

  const ProgressSummary({
    required this.entries,
    required this.targetWeightKg,
    required this.currentWeightKg,
    required this.startWeightKg,
    required this.streakDays,
  });

  factory ProgressSummary.empty() {
    return const ProgressSummary(
      entries: [],
      targetWeightKg: 0,
      currentWeightKg: 0,
      startWeightKg: 0,
      streakDays: 0,
    );
  }

  double get totalChange => currentWeightKg - startWeightKg;
  double get remainingToGoal => currentWeightKg - targetWeightKg;

  bool get isGoingRight {
    if (targetWeightKg < startWeightKg) {
      // Goal is weight loss
      return totalChange < 0;
    } else {
      // Goal is weight gain
      return totalChange > 0;
    }
  }

  factory ProgressSummary.calculate(List<WeightEntry> entries, double targetWeight, double initialWeight, [DateTime? now]) {
    if (entries.isEmpty) {
      return ProgressSummary(
        entries: [],
        targetWeightKg: targetWeight,
        currentWeightKg: initialWeight,
        startWeightKg: initialWeight,
        streakDays: 0,
      );
    }

    final sortedEntries = List<WeightEntry>.from(entries)..sort((a, b) => a.loggedAt.compareTo(b.loggedAt));
    final currentWeight = sortedEntries.last.weightKg;
    final startWeight = sortedEntries.first.weightKg;

    // Calculate streak
    int streak = 0;
    final currentNow = now ?? DateTime.now();
    final today = DateTime(currentNow.year, currentNow.month, currentNow.day);
    
    final entryDates = entries
        .map((e) => DateTime(e.loggedAt.year, e.loggedAt.month, e.loggedAt.day))
        .toSet();

    DateTime checkDate = today;
    while (entryDates.contains(checkDate)) {
      streak++;
      checkDate = checkDate.subtract(const Duration(days: 1));
    }

    // If today is missing but yesterday is present, streak is still active but not incremented today?
    // Usually streak needs today or yesterday. If today is missing, streak might be broken or pending.
    // Prompt says: "Count consecutive days from today backwards that have at least one weight_log entry"
    // So if today is missing, streak is 0 or check starts from yesterday?
    // I'll follow "today backwards".

    return ProgressSummary(
      entries: sortedEntries,
      targetWeightKg: targetWeight,
      currentWeightKg: currentWeight,
      startWeightKg: startWeight,
      streakDays: streak,
    );
  }
}
