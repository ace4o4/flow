import 'package:forgeflow/domain/entities/track_record_entity.dart';

abstract class TrackRepository {
  Future<List<TrackRecordEntity>> getTrackRecords();
  Future<List<TrackRecordEntity>> getTrackRecordsByDate(String date);
  Future<List<TrackRecordEntity>> getTrackRecordsInRange(
      String startDate, String endDate);
  Future<void> saveTrackRecord(TrackRecordEntity record);
  Future<void> deleteTrackRecord(String id);
}
