enum PunctualityStatus { early, onTime, late, missed }

class TrackRecordEntity {
  final String id;
  final String blockId;
  final String routineId;
  final DateTime scheduledAt;
  final DateTime? completedAt;
  final int xpEarned;
  final PunctualityStatus status;
  final String date; // YYYY-MM-DD format for easy querying

  TrackRecordEntity({
    required this.id,
    required this.blockId,
    required this.routineId,
    required this.scheduledAt,
    this.completedAt,
    this.xpEarned = 0,
    this.status = PunctualityStatus.missed,
    required this.date,
  });

  TrackRecordEntity copyWith({
    String? id,
    String? blockId,
    String? routineId,
    DateTime? scheduledAt,
    DateTime? completedAt,
    int? xpEarned,
    PunctualityStatus? status,
    String? date,
  }) {
    return TrackRecordEntity(
      id: id ?? this.id,
      blockId: blockId ?? this.blockId,
      routineId: routineId ?? this.routineId,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      completedAt: completedAt ?? this.completedAt,
      xpEarned: xpEarned ?? this.xpEarned,
      status: status ?? this.status,
      date: date ?? this.date,
    );
  }
}
