class Achievement {
  final String id;
  final String userId;
  final String type;
  final String title;
  final String description;
  final String earnedAt;
  final int streakCount;
  final String badgeImagePath;

  const Achievement({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.description,
    required this.earnedAt,
    required this.streakCount,
    required this.badgeImagePath,
  });

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'],
      userId: json['user_id'],
      type: json['type'],
      title: json['title'],
      description: json['description'],
      earnedAt: json['earned_at'],
      streakCount: (json['streak_count'] as num? ?? 0).toInt(),
      badgeImagePath: json['badge_image_path'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'type': type,
      'title': title,
      'description': description,
      'earned_at': earnedAt,
      'streak_count': streakCount,
      'badge_image_path': badgeImagePath,
    };
  }
}
