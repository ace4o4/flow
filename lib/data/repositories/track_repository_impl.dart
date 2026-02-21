import 'package:hive/hive.dart';
import 'package:forgeflow/domain/entities/track_record_entity.dart';
import 'package:forgeflow/domain/repositories/track_repository.dart';
import 'package:forgeflow/data/models/track_record_model.dart';

class TrackRepositoryImpl implements TrackRepository {
  final Box<TrackRecordModel> trackBox;

  TrackRepositoryImpl(this.trackBox);

  @override
  Future<List<TrackRecordEntity>> getTrackRecords() async {
    return trackBox.values.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<TrackRecordEntity>> getTrackRecordsByDate(String date) async {
    return trackBox.values
        .where((m) => m.date == date)
        .map((m) => m.toEntity())
        .toList();
  }

  @override
  Future<List<TrackRecordEntity>> getTrackRecordsInRange(
      String startDate, String endDate) async {
    return trackBox.values
        .where((m) =>
            m.date.compareTo(startDate) >= 0 && m.date.compareTo(endDate) <= 0)
        .map((m) => m.toEntity())
        .toList();
  }

  @override
  Future<void> saveTrackRecord(TrackRecordEntity record) async {
    await trackBox.put(record.id, TrackRecordModel.fromEntity(record));
  }

  @override
  Future<void> deleteTrackRecord(String id) async {
    await trackBox.delete(id);
  }
}
