import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'category.dart';
import 'task.dart';

class TaskWithColor extends Equatable {
  final Task task;
  final Color? color;

  const TaskWithColor({required this.task, this.color});

  static TaskWithColor fromJson(Map<String, Object?> json) {
    return TaskWithColor(
        task: Task.fromJson(json),
        color: Color(json[CategoryFields.color] as int));
  }

  @override
  List<Object?> get props => [task, color];
}
