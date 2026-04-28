class ProgressLog {
  final String id;
  final String userId;
  final double weightKg;
  final double? bodyFatPct;
  final String? notes;
  final String? photoUrl;
  final String loggedAt;

  const ProgressLog({
    required this.id,
    required this.userId,
    required this.weightKg,
    this.bodyFatPct,
    this.notes,
    this.photoUrl,
    required this.loggedAt,
  });

  factory ProgressLog.fromJson(Map<String, dynamic> json) {
    return ProgressLog(
      id: json['id'],
      userId: json['user_id'],
      weightKg: (json['weight_kg'] as num? ?? 0).toDouble(),
      bodyFatPct: (json['body_fat_pct'] as num?)?.toDouble(),
      notes: json['notes'],
      photoUrl: json['photo_url'],
      loggedAt: json['logged_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'weight_kg': weightKg,
      'body_fat_pct': bodyFatPct,
      'notes': notes,
      'photo_url': photoUrl,
      'logged_at': loggedAt,
    };
  }
}
