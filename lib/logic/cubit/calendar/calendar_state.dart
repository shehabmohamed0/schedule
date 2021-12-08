part of 'calendar_cubit.dart';

class CalendarState extends Equatable {
  CalendarState({
    required this.focusedDay,
    required this.selectedDay,
    required this.tasksEvents,
    required this.selectedEvents,
  });

  final DateTime focusedDay;
  final DateTime selectedDay;
  final LinkedHashMap<DateTime, List<TaskWithColor>> tasksEvents;
  final List<TaskWithColor> selectedEvents;

  List<TaskWithColor> getEventsForDay(DateTime day) {
    return tasksEvents[day] ?? [];
  }

  CalendarState copyWith({
    DateTime? focusedDay,
    DateTime? selectedDay,
    LinkedHashMap<DateTime, List<TaskWithColor>>? tasksEvents,
    List<TaskWithColor>? selectedEvents,
  }) =>
      CalendarState(
          focusedDay: focusedDay ?? this.focusedDay,
          selectedDay: selectedDay ?? this.selectedDay,
          tasksEvents: tasksEvents ?? this.tasksEvents,
          selectedEvents: selectedEvents ?? this.selectedEvents,
          );

  @override
  List<Object> get props =>
      [focusedDay, selectedDay, tasksEvents, selectedEvents];
}
