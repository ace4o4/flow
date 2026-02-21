import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:forgeflow/domain/entities/user_profile_entity.dart';
import 'package:forgeflow/domain/repositories/user_repository.dart';
import 'package:forgeflow/data/models/user_profile_model.dart';

class UserRepositoryImpl implements UserRepository {
  final Box<UserProfileModel> userBox;

  UserRepositoryImpl(this.userBox);

  static const _profileKey = 'default_user';

  @override
  Future<UserProfileEntity> getUserProfile() async {
    final model = userBox.get(_profileKey);
    if (model != null) {
      return model.toEntity();
    }
    // Create default profile
    final now = DateTime.now();
    final defaultProfile = UserProfileEntity(
      id: _profileKey,
      joinDate: now,
      lastActiveDate: DateFormat('yyyy-MM-dd').format(now),
    );
    await saveUserProfile(defaultProfile);
    return defaultProfile;
  }

  @override
  Future<void> saveUserProfile(UserProfileEntity profile) async {
    await userBox.put(_profileKey, UserProfileModel.fromEntity(profile));
  }
}
