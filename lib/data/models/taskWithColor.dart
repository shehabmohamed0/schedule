import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'category.dart';
import 'task.dart';

class ColoredTask extends Equatable {
  final Task task;
  final Color? color;

  const ColoredTask({required this.task, this.color});

  static ColoredTask fromJson(Map<String, Object?> json) {
    Color _getColor(int? colorNumber) =>
        colorNumber == null ? Colors.grey : Color(colorNumber);
    return ColoredTask(
        task: Task.fromJson(json),
        color: _getColor(json[CategoryFields.color] as int?));
  }

  ColoredTask copyWith(bool isCompleted) =>
      ColoredTask(task: task.copyWith(isCompleted: isCompleted), color: color);

  @override
  List<Object?> get props => [task, color];
}
