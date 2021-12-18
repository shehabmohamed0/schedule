import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:schedule/data/models/category.dart';
import 'package:schedule/data/models/task.dart';
import 'package:schedule/data/models/taskWithColor.dart';
import 'package:schedule/data/repositories/tasks_repository.dart';
import 'package:schedule/data/data_providers/notification_plugin.dart';

part 'tasks_state.dart';

class TasksCubit extends Cubit<TasksState> {
  final _tasksRepository = TasksRepository();
  NotificationPlugin notificationPlugin = NotificationPlugin.instance;

  TasksCubit() : super(TasksInitialState());

  Future<void> loadTasks() async {
    emit(TasksLoadingState());

    final tasks = await _tasksRepository.readAllWithColor();

    if (tasks.isEmpty)
      emit(TasksEmptyState());
    else
      emit(TasksLoadedState(tasks: tasks));
  }

  Future<void> deleteAll() async {
    await _tasksRepository.deleteAll();
    emit(TasksLoadedState(tasks: await _tasksRepository.readAllWithColor()));
  }

  Future<void> createTaskAndAddItToUI(
      {required Task task, Category? category}) async {
    final createdTask = await _tasksRepository
        .create(task.copyWith(categoryId: category?.categoryID));

    await addTaskToUIAndSetNotification(task: createdTask, category: category);
  }

  Future<void> addTaskToUIAndSetNotification({required Task task, Category? category}) async {
    final newTaskToAdd =
        ColoredTask(task: task, color: category?.categoryColor);

    await _addNotification(task: newTaskToAdd.task);

    if (state is TasksLoadedState) {
      final updatedTasks =
          List<ColoredTask>.from((state as TasksLoadedState).tasks)
            ..add(newTaskToAdd);
      emit(TasksLoadedState(tasks: updatedTasks));
    } else if (state is TasksEmptyState) {
      emit(TasksLoadedState(tasks: [newTaskToAdd]));
    }
  }

  Future<void> _addNotification({required Task task}) async {
    if (task.reminderDateTime == null) return;
    await notificationPlugin.zonedScheduleNotification(
        id: task.taskId!, title: task.name, dateTime: task.reminderDateTime!);
  }

  Future<void> updateTask({required Task task, required Color color}) async {
    if (state is TasksLoadedState) {
      _tasksRepository.update(task);
      final updatedTasksList =
          List<ColoredTask>.from((state as TasksLoadedState).tasks)
              .map((ColoredTask e) => (e.task.taskId == task.taskId)
                  ? ColoredTask(task: task, color: color)
                  : e)
              .toList();

      emit(TasksLoadedState(tasks: updatedTasksList));
    }
  }

  Future<void> refreshUiOnUpdate({
    required ColoredTask taskWithColor,
  }) async {
    if (state is TasksLoadedState) {
      final updatedTodos =
          List<ColoredTask>.from((state as TasksLoadedState).tasks)
              .map((task) => task.task.taskId == taskWithColor.task.taskId
                  ? ColoredTask(
                      task: taskWithColor.task, color: taskWithColor.color)
                  : task)
              .toList();

      emit(TasksLoadedState(tasks: updatedTodos));
    }
  }

  Future<void> deleteTask({required ColoredTask task}) async {
    await _tasksRepository.delete(task.task.taskId!);
    if (state is TasksLoadedState) {
      final updatedTasks = List<ColoredTask>.from((state as TasksLoadedState)
          .tasks
          .where((element) => element.task.taskId != task.task.taskId!)
          .toList());

      updatedTasks.isEmpty
          ? emit(TasksEmptyState())
          : emit(TasksLoadedState(tasks: updatedTasks));
    }
  }

  Future<void> deleteCategoryTasks({required Category category}) async {
    if (state is TasksLoadedState) {
      final updatedTasks = List<ColoredTask>.from(
        (state as TasksLoadedState)
            .tasks
            .where((element) => element.task.categoryId != category.categoryID!)
            .toList(),
      );
      updatedTasks.isEmpty
          ? emit(TasksEmptyState())
          : emit(TasksLoadedState(tasks: updatedTasks));
    }
  }

  List<ColoredTask> getNewListAndRemove({
    required List<ColoredTask> oldList,
    required ColoredTask taskToBeRemoved,
  }) =>
      List<ColoredTask>.from(oldList)
          .where((element) =>
              element.task.categoryId != taskToBeRemoved.task.categoryId!)
          .toList();
}
