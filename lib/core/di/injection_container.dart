import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:forgeflow/data/models/block_model.dart';
import 'package:forgeflow/data/models/routine_model.dart';
import 'package:forgeflow/data/repositories/routine_repository_impl.dart';
import 'package:forgeflow/domain/repositories/routine_repository.dart';
import 'package:forgeflow/domain/usecases/get_routines_usecase.dart';
import 'package:forgeflow/domain/usecases/save_routine_usecase.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  await Hive.initFlutter();
  Hive.registerAdapter(BlockModelAdapter());
  Hive.registerAdapter(RoutineModelAdapter());

  final routineBox = await Hive.openBox<RoutineModel>('routines');
  sl.registerLazySingleton(() => routineBox);

  // Data Sources

  // Repositories
  sl.registerLazySingleton<RoutineRepository>(
      () => RoutineRepositoryImpl(sl()));

  // Use Cases
  sl.registerLazySingleton(() => GetRoutinesUseCase(sl()));
  sl.registerLazySingleton(() => SaveRoutineUseCase(sl()));

  // Blocs / State Management
}
