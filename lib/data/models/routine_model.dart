import 'package:hive/hive.dart';
import 'package:forgeflow/domain/entities/routine_entity.dart';
import 'package:forgeflow/data/models/block_model.dart';

part 'routine_model.g.dart';

@HiveType(typeId: 1)
class RoutineModel extends RoutineEntity {
  @override
  @HiveField(0)
  final String id;
  @override
  @HiveField(1)
  final String name;
  @override
  @HiveField(2)
  final List<BlockModel> blocks;
  @override
  @HiveField(3)
  final bool isActive;

  RoutineModel({
    required this.id,
    required this.name,
    required this.blocks,
    required this.isActive,
  }) : super(
          id: id,
          name: name,
          blocks: blocks,
          isActive: isActive,
        );

  factory RoutineModel.fromEntity(RoutineEntity entity) {
    return RoutineModel(
      id: entity.id,
      name: entity.name,
      blocks: entity.blocks.map((e) => BlockModel.fromEntity(e)).toList(),
      isActive: entity.isActive,
    );
  }
}
