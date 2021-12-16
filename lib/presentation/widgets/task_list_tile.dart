import 'package:flutter/material.dart';
import 'package:schedule/core/constants/constants.dart';
import 'package:schedule/data/models/taskWithColor.dart';

import 'list_tile_check_box.dart';

class TaskListTile extends StatelessWidget {
  final ColoredTask taskWithColor;
  final Function() onTap;
  final Function() onCheckBoxTab;

  TaskListTile(
      {Key? key,
      required this.taskWithColor,
      required this.onTap,
      required this.onCheckBoxTab})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: KIconColor.withOpacity(0.05),
              blurRadius: 10,
            ),
          ]),
      child: ListTile(
        onTap: onTap,
        leading: ListTileCheckBox(
            value: taskWithColor.task.isCompleted,
            color: taskWithColor.color ?? Colors.grey,
            onChanged: onCheckBoxTab),
        title: Text(
          taskWithColor.task.name,
          style: TextStyle(
            decoration: taskWithColor.task.isCompleted
                ? TextDecoration.lineThrough
                : null,
          ),
        ),
      ),
    );
  }
}
