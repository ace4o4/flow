import 'package:hive/hive.dart';
import 'package:forgeflow/domain/entities/user_profile_entity.dart';

part 'user_profile_model.g.dart';

@HiveType(typeId: 3)
class UserProfileModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final int totalXP;
  @HiveField(2)
  final int currentStreak;
  @HiveField(3)
  final int longestStreak;
  @HiveField(4)
  final List<String> badges;
  @HiveField(5)
  final DateTime joinDate;
  @HiveField(6)
  final String lastActiveDate;

  UserProfileModel({
    required this.id,
    this.totalXP = 0,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.badges = const [],
    required this.joinDate,
    required this.lastActiveDate,
  });

  UserProfileEntity toEntity() {
    return UserProfileEntity(
      id: id,
      totalXP: totalXP,
      currentStreak: currentStreak,
      longestStreak: longestStreak,
      badges: badges,
      joinDate: joinDate,
      lastActiveDate: lastActiveDate,
    );
  }

  factory UserProfileModel.fromEntity(UserProfileEntity entity) {
    return UserProfileModel(
      id: entity.id,
      totalXP: entity.totalXP,
      currentStreak: entity.currentStreak,
      longestStreak: entity.longestStreak,
      badges: entity.badges,
      joinDate: entity.joinDate,
      lastActiveDate: entity.lastActiveDate,
    );
  }
}
