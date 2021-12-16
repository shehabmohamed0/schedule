import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:schedule/core/utils/methods.dart';
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
    _emitCategoryTasksLoadedState(
        currentCategoryNumTasks: categoryNumTasks, newTasks: tasks);
  }

  Future<void> updateCategory(Category category) async {
    if (state is CategoryTasksLoadedState) {
      final tasks = await _tasksRepository
          .readCategoryTasksWithColor(categoryNumTasks.category);
      final currentState = state as CategoryTasksLoadedState;
      _emitCategoryTasksLoadedState(
          currentCategoryNumTasks: currentState.categoryNumTasks,
          newTasks: tasks,
          category: category);
    }
  }

  Future<ColoredTask?> createTask(
      {required Task task, Category? category}) async {
    final createdTask = await _tasksRepository
        .create(task.copyWith(categoryId: category?.categoryID));
    final newColoredTask =
        ColoredTask(task: createdTask, color: category?.categoryColor);
    if (state is CategoryTasksLoadedState) {
      final currentState = state as CategoryTasksLoadedState;
      final updatedTasks = List<ColoredTask>.from(currentState.tasks)
        ..add(newColoredTask);

      _emitCategoryTasksLoadedState(
          currentCategoryNumTasks: currentState.categoryNumTasks,
          newTasks: updatedTasks,
          newNumAllTasks: currentState.categoryNumTasks.numAllTasks + 1,);

      return newColoredTask;
    }
  }

  Future<ColoredTask> updateTask({required ColoredTask coloredTask}) async {
    final newColoredTask = coloredTask.copyWith(!coloredTask.task.isCompleted);
    _tasksRepository.update(newColoredTask.task);

    if (state is CategoryTasksLoadedState) {
      final currentState = state as CategoryTasksLoadedState;
      final updatedTasksList = MethodUtils.updateTaskInList(
          oldList: currentState.tasks, newColoredTask: newColoredTask);
      _countNewCategoryInfoAndEmitState(
          currentState: currentState,
          newColoredTask: newColoredTask,
          updatedTasksList: updatedTasksList);
    }
    return newColoredTask;
  }

  Future<void> deleteTask({required ColoredTask task}) async {
    await _tasksRepository.delete(task.task.taskId!);
    if (state is CategoryTasksLoadedState) {
      final currentState = (state as CategoryTasksLoadedState);
      final updatedTasks = MethodUtils.deleteTaskFromList(
          oldList: currentState.tasks, task: task);
      final numAllTasks = currentState.categoryNumTasks.numAllTasks;
      final numCompletedTasks = currentState.categoryNumTasks.numCompletedTasks;

      final newNumCompletedTasks =
          task.task.isCompleted ? numCompletedTasks - 1 : numCompletedTasks;
      _emitCategoryTasksLoadedState(
          currentCategoryNumTasks: currentState.categoryNumTasks,
          newNumAllTasks: numAllTasks - 1,
          newNumCompletedTasks: newNumCompletedTasks,
          newTasks: updatedTasks);
    }
  }

  Future<void> deleteCategoryTasks({required Category category}) async {
    await _tasksRepository.deleteCategoryTasks(category.categoryID!);
    if (state is CategoryTasksLoadedState) {
      final currentState = (state as CategoryTasksLoadedState);
      final updatedTasks = List<ColoredTask>.from(currentState.tasks
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

  void _countNewCategoryInfoAndEmitState(
      {required CategoryTasksLoadedState currentState,
      required ColoredTask newColoredTask,
      required List<ColoredTask> updatedTasksList}) {
    final currentCategoryWithInfo = currentState.categoryNumTasks;
    final numCompletedTasks = currentCategoryWithInfo.numCompletedTasks;
    final newNumCompletedTasks = _getNewCountFromUpdatedTask(
        newColoredTask.task.isCompleted, numCompletedTasks);

    _emitCategoryTasksLoadedState(
      currentCategoryNumTasks: currentState.categoryNumTasks,
      newNumCompletedTasks: newNumCompletedTasks,
      newTasks: updatedTasksList,
    );
  }

  int _getNewCountFromUpdatedTask(
          bool newColoredTaskStatus, oldNumCompletedTasks) =>
      newColoredTaskStatus
          ? oldNumCompletedTasks + 1
          : oldNumCompletedTasks - 1;

  void _emitCategoryTasksLoadedState({
    required CategoryNumTasks currentCategoryNumTasks,
    int? newNumAllTasks,
    int? newNumCompletedTasks,
    required List<ColoredTask> newTasks,
    Category? category,
  }) {
    emit(CategoryTasksLoadedState(
      categoryNumTasks: currentCategoryNumTasks.copyWith(
          numAllTasks: newNumAllTasks,
          numCompletedTasks: newNumCompletedTasks,
          category: category),
      tasks: newTasks,
    ));
  }
}
