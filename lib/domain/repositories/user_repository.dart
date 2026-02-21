import 'package:forgeflow/domain/entities/user_profile_entity.dart';

abstract class UserRepository {
  Future<UserProfileEntity> getUserProfile();
  Future<void> saveUserProfile(UserProfileEntity profile);
}
