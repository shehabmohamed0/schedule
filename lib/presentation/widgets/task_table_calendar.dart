import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:schedule/core/utils/utils.dart';
import 'package:schedule/data/models/taskWithColor.dart';
import 'package:table_calendar/table_calendar.dart';

class TaskTableCalendar extends StatelessWidget {
  const TaskTableCalendar({
    Key? key,
    required this.focusedDay,
    required this.selectedDay,
    this.getEventsForDay,
    required this.onDaySelected,
  }) : super(key: key);
  final DateTime focusedDay;
  final DateTime selectedDay;
  final List<ColoredTask> Function(DateTime)? getEventsForDay;
  final void Function(DateTime selectedDay, DateTime focusedDay) onDaySelected;

  @override
  Widget build(BuildContext context) {
    return TableCalendar<ColoredTask>(
      firstDay: kFirstDay,
      lastDay: kLastDay,
      focusedDay: focusedDay,
      selectedDayPredicate: (day) => isSameDay(selectedDay, day),

      calendarFormat: CalendarFormat.month,

      eventLoader: getEventsForDay,
      startingDayOfWeek: StartingDayOfWeek.monday,
      headerStyle: HeaderStyle(
        titleCentered: true,
        formatButtonVisible: false,
        titleTextFormatter: (date, locale) {
          return DateFormat.yMMMM(locale).format(date).toUpperCase();
        },
        titleTextStyle: TextStyle(
            fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: TextStyle(fontWeight: FontWeight.bold),
        weekendStyle: TextStyle(fontWeight: FontWeight.bold),
      ),
      calendarStyle: CalendarStyle(
        // Use `CalendarStyle` to customize the UI
        defaultTextStyle: TextStyle(fontWeight: FontWeight.w400),
        selectedDecoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.blueAccent.shade100,
        ),
        todayTextStyle: TextStyle(color: Colors.blue),
        todayDecoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.transparent,
        ),
      ),
      daysOfWeekHeight: 20,

      onDaySelected: onDaySelected,
      // onPageChanged: (focusedDay) {
      //   _focusedDay = focusedDay;
      // },
    );
  }
}
