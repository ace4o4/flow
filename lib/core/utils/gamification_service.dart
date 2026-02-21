import 'package:intl/intl.dart';
import 'package:forgeflow/domain/entities/user_profile_entity.dart';

class GamificationService {
  static final GamificationService _instance = GamificationService._internal();
  factory GamificationService() => _instance;
  GamificationService._internal();

  /// Calculate XP for completing a block
  /// [durationMinutes] = block duration
  /// [minutesLate] = negative = early, 0 = on time, positive = late
  int calculateXP(int durationMinutes, int minutesLate) {
    final int baseXP = durationMinutes;
    if (minutesLate < 0) {
      // Early: 10% bonus
      return (baseXP * 1.1).round();
    } else if (minutesLate == 0) {
      // On time: full XP
      return baseXP;
    } else {
      // Late: -5% per minute late, minimum 10% of base
      final penalty = 1.0 - (minutesLate * 0.05);
      return (baseXP * penalty.clamp(0.1, 1.0)).round();
    }
  }

  /// Level from total XP (500 XP per level)
  int currentLevel(int totalXP) {
    return (totalXP / 500).floor() + 1;
  }

  /// Update streak based on today's date vs last active date
  UserProfileEntity updateStreak(UserProfileEntity profile, String todayDate) {
    final today = DateFormat('yyyy-MM-dd').parse(todayDate);
    final lastActive = DateFormat('yyyy-MM-dd').parse(profile.lastActiveDate);
    final diff = today.difference(lastActive).inDays;

    if (diff == 0) {
      // Same day — no change
      return profile;
    } else if (diff == 1) {
      // Consecutive day — streak continues
      final newStreak = profile.currentStreak + 1;
      return profile.copyWith(
        currentStreak: newStreak,
        longestStreak: newStreak > profile.longestStreak
            ? newStreak
            : profile.longestStreak,
        lastActiveDate: todayDate,
      );
    } else {
      // Streak broken
      return profile.copyWith(
        currentStreak: 1,
        lastActiveDate: todayDate,
      );
    }
  }

  /// Check and award badges
  List<String> checkBadges(
      UserProfileEntity profile, double monthlyOnTimeRate) {
    final badges = List<String>.from(profile.badges);

    // Streak badges
    if (profile.currentStreak >= 3 && !badges.contains('streak_3')) {
      badges.add('streak_3');
    }
    if (profile.currentStreak >= 7 && !badges.contains('streak_7')) {
      badges.add('streak_7');
    }
    if (profile.currentStreak >= 30 && !badges.contains('streak_30')) {
      badges.add('streak_30');
    }

    // Punctuality badge
    if (monthlyOnTimeRate >= 0.9 && !badges.contains('punctual_pro')) {
      badges.add('punctual_pro');
    }

    // Level badges
    if (profile.currentLevel >= 5 && !badges.contains('level_5')) {
      badges.add('level_5');
    }
    if (profile.currentLevel >= 10 && !badges.contains('level_10')) {
      badges.add('level_10');
    }

    return badges;
  }
}
