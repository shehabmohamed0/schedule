import 'dart:collection';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:schedule/core/utils/utils.dart';
import 'package:schedule/data/models/taskWithColor.dart';
import 'package:schedule/data/repositories/tasks_repository.dart';
import 'package:schedule/logic/rebuild_bloc.dart';
import 'package:table_calendar/table_calendar.dart';

part 'calendar_state.dart';

class CalendarCubit extends Cubit<CalendarState> {
  TasksRepository _tasksRepository = TasksRepository();

  CalendarCubit()
      : super(
          CalendarState(
            focusedDay: DateTime.now(),
            selectedDay: DateTime.now(),
            selectedEvents: [],
            tasksEvents: LinkedHashMap(),
          ),
        );

  Future<void> initialize() async {
    final allTasks = await _tasksRepository.readAllWithColor();
    final LinkedHashMap<DateTime, List<ColoredTask>> tasksEvents =
        LinkedHashMap(equals: isSameDay, hashCode: getHashCode);

    allTasks.forEach((element) {
      tasksEvents.containsKey(element.task.taskDay)
          ? tasksEvents[element.task.taskDay]!.add(element)
          : tasksEvents.putIfAbsent(
              element.task.taskDay, () => []..add(element));
    });

    emit(state.copyWith(
        selectedEvents: tasksEvents[state.selectedDay],
        tasksEvents: tasksEvents));
  }

  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(state.selectedDay, selectedDay)) {
      emit(state.copyWith(
          selectedDay: selectedDay,
          selectedEvents: state.getEventsForDay(selectedDay)));
    }
  }

  void addTaskTask(ColoredTask taskWithColor) {}

//a actual update on database will be done by tasks cubit
  Future<void> updateTask(ColoredTask taskWithColor) async {
    final tasksEvents = state.tasksEvents;
    final currentTask = taskWithColor.task;

    final newTaskWithColor = ColoredTask(
        task: currentTask.copyWith(isCompleted: !currentTask.isCompleted),
        color: taskWithColor.color);
    final newSelectedEvents = List<ColoredTask>.from(
      state.selectedEvents.map(
        (element) => element.task.taskId != taskWithColor.task.taskId
            ? element
            : newTaskWithColor,
      ),
    );

    tasksEvents[taskWithColor.task.taskDay] = newSelectedEvents;
    emit(state.copyWith(
        tasksEvents: tasksEvents, selectedEvents: newSelectedEvents));
  }

  Future<void> deleteTask(ColoredTask taskWithColor) async {
    final tasksEvents = state.tasksEvents;
    final newSelectedEvents = List<ColoredTask>.from(state.selectedEvents
        .where((element) => element.task.taskId != taskWithColor.task.taskId));

    tasksEvents[taskWithColor.task.taskDay] = newSelectedEvents;
    emit(state.copyWith(
        tasksEvents: tasksEvents, selectedEvents: newSelectedEvents));
  }
}
