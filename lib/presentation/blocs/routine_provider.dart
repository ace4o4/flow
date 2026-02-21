import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forgeflow/core/di/injection_container.dart';

import 'package:forgeflow/domain/entities/routine_entity.dart';
import 'package:forgeflow/domain/repositories/routine_repository.dart';
import 'package:forgeflow/domain/usecases/get_routines_usecase.dart';
import 'package:forgeflow/domain/usecases/save_routine_usecase.dart';

final routineListProvider =
    StateNotifierProvider<RoutineListNotifier, AsyncValue<List<RoutineEntity>>>(
        (ref) {
  return RoutineListNotifier(
    getRoutines: sl<GetRoutinesUseCase>(),
    saveRoutine: sl<SaveRoutineUseCase>(),
    repository: sl<RoutineRepository>(),
  );
});

class RoutineListNotifier
    extends StateNotifier<AsyncValue<List<RoutineEntity>>> {
  final GetRoutinesUseCase getRoutines;
  final SaveRoutineUseCase saveRoutine;
  final RoutineRepository repository;

  RoutineListNotifier({
    required this.getRoutines,
    required this.saveRoutine,
    required this.repository,
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
      final currentList = state.value ?? [];
      state = AsyncValue.data([...currentList, routine]);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateRoutine(RoutineEntity routine) async {
    try {
      await saveRoutine(routine);
      final currentList = state.value ?? [];
      state = AsyncValue.data(
        currentList.map((r) => r.id == routine.id ? routine : r).toList(),
      );
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteRoutine(String id) async {
    try {
      await repository.deleteRoutine(id);
      final currentList = state.value ?? [];
      state = AsyncValue.data(
        currentList.where((r) => r.id != id).toList(),
      );
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void toggleBlockCompletion(String blockId) {
    final currentList = state.value ?? [];
    final updatedList = currentList.map((routine) {
      final updatedBlocks = routine.blocks.map((block) {
        if (block.id == blockId) {
          return block.copyWith(isCompleted: !block.isCompleted);
        }
        return block;
      }).toList();
      return routine.copyWith(blocks: updatedBlocks);
    }).toList();
    state = AsyncValue.data(updatedList);
  }

  /// Persist block toggle to Hive
  Future<void> toggleAndSaveBlock(String routineId, String blockId) async {
    toggleBlockCompletion(blockId);
    final routine = state.value?.firstWhere((r) => r.id == routineId);
    if (routine != null) {
      await saveRoutine(routine);
    }
  }
}
