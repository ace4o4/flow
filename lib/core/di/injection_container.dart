import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:forgeflow/data/models/block_model.dart';
import 'package:forgeflow/data/models/routine_model.dart';
import 'package:forgeflow/data/models/track_record_model.dart';
import 'package:forgeflow/data/models/user_profile_model.dart';
import 'package:forgeflow/data/repositories/routine_repository_impl.dart';
import 'package:forgeflow/data/repositories/track_repository_impl.dart';
import 'package:forgeflow/data/repositories/user_repository_impl.dart';
import 'package:forgeflow/domain/repositories/routine_repository.dart';
import 'package:forgeflow/domain/repositories/track_repository.dart';
import 'package:forgeflow/domain/repositories/user_repository.dart';
import 'package:forgeflow/domain/usecases/get_routines_usecase.dart';
import 'package:forgeflow/domain/usecases/save_routine_usecase.dart';
import 'package:forgeflow/domain/usecases/track_block_usecase.dart';
import 'package:forgeflow/domain/usecases/get_track_records_usecase.dart';
import 'package:forgeflow/domain/usecases/get_user_profile_usecase.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ── External: Hive ──
  await Hive.initFlutter();
  Hive.registerAdapter(BlockModelAdapter());
  Hive.registerAdapter(RoutineModelAdapter());
  Hive.registerAdapter(TrackRecordModelAdapter());
  Hive.registerAdapter(UserProfileModelAdapter());

  final routineBox = await Hive.openBox<RoutineModel>('routines');
  final trackBox = await Hive.openBox<TrackRecordModel>('tracks');
  final userBox = await Hive.openBox<UserProfileModel>('user_profile');

  sl.registerLazySingleton(() => routineBox);
  sl.registerLazySingleton(() => trackBox);
  sl.registerLazySingleton(() => userBox);

  // ── Repositories ──
  sl.registerLazySingleton<RoutineRepository>(
      () => RoutineRepositoryImpl(sl()));
  sl.registerLazySingleton<TrackRepository>(
      () => TrackRepositoryImpl(sl()));
  sl.registerLazySingleton<UserRepository>(
      () => UserRepositoryImpl(sl()));

  // ── Use Cases ──
  sl.registerLazySingleton(() => GetRoutinesUseCase(sl()));
  sl.registerLazySingleton(() => SaveRoutineUseCase(sl()));
  sl.registerLazySingleton(() => TrackBlockUseCase(
        trackRepository: sl(),
        userRepository: sl(),
      ));
  sl.registerLazySingleton(() => GetTrackRecordsUseCase(sl()));
  sl.registerLazySingleton(() => GetUserProfileUseCase(sl()));
}
