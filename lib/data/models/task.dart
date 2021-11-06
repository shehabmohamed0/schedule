import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

final String tasksTable = 'tasks';

class TaskFields {
  static final List<String> values = [
    /// Add all fields
    id, name, isCompleted, startTime, endTime, taskDay, categoryId
  ];
  static final String id = '_taskId';
  static final String name = 'taskName';
  static final String isCompleted = 'isCompleted';
  static final String startTime = 'startTime';
  static final String endTime = 'endTime';
  static final String taskDay = 'taskDay';
  static final String categoryId = '_categoryId';
}

class Task extends Equatable {
  final int? taskId;
  final String name;
  final bool isCompleted;

  final DateTime? startTime;
  final DateTime? endTime;
  final DateTime? taskDay;
  final int? categoryId;

  const Task(
      {this.taskId,
      required this.name,
      this.isCompleted: false,
      this.startTime,
      this.endTime,
      this.taskDay,
      this.categoryId});

  Task copyWith({
    int? taskId,
    String? name,
    bool? isCompleted,
    DateTime? startTime,
    DateTime? endTime,
    DateTime? taskDay,
    int? categoryId,
  }) =>
      Task(
          taskId: taskId ?? this.taskId,
          name: name ?? this.name,
          isCompleted: isCompleted ?? this.isCompleted,
          startTime: startTime ?? this.startTime,
          endTime: endTime ?? this.endTime,
          taskDay: taskDay ?? this.taskDay,
          categoryId: categoryId ?? this.categoryId);

  Map<String, dynamic> toJson() => {
        TaskFields.id: taskId,
        TaskFields.name: name,
        TaskFields.isCompleted: isCompleted ? 1 : 0,
        TaskFields.startTime:
            startTime != null ? startTime!.toIso8601String() : null,
        TaskFields.endTime: endTime != null ? endTime!.toIso8601String() : null,
        TaskFields.taskDay: taskDay != null ? taskDay!.toIso8601String() : null,
        TaskFields.categoryId: categoryId,
      };

  static Task fromJson(Map<String, Object?> json) {
    DateTime? _getDateTime(String? dateTime) {
      if (dateTime == null) {
        return null;
      }

      return DateTime.parse(dateTime);
    }

    return Task(
      taskId: json[TaskFields.id] as int?,
      name: json[TaskFields.name] as String,
      isCompleted: json[TaskFields.isCompleted] == 1,
      startTime: _getDateTime(json[TaskFields.startTime] as String?),
      endTime: _getDateTime(json[TaskFields.endTime] as String?),
      taskDay: _getDateTime(json[TaskFields.taskDay] as String?),
      categoryId: json[TaskFields.categoryId] as int?,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
        taskId,
        name,
        isCompleted,
        startTime,
        endTime,
        taskDay,
        categoryId,
      ];
}
