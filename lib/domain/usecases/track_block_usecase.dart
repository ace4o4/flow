import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:forgeflow/domain/entities/block_entity.dart';
import 'package:forgeflow/domain/entities/track_record_entity.dart';
import 'package:forgeflow/domain/entities/user_profile_entity.dart';
import 'package:forgeflow/domain/repositories/track_repository.dart';
import 'package:forgeflow/domain/repositories/user_repository.dart';
import 'package:forgeflow/core/utils/gamification_service.dart';

class TrackBlockUseCase {
  final TrackRepository trackRepository;
  final UserRepository userRepository;
  final GamificationService _gamification = GamificationService();

  TrackBlockUseCase({
    required this.trackRepository,
    required this.userRepository,
  });

  /// Check-in a block. Returns (TrackRecordEntity, updatedProfile)
  Future<(TrackRecordEntity, UserProfileEntity)> call({
    required BlockEntity block,
    required String routineId,
  }) async {
    final now = DateTime.now();
    final todayStr = DateFormat('yyyy-MM-dd').format(now);
    const uuid = Uuid();

    // Calculate punctuality
    int minutesLate = 0;
    PunctualityStatus status = PunctualityStatus.onTime;

    if (block.startTime != null) {
      final scheduled = DateTime(
        now.year,
        now.month,
        now.day,
        block.startTime!.hour,
        block.startTime!.minute,
      );
      minutesLate = now.difference(scheduled).inMinutes;

      if (minutesLate < -2) {
        status = PunctualityStatus.early;
      } else if (minutesLate <= 2) {
        status = PunctualityStatus.onTime;
        minutesLate = 0;
      } else {
        status = PunctualityStatus.late;
      }
    } else {
      status = PunctualityStatus.onTime;
    }

    final xp = _gamification.calculateXP(block.duration.inMinutes, minutesLate);

    final record = TrackRecordEntity(
      id: uuid.v4(),
      blockId: block.id,
      routineId: routineId,
      scheduledAt: block.startTime != null
          ? DateTime(now.year, now.month, now.day, block.startTime!.hour,
              block.startTime!.minute)
          : now,
      completedAt: now,
      xpEarned: xp,
      status: status,
      date: todayStr,
    );

    await trackRepository.saveTrackRecord(record);

    // Update user profile
    var profile = await userRepository.getUserProfile();
    profile = _gamification.updateStreak(profile, todayStr);
    profile = profile.copyWith(
      totalXP: profile.totalXP + xp,
    );

    // Check badges
    final todayRecords = await trackRepository.getTrackRecordsByDate(todayStr);
    final onTimeCount = todayRecords
        .where((r) =>
            r.status == PunctualityStatus.onTime ||
            r.status == PunctualityStatus.early)
        .length;
    final totalCount = todayRecords.length;
    final onTimeRate = totalCount > 0 ? onTimeCount / totalCount : 1.0;
    final newBadges = _gamification.checkBadges(profile, onTimeRate);
    profile = profile.copyWith(badges: newBadges);

    await userRepository.saveUserProfile(profile);

    return (record, profile);
  }
}
