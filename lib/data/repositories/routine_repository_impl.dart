import 'package:hive/hive.dart';
import 'package:forgeflow/domain/entities/routine_entity.dart';
import 'package:forgeflow/domain/repositories/routine_repository.dart';
import 'package:forgeflow/data/models/routine_model.dart';

class RoutineRepositoryImpl implements RoutineRepository {
  final Box<RoutineModel> routineBox;

  RoutineRepositoryImpl(this.routineBox);

  @override
  Future<List<RoutineEntity>> getRoutines() async {
    return routineBox.values.toList();
  }

  @override
  Future<RoutineEntity?> getRoutineById(String id) async {
    try {
      return routineBox.values.firstWhere((element) => element.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> saveRoutine(RoutineEntity routine) async {
    final routineModel = RoutineModel.fromEntity(routine);
    await routineBox.put(routine.id, routineModel);
  }

  @override
  Future<void> deleteRoutine(String id) async {
    await routineBox.delete(id);
  }
}
