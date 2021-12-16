import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

final String tasksTable = 'tasks';

class TaskFields {
  static final List<String> values = [
    /// Add all fields
    id, name, isCompleted, taskDate, hasStartTime, reminderDateTime, categoryId
  ];
  static final String id = '_taskId';
  static final String name = 'taskName';
  static final String isCompleted = 'isCompleted';
  static final String taskDate = 'taskDay';
  static final String hasStartTime = 'hasStartTime';
  static final String reminderDateTime = 'reminderDateTime';
  static final String categoryId = '_categoryId';
}

class Task extends Equatable {
  final int? taskId;
  final String name;
  final bool isCompleted;
  final DateTime taskDay;
  final bool hasStartTime;
  final DateTime? reminderDateTime;
  final int? categoryId;

  const Task(
      {this.taskId,
      required this.name,
      this.isCompleted: false,
      required this.taskDay,
      required this.hasStartTime,
      this.reminderDateTime,
      this.categoryId});

  Task copyWith({
    int? taskId,
    String? name,
    bool? isCompleted,
    DateTime? taskDay,
    bool? hasStartTime,
    DateTime? reminderDateTime,
    int? categoryId,
  }) =>
      Task(
        taskId: taskId ?? this.taskId,
        name: name ?? this.name,
        isCompleted: isCompleted ?? this.isCompleted,
        taskDay: taskDay ?? this.taskDay,
        hasStartTime: hasStartTime ?? this.hasStartTime,
        reminderDateTime: reminderDateTime ?? this.reminderDateTime,
        categoryId: categoryId ?? this.categoryId,
      );

  Map<String, dynamic> toJson() => {
        TaskFields.id: taskId,
        TaskFields.name: name,
        TaskFields.isCompleted: isCompleted ? 1 : 0,
        TaskFields.taskDate: taskDay.toIso8601String(),
        TaskFields.hasStartTime: hasStartTime ? 1 : 0,
        TaskFields.reminderDateTime: reminderDateTime?.toIso8601String(),
        TaskFields.categoryId: categoryId,
      };

  static Task fromJson(Map<String, Object?> json) {
    DateTime? _getDateTime(String? dateTime) =>
        dateTime == null ? null : DateTime.parse(dateTime);

    return Task(
      taskId: json[TaskFields.id] as int?,
      name: json[TaskFields.name] as String,
      isCompleted: json[TaskFields.isCompleted] == 1,
      taskDay: DateTime.parse(json[TaskFields.taskDate] as String),
      hasStartTime: json[TaskFields.hasStartTime] == 1,
      reminderDateTime:
          _getDateTime(json[TaskFields.reminderDateTime] as String?),
      categoryId: json[TaskFields.categoryId] as int?,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
        taskId,
        name,
        isCompleted,
        taskDay,
        hasStartTime,
        reminderDateTime,
        categoryId,
      ];
}
