import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:forgeflow/domain/entities/block_entity.dart';

part 'block_model.g.dart';

@HiveType(typeId: 0)
class BlockModel extends BlockEntity {
  @override
  @HiveField(0)
  final String id;
  @override
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String typeString;
  @HiveField(3)
  final int durationInMinutes;
  @HiveField(4)
  final String? startTimeString;
  @override
  @HiveField(5)
  final String category;
  @override
  @HiveField(6)
  final int colorValue;
  @override
  @HiveField(7)
  final bool isCompleted;
  @override
  @HiveField(8)
  final int? iconCodePoint;
  @override
  @HiveField(9)
  final List<int> recurringDays;

  BlockModel({
    required this.id,
    required this.title,
    required this.typeString,
    required this.durationInMinutes,
    this.startTimeString,
    required this.category,
    required this.colorValue,
    required this.isCompleted,
    this.iconCodePoint,
    this.recurringDays = const [1, 2, 3, 4, 5, 6, 7],
  }) : super(
          id: id,
          title: title,
          type: BlockType.values.firstWhere(
            (e) => e.toString() == typeString,
            orElse: () => BlockType.timed,
          ),
          duration: Duration(minutes: durationInMinutes),
          startTime: startTimeString != null
              ? TimeOfDay(
                  hour: int.parse(startTimeString.split(":")[0]),
                  minute: int.parse(startTimeString.split(":")[1]))
              : null,
          category: category,
          colorValue: colorValue,
          iconCodePoint: iconCodePoint,
          recurringDays: recurringDays,
          isCompleted: isCompleted,
        );

  factory BlockModel.fromEntity(BlockEntity entity) {
    return BlockModel(
      id: entity.id,
      title: entity.title,
      typeString: entity.type.toString(),
      durationInMinutes: entity.duration.inMinutes,
      startTimeString: entity.startTime != null
          ? "${entity.startTime!.hour}:${entity.startTime!.minute}"
          : null,
      category: entity.category,
      colorValue: entity.colorValue,
      isCompleted: entity.isCompleted,
      iconCodePoint: entity.iconCodePoint,
      recurringDays: entity.recurringDays,
    );
  }
}
