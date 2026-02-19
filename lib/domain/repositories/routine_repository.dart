import 'package:forgeflow/domain/entities/routine_entity.dart';

abstract class RoutineRepository {
  Future<List<RoutineEntity>> getRoutines();
  Future<RoutineEntity?> getRoutineById(String id);
  Future<void> saveRoutine(RoutineEntity routine);
  Future<void> deleteRoutine(String id);
}
