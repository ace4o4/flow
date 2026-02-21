class UserProfileEntity {
  final String id;
  final int totalXP;
  final int currentStreak;
  final int longestStreak;
  final List<String> badges;
  final DateTime joinDate;
  final String lastActiveDate; // YYYY-MM-DD

  UserProfileEntity({
    required this.id,
    this.totalXP = 0,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.badges = const [],
    required this.joinDate,
    required this.lastActiveDate,
  });

  int get currentLevel => (totalXP / 500).floor() + 1;

  int get xpForNextLevel => currentLevel * 500;

  double get levelProgress {
    final currentLevelXP = (currentLevel - 1) * 500;
    final nextLevelXP = currentLevel * 500;
    return (totalXP - currentLevelXP) / (nextLevelXP - currentLevelXP);
  }

  UserProfileEntity copyWith({
    String? id,
    int? totalXP,
    int? currentStreak,
    int? longestStreak,
    List<String>? badges,
    DateTime? joinDate,
    String? lastActiveDate,
  }) {
    return UserProfileEntity(
      id: id ?? this.id,
      totalXP: totalXP ?? this.totalXP,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      badges: badges ?? this.badges,
      joinDate: joinDate ?? this.joinDate,
      lastActiveDate: lastActiveDate ?? this.lastActiveDate,
    );
  }
}
