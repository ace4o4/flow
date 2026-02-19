class GamificationService {
  // Singleton pattern
  static final GamificationService _instance = GamificationService._internal();

  factory GamificationService() {
    return _instance;
  }

  GamificationService._internal();

  int calculateXP(int durationMinutes, bool isEarly) {
    final int baseXP = durationMinutes;
    if (isEarly) {
      return (baseXP * 1.1).round(); // 10% bonus
    }
    return baseXP;
  }

  // Placeholder for streaks and levels logic
  int currentLevel(int totalXP) {
    return (totalXP / 500).floor() + 1; // Level up every 500 XP
  }
}
