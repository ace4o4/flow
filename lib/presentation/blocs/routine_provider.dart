import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forgeflow/core/di/injection_container.dart';
import 'package:forgeflow/domain/entities/routine_entity.dart';
import 'package:forgeflow/domain/usecases/get_routines_usecase.dart';
import 'package:forgeflow/domain/usecases/save_routine_usecase.dart';

final routineListProvider =
    StateNotifierProvider<RoutineListNotifier, AsyncValue<List<RoutineEntity>>>(
        (ref) {
  return RoutineListNotifier(
    getRoutines: sl<GetRoutinesUseCase>(),
    saveRoutine: sl<SaveRoutineUseCase>(),
  );
});

class RoutineListNotifier
    extends StateNotifier<AsyncValue<List<RoutineEntity>>> {
  final GetRoutinesUseCase getRoutines;
  final SaveRoutineUseCase saveRoutine;

  RoutineListNotifier({
    required this.getRoutines,
    required this.saveRoutine,
  }) : super(const AsyncValue.loading()) {
    loadRoutines();
  }

  Future<void> loadRoutines() async {
    try {
      final routines = await getRoutines();
      state = AsyncValue.data(routines);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addRoutine(RoutineEntity routine) async {
    try {
      await saveRoutine(routine);
      // Reload or update locally
      final currentList = state.value ?? [];
      state = AsyncValue.data([...currentList, routine]);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
