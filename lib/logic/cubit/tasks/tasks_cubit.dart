import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:schedule/data/models/category.dart';
import 'package:schedule/data/models/task.dart';
import 'package:schedule/data/models/taskWithColor.dart';
import 'package:schedule/data/repositories/tasks_repository.dart';

part 'tasks_state.dart';

class TasksCubit extends Cubit<TasksState> {
  final _tasksRepository = TasksRepository();

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

  Future<void> createTask({required Task task, Category? category}) async {
    //add task to data base and return the task with taskId added
    final createdTask = await _tasksRepository
        .create(task.copyWith(categoryId: category?.categoryID));
    //this is the new task to be added
    final newTaskToAdd =
        TaskWithColor(task: createdTask, color: category?.categoryColor);

    if (state is TasksLoadedState) {
      final updatedTasks =
          List<TaskWithColor>.from((state as TasksLoadedState).tasks)
            ..add(newTaskToAdd);

      emit(TasksLoadedState(tasks: updatedTasks));
    } else if (state is TasksEmptyState) {
      emit(TasksLoadedState(tasks: [newTaskToAdd]));
    }
  }

  Future<void> addTask({required Task task, Category? category}) async {
    final newTaskToAdd =
        TaskWithColor(task: task, color: category?.categoryColor);
    if (state is TasksLoadedState) {
      final updatedTasks =
          List<TaskWithColor>.from((state as TasksLoadedState).tasks)
            ..add(newTaskToAdd);
      emit(TasksLoadedState(tasks: updatedTasks));
    } else if (state is TasksEmptyState) {
      emit(TasksLoadedState(tasks: [newTaskToAdd]));
    }
  }

  Future<void> updateTask({required Task task, required Color color}) async {
    if (state is TasksLoadedState) {
      _tasksRepository.update(task);
      final updatedTodos =
          List<TaskWithColor>.from((state as TasksLoadedState).tasks)
              .map((TaskWithColor e) {
        if (e.task.taskId == task.taskId) {
          return TaskWithColor(task: task, color: color);
        }
        return e;
      }).toList();

      emit(TasksLoadedState(tasks: updatedTodos));
    }
  }

  Future<void> refreshUiOnUpdate({
    required TaskWithColor taskWithColor,
  }) async {
    if (state is TasksLoadedState) {
      final updatedTodos =
          List<TaskWithColor>.from((state as TasksLoadedState).tasks)
              .map((TaskWithColor e) {
        if (e.task.taskId == taskWithColor.task.taskId) {
          return TaskWithColor(
              task: taskWithColor.task, color: taskWithColor.color);
        }
        return e;
      }).toList();

      emit(TasksLoadedState(tasks: updatedTodos));
    }
  }

  Future<void> deleteTask({required TaskWithColor task}) async {
    await _tasksRepository.delete(task.task.taskId!);
    if (state is TasksLoadedState) {
      final updatedTasks = List<TaskWithColor>.from((state as TasksLoadedState)
          .tasks
          .where((element) => element.task.taskId != task.task.taskId!)
          .toList());

      if (updatedTasks.isEmpty) {
        emit(TasksEmptyState());
      } else {
        emit(TasksLoadedState(tasks: updatedTasks));
      }
    }
  }

  Future<void> deleteCategoryTasks({required Category category}) async {
    if (state is TasksLoadedState) {
      final updatedTasks = List<TaskWithColor>.from((state as TasksLoadedState)
          .tasks
          .where((element) => element.task.categoryId != category.categoryID!)
          .toList());

      if (updatedTasks.isEmpty) {
        emit(TasksEmptyState());
      } else {
        emit(TasksLoadedState(tasks: updatedTasks));
      }
    }
  }
}
