import 'package:forgeflow/domain/entities/block_entity.dart';

class RoutineEntity {
  final String id;
  final String name;
  final List<BlockEntity> blocks;
  final bool isActive;

  RoutineEntity({
    required this.id,
    required this.name,
    required this.blocks,
    this.isActive = true,
  });

  RoutineEntity copyWith({
    String? id,
    String? name,
    List<BlockEntity>? blocks,
    bool? isActive,
  }) {
    return RoutineEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      blocks: blocks ?? this.blocks,
      isActive: isActive ?? this.isActive,
    );
  }
}
