import 'package:forgeflow/domain/entities/routine_entity.dart';
import 'package:forgeflow/domain/repositories/routine_repository.dart';

class SaveRoutineUseCase {
  final RoutineRepository repository;

  SaveRoutineUseCase(this.repository);

  Future<void> call(RoutineEntity routine) async {
    return await repository.saveRoutine(routine);
  }
}
