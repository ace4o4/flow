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
}
