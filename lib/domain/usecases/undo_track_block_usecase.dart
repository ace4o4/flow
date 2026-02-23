import 'package:forgeflow/domain/entities/track_record_entity.dart';
import 'package:forgeflow/domain/entities/user_profile_entity.dart';
import 'package:forgeflow/domain/repositories/track_repository.dart';
import 'package:forgeflow/domain/repositories/user_repository.dart';

class UndoTrackBlockUseCase {
  final TrackRepository trackRepository;
  final UserRepository userRepository;

  UndoTrackBlockUseCase({
    required this.trackRepository,
    required this.userRepository,
  });

  Future<UserProfileEntity> call(TrackRecordEntity record) async {
    // 1. Delete the record
    await trackRepository.deleteTrackRecord(record.id);

    // 2. Revert the XP from the user profile
    var profile = await userRepository.getUserProfile();
    profile = profile.copyWith(
      totalXP: (profile.totalXP - record.xpEarned)
          .clamp(0, 99999999), // Prevent negative XP
    );
    await userRepository.saveUserProfile(profile);

    return profile;
  }
}
