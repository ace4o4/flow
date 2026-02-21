import 'package:forgeflow/domain/entities/track_record_entity.dart';
import 'package:forgeflow/domain/repositories/track_repository.dart';

class GetTrackRecordsUseCase {
  final TrackRepository repository;

  GetTrackRecordsUseCase(this.repository);

  Future<List<TrackRecordEntity>> call() async {
    return await repository.getTrackRecords();
  }

  Future<List<TrackRecordEntity>> byDate(String date) async {
    return await repository.getTrackRecordsByDate(date);
  }

  Future<List<TrackRecordEntity>> inRange(
      String startDate, String endDate) async {
    return await repository.getTrackRecordsInRange(startDate, endDate);
  }
}
