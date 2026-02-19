import 'package:flutter/material.dart';

enum BlockType { timed, scheduled, durationWithStart }

class BlockEntity {
  final String id;
  final String title;
  final BlockType type;
  final Duration duration;
  final TimeOfDay? startTime;
  final String category;
  final int colorValue;
  final bool isCompleted;

  BlockEntity({
    required this.id,
    required this.title,
    required this.type,
    required this.duration,
    this.startTime,
    required this.category,
    required this.colorValue,
    this.isCompleted = false,
  });
}
