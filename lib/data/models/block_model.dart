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
  final String typeString; // Store enum as string
  @HiveField(3)
  final int durationInMinutes;
  @HiveField(4)
  final String? startTimeString; // Store TimeOfDay as "HH:mm"
  @override
  @HiveField(5)
  final String category;
  @override
  @HiveField(6)
  final int colorValue;
  @override
  @HiveField(7)
  final bool isCompleted;

  BlockModel({
    required this.id,
    required this.title,
    required this.typeString,
    required this.durationInMinutes,
    this.startTimeString,
    required this.category,
    required this.colorValue,
    required this.isCompleted,
  }) : super(
          id: id,
          title: title,
          type: BlockType.values.firstWhere((e) => e.toString() == typeString),
          duration: Duration(minutes: durationInMinutes),
          startTime: startTimeString != null
              ? TimeOfDay(
                  hour: int.parse(startTimeString.split(":")[0]),
                  minute: int.parse(startTimeString.split(":")[1]))
              : null,
          category: category,
          colorValue: colorValue,
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
    );
  }
}
