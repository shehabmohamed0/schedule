import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:schedule/data/models/category.dart';
import 'package:schedule/data/models/category_num_tasks.dart';
import 'package:schedule/data/models/task.dart';
import 'package:schedule/data/models/taskWithColor.dart';
import 'package:schedule/data/repositories/tasks_repository.dart';

part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  CategoryNumTasks categoryNumTasks;
  TasksRepository _tasksRepository = TasksRepository();

  CategoryCubit({required this.categoryNumTasks})
      : super(CategoryTasksLoadingState());

  Future<void> loadCategoryTasks() async {
    final tasks = await _tasksRepository
        .readCategoryTasksWithColor(categoryNumTasks.category);
    emit(CategoryTasksLoadedState(
        categoryNumTasks: categoryNumTasks, tasks: tasks));
  }

  Future<void> updateCategory(Category category) async {
    if (state is CategoryTasksLoadedState) {
      final tasks = await _tasksRepository
          .readCategoryTasksWithColor(categoryNumTasks.category);

      emit(CategoryTasksLoadedState(
          categoryNumTasks: (state as CategoryTasksLoadedState)
              .categoryNumTasks
              .copyWith(category: category),
          tasks: tasks));
    }
  }

  Future<TaskWithColor?> createTask(
      {required Task task, Category? category}) async {
    //add task to data base and return the task with taskId added
    final createdTask = await _tasksRepository
        .create(task.copyWith(categoryId: category?.categoryID));
    //this is the new task to be added
    final newTaskToAdd =
        TaskWithColor(task: createdTask, color: category?.categoryColor);

    if (state is CategoryTasksLoadedState) {
      final currentState = state as CategoryTasksLoadedState;
      final updatedTasks = List<TaskWithColor>.from(currentState.tasks)
        ..add(newTaskToAdd);

      emit(CategoryTasksLoadedState(
          categoryNumTasks: currentState.categoryNumTasks.copyWith(
              numAllTasks: currentState.categoryNumTasks.numAllTasks + 1),
          tasks: updatedTasks));
      return newTaskToAdd;
    }
  }

  Future<TaskWithColor> updateTask(
      {required TaskWithColor taskWithColor}) async {
    final newTaskWithColor = TaskWithColor(
        task: taskWithColor.task
            .copyWith(isCompleted: !taskWithColor.task.isCompleted),
        color: taskWithColor.color);

    _tasksRepository.update(newTaskWithColor.task);
    if (state is CategoryTasksLoadedState) {
      final currentState = (state as CategoryTasksLoadedState);

      final updatedTasks =
          List<TaskWithColor>.from(currentState.tasks).map((TaskWithColor e) {
        if (e.task.taskId == newTaskWithColor.task.taskId) {
          return newTaskWithColor;
        }
        return e;
      }).toList();

      final numAllTasks = currentState.categoryNumTasks.numAllTasks;
      final numCompletedTasks = currentState.categoryNumTasks.numCompletedTasks;

      final newNumCompletedTasks = newTaskWithColor.task.isCompleted
          ? numCompletedTasks + 1
          : numCompletedTasks - 1;

      emit(CategoryTasksLoadedState(
          categoryNumTasks: categoryNumTasks.copyWith(
              numAllTasks: numAllTasks,
              numCompletedTasks: newNumCompletedTasks),
          tasks: updatedTasks));
    }
    return newTaskWithColor;
  }

  Future<void> deleteTask({required TaskWithColor task}) async {
    await _tasksRepository.delete(task.task.taskId!);
    if (state is CategoryTasksLoadedState) {
      final currentState = (state as CategoryTasksLoadedState);
      final updatedTasks = List<TaskWithColor>.from(currentState.tasks
          .where((element) => element.task.taskId != task.task.taskId!)
          .toList());

      final numAllTasks = currentState.categoryNumTasks.numAllTasks;
      final numCompletedTasks = currentState.categoryNumTasks.numCompletedTasks;

      final newNumCompletedTasks =
          task.task.isCompleted ? numCompletedTasks - 1 : numCompletedTasks;

      emit(CategoryTasksLoadedState(
          categoryNumTasks: currentState.categoryNumTasks.copyWith(
              numAllTasks: numAllTasks - 1,
              numCompletedTasks: newNumCompletedTasks),
          tasks: updatedTasks));
    }
  }

  Future<void> deleteCategoryTasks({required Category category}) async {
    await _tasksRepository.deleteCategoryTasks(category.categoryID!);
    if (state is CategoryTasksLoadedState) {
      final currentState = (state as CategoryTasksLoadedState);
      final updatedTasks = List<TaskWithColor>.from(currentState.tasks
          .where((element) => element.task.categoryId != category.categoryID!)
          .toList());

      int numCompletedTasks = 0;

      updatedTasks.forEach((element) {
        if (element.task.isCompleted) numCompletedTasks++;
      });
      emit(CategoryTasksLoadedState(
          categoryNumTasks: currentState.categoryNumTasks.copyWith(
              numAllTasks: updatedTasks.length,
              numCompletedTasks: numCompletedTasks),
          tasks: updatedTasks));
    }
  }
}
