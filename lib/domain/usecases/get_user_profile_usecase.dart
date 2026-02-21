import 'package:forgeflow/domain/entities/user_profile_entity.dart';
import 'package:forgeflow/domain/repositories/user_repository.dart';

class GetUserProfileUseCase {
  final UserRepository repository;

  GetUserProfileUseCase(this.repository);

  Future<UserProfileEntity> call() async {
    return await repository.getUserProfile();
  }
}
