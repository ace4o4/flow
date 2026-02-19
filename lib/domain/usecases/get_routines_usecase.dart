import 'package:forgeflow/domain/entities/routine_entity.dart';
import 'package:forgeflow/domain/repositories/routine_repository.dart';

class GetRoutinesUseCase {
  final RoutineRepository repository;

  GetRoutinesUseCase(this.repository);

  Future<List<RoutineEntity>> call() async {
    return await repository.getRoutines();
  }
}
