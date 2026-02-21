// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'track_record_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TrackRecordModelAdapter extends TypeAdapter<TrackRecordModel> {
  @override
  final int typeId = 2;

  @override
  TrackRecordModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TrackRecordModel(
      id: fields[0] as String,
      blockId: fields[1] as String,
      routineId: fields[2] as String,
      scheduledAt: fields[3] as DateTime,
      completedAt: fields[4] as DateTime?,
      xpEarned: fields[5] as int,
      statusString: fields[6] as String,
      date: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, TrackRecordModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.blockId)
      ..writeByte(2)
      ..write(obj.routineId)
      ..writeByte(3)
      ..write(obj.scheduledAt)
      ..writeByte(4)
      ..write(obj.completedAt)
      ..writeByte(5)
      ..write(obj.xpEarned)
      ..writeByte(6)
      ..write(obj.statusString)
      ..writeByte(7)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TrackRecordModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
