class WaterLog {
  final String id;
  final String userId;
  final int amountMl;
  final String loggedAt;
  final String date;

  const WaterLog({
    required this.id,
    required this.userId,
    required this.amountMl,
    required this.loggedAt,
    required this.date,
  });

  factory WaterLog.fromJson(Map<String, dynamic> json) {
    return WaterLog(
      id: json['id'],
      userId: json['user_id'],
      amountMl: (json['amount_ml'] as num? ?? 0).toInt(),
      loggedAt: json['logged_at'],
      date: json['date'] ?? (json['logged_at'] as String).split('T')[0],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'amount_ml': amountMl,
      'logged_at': loggedAt,
      'date': date,
    };
  }
}
