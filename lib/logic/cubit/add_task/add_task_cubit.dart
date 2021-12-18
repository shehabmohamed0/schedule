import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:schedule/data/models/add_model.dart';
import 'package:schedule/data/models/category.dart';
import 'package:schedule/data/models/taskWithColor.dart';

part 'add_task_state.dart';

class AddTaskCubit extends Cubit<AddTaskState> {
  final ColoredTask? currentTask;

  AddTaskCubit(this.currentTask)
      : super(
          currentTask == null
              ? AddTaskState(
                  isEdit: false,
                  isSubmitting: false,
                  task: const FormzNameModel.pure(),
                  taskDateTime: DateTime.now(),
                  hasStartTime: false,
                  category: null,
                )
              : AddTaskState(
                  isEdit: true,
                  isSubmitting: false,
                  task: FormzNameModel.dirty(currentTask.task.name),
                  taskDateTime: currentTask.task.taskDay,
                  hasStartTime: currentTask.task.hasStartTime,
                  reminderDateTime: currentTask.task.reminderDateTime,
                  category: Category(
                    categoryID: currentTask.task.categoryId,
                    categoryName: 'Any Thing',
                    categoryColor: currentTask.color ?? Colors.grey,
                  ),
                ),
        );

  void taskInputChanged(String task) {
    emit(state.copyWith(task: FormzNameModel.dirty(task)));
  }

  void setTaskDateTo(DateTime dateTime) {
    emit(state.copyWith(taskDateTime: dateTime));
  }

  void setTaskTimeInfo({
    required DateTime taskDateTime,
    required bool hasStartTime,
    DateTime? reminderTime,
  }) {
    emit(state.copyWith(
        taskDateTime: taskDateTime,
        hasStartTime: hasStartTime,
        reminderDateTime: reminderTime));
  }

  void taskCategoryChanged(Category? category) {
    emit(state.copyWith(category: category));
  }

  void submit() {
    if (state.task.valid) {
      emit(state.copyWith(isSubmitting: true));
    } else if (state.task.pure) {
      emit(state.copyWith(task: const FormzNameModel.dirty('')));
    }
  }
}
