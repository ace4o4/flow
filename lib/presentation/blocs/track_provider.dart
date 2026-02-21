import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:forgeflow/core/di/injection_container.dart';
import 'package:forgeflow/domain/entities/block_entity.dart';
import 'package:forgeflow/domain/entities/track_record_entity.dart';
import 'package:forgeflow/domain/usecases/track_block_usecase.dart';
import 'package:forgeflow/domain/usecases/get_track_records_usecase.dart';
import 'package:forgeflow/presentation/blocs/user_profile_provider.dart';

/// Today's track records
final todayTrackRecordsProvider = StateNotifierProvider<TodayTrackNotifier,
    AsyncValue<List<TrackRecordEntity>>>((ref) {
  return TodayTrackNotifier(
    trackBlockUseCase: sl<TrackBlockUseCase>(),
    getTrackRecordsUseCase: sl<GetTrackRecordsUseCase>(),
    ref: ref,
  );
});

class TodayTrackNotifier
    extends StateNotifier<AsyncValue<List<TrackRecordEntity>>> {
  final TrackBlockUseCase trackBlockUseCase;
  final GetTrackRecordsUseCase getTrackRecordsUseCase;
  final Ref ref;

  TodayTrackNotifier({
    required this.trackBlockUseCase,
    required this.getTrackRecordsUseCase,
    required this.ref,
  }) : super(const AsyncValue.loading()) {
    loadTodayRecords();
  }

  String get _todayStr => DateFormat('yyyy-MM-dd').format(DateTime.now());

  Future<void> loadTodayRecords() async {
    try {
      final records = await getTrackRecordsUseCase.byDate(_todayStr);
      state = AsyncValue.data(records);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Check-in a block — returns XP earned
  Future<int> checkIn({
    required BlockEntity block,
    required String routineId,
  }) async {
    final (record, updatedProfile) = await trackBlockUseCase(
      block: block,
      routineId: routineId,
    );

    // Update local state
    final current = state.value ?? [];
    state = AsyncValue.data([...current, record]);

    // Update user profile provider
    ref.read(userProfileProvider.notifier).updateProfile(updatedProfile);

    return record.xpEarned;
  }

  bool isBlockCheckedIn(String blockId) {
    final records = state.value ?? [];
    return records.any((r) => r.blockId == blockId);
  }
}
