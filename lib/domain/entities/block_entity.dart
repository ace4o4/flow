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
  final int? iconCodePoint;
  final List<int> recurringDays; // 1=Mon, 7=Sun
  final bool isCompleted;

  BlockEntity({
    required this.id,
    required this.title,
    required this.type,
    required this.duration,
    this.startTime,
    required this.category,
    required this.colorValue,
    this.iconCodePoint,
    this.recurringDays = const [1, 2, 3, 4, 5, 6, 7],
    this.isCompleted = false,
  });

  BlockEntity copyWith({
    String? id,
    String? title,
    BlockType? type,
    Duration? duration,
    TimeOfDay? startTime,
    String? category,
    int? colorValue,
    int? iconCodePoint,
    List<int>? recurringDays,
    bool? isCompleted,
  }) {
    return BlockEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      duration: duration ?? this.duration,
      startTime: startTime ?? this.startTime,
      category: category ?? this.category,
      colorValue: colorValue ?? this.colorValue,
      iconCodePoint: iconCodePoint ?? this.iconCodePoint,
      recurringDays: recurringDays ?? this.recurringDays,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
