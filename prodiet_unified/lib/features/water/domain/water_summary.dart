class WaterSummary {
  final int totalMl;
  final int targetMl;
  final int glasses;
  final int targetGlasses;

  const WaterSummary({
    required this.totalMl,
    required this.targetMl,
    required this.glasses,
    required this.targetGlasses,
  });

  double get percentFilled =>
      targetMl > 0 ? (totalMl / targetMl).clamp(0.0, 1.0) : 0.0;
  bool get isGoalReached => totalMl >= targetMl;

  factory WaterSummary.calculate(List<dynamic> logs, int targetMl) {
    int total = 0;
    for (var log in logs) {
      total += (log.amountMl as int);
    }
    return WaterSummary(
      totalMl: total,
      targetMl: targetMl,
      glasses: (total / 250).floor(),
      targetGlasses: (targetMl / 250).floor(),
    );
  }

  factory WaterSummary.empty(int targetMl) {
    return WaterSummary(
      totalMl: 0,
      targetMl: targetMl,
      glasses: 0,
      targetGlasses: (targetMl / 250).floor(),
    );
  }
}
