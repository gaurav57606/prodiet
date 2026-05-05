class PlanRateLimitException implements Exception {
  final String message;
  final int hoursRemaining;
  const PlanRateLimitException(this.message, {required this.hoursRemaining});
  
  @override
  String toString() => message;
}
