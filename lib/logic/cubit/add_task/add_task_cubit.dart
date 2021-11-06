import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:schedule/data/models/add_model.dart';
import 'package:schedule/data/models/category.dart';
import 'package:schedule/data/models/taskWithColor.dart';
import 'package:schedule/logic/cubit/tasks/tasks_cubit.dart';

part 'add_task_state.dart';

class AddTaskCubit extends Cubit<AddTaskState> {
  final TaskWithColor? currentTask;

  AddTaskCubit(this.currentTask)
      : super(currentTask == null
            ? AddTaskState(
                isEdit: false,
                isSubmitting: false,
                task: AddModel.pure(),
                category: null,
                dateTime: DateTime.now(),
              )
            : AddTaskState(
                isEdit: true,
                isSubmitting: false,
                task: AddModel.dirty(currentTask.task.name),
                category: Category(
                    categoryID: currentTask.task.categoryId,
                    categoryName: 'Any Thing',
                    categoryColor: currentTask.color ?? Colors.grey),
                dateTime: currentTask.task.taskDay!));

  void taskInputChanged(String task) {
    emit(state.copyWith(task: AddModel.dirty(task)));
  }

  void taskDateChanged(DateTime dateTime) {
    emit(state.copyWith(dateTime: dateTime));
  }

  void taskCategoryChanged(Category? category) {
    emit(state.copyWith(category: category));
  }

  void submit() {
    if (state.task.valid) {
      emit(state.copyWith(isSubmitting: true));
    } else if (state.task.pure) {
      emit(state.copyWith(task: AddModel.dirty('')));
    }
  }
}
