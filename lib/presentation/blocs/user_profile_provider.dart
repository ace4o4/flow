import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:forgeflow/core/di/injection_container.dart';
import 'package:forgeflow/domain/entities/user_profile_entity.dart';
import 'package:forgeflow/domain/usecases/get_user_profile_usecase.dart';
import 'package:forgeflow/domain/repositories/user_repository.dart';

final userProfileProvider =
    StateNotifierProvider<UserProfileNotifier, AsyncValue<UserProfileEntity>>(
        (ref) {
  return UserProfileNotifier(
    getUserProfile: sl<GetUserProfileUseCase>(),
    userRepository: sl<UserRepository>(),
  );
});

class UserProfileNotifier extends StateNotifier<AsyncValue<UserProfileEntity>> {
  final GetUserProfileUseCase getUserProfile;
  final UserRepository userRepository;

  UserProfileNotifier({
    required this.getUserProfile,
    required this.userRepository,
  }) : super(const AsyncValue.loading()) {
    loadProfile();
  }

  Future<void> loadProfile() async {
    try {
      final profile = await getUserProfile();
      state = AsyncValue.data(profile);
    } catch (e) {
      // Create default if fail
      final now = DateTime.now();
      state = AsyncValue.data(UserProfileEntity(
        id: 'default_user',
        joinDate: now,
        lastActiveDate: DateFormat('yyyy-MM-dd').format(now),
      ));
    }
  }

  void updateProfile(UserProfileEntity profile) {
    state = AsyncValue.data(profile);
  }

  Future<void> addXP(int xp) async {
    final current = state.value;
    if (current != null) {
      final updated = current.copyWith(totalXP: current.totalXP + xp);
      state = AsyncValue.data(updated);
      await userRepository.saveUserProfile(updated);
    }
  }
}
