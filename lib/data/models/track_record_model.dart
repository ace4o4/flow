import 'package:hive/hive.dart';
import 'package:forgeflow/domain/entities/track_record_entity.dart';

part 'track_record_model.g.dart';

@HiveType(typeId: 2)
class TrackRecordModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String blockId;
  @HiveField(2)
  final String routineId;
  @HiveField(3)
  final DateTime scheduledAt;
  @HiveField(4)
  final DateTime? completedAt;
  @HiveField(5)
  final int xpEarned;
  @HiveField(6)
  final String statusString;
  @HiveField(7)
  final String date;

  TrackRecordModel({
    required this.id,
    required this.blockId,
    required this.routineId,
    required this.scheduledAt,
    this.completedAt,
    this.xpEarned = 0,
    required this.statusString,
    required this.date,
  });

  TrackRecordEntity toEntity() {
    return TrackRecordEntity(
      id: id,
      blockId: blockId,
      routineId: routineId,
      scheduledAt: scheduledAt,
      completedAt: completedAt,
      xpEarned: xpEarned,
      status: PunctualityStatus.values.firstWhere(
        (e) => e.toString() == statusString,
        orElse: () => PunctualityStatus.missed,
      ),
      date: date,
    );
  }

  factory TrackRecordModel.fromEntity(TrackRecordEntity entity) {
    return TrackRecordModel(
      id: entity.id,
      blockId: entity.blockId,
      routineId: entity.routineId,
      scheduledAt: entity.scheduledAt,
      completedAt: entity.completedAt,
      xpEarned: entity.xpEarned,
      statusString: entity.status.toString(),
      date: entity.date,
    );
  }
}
