import 'package:schedule/data/models/taskWithColor.dart';

class MethodUtils {
  static List<ColoredTask> updateTaskInList(
          {required List<ColoredTask> oldList,
          required ColoredTask newColoredTask}) =>
      List<ColoredTask>.from(oldList)
          .map((ColoredTask currentColoredTask) =>
              newColoredTask.task.taskId == currentColoredTask.task.taskId
                  ? newColoredTask
                  : currentColoredTask)
          .toList();

  static List<ColoredTask> deleteTaskFromList({
    required List<ColoredTask> oldList,
    required ColoredTask task,
  }) =>
      List<ColoredTask>.from(oldList
          .where((element) => element.task.taskId != task.task.taskId!)
          .toList());
}
