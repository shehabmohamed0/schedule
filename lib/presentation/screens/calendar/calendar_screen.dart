// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:schedule/core/constants/constants.dart';
import 'package:schedule/core/utils.dart';
import 'package:schedule/data/models/taskWithColor.dart';
import 'package:schedule/data/repositories/tasks_repository.dart';
import 'package:schedule/presentation/widgets/task_list_tile.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  TasksRepository _tasksRepository = TasksRepository();
  late final ValueNotifier<List<TaskWithColor>> _selectedEvents;


  DateTime _focusedDay = DateTime.now();
  late DateTime _selectedDay;

  late LinkedHashMap<DateTime, List<TaskWithColor>> tasksEvents;

  @override
  void initState() {
    super.initState();
    tasksEvents = LinkedHashMap<DateTime, List<TaskWithColor>>(
      equals: isSameDay,
      hashCode: getHashCode,
    );
    initCalendarData();
    print(tasksEvents);
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay));
  }

  void initCalendarData() async {
    final allTasks = await _tasksRepository.readAllWithColor();
    allTasks.forEach((element) {
      if (tasksEvents.containsKey(element.task.createTime)) {
        tasksEvents[element.task.createTime]!.add(element);
      } else {
        tasksEvents.putIfAbsent(
            element.task.createTime, () => []..add(element));
      }
    });
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<TaskWithColor> _getEventsForDay(DateTime day) {
    // Implementation example
    return tasksEvents[day] ?? [];
  }

  List<TaskWithColor> _getEventsForRange(DateTime start, DateTime end) {
    // Implementation example
    final days = daysInRange(start, end);

    return [
      for (final d in days) ..._getEventsForDay(d),
    ];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;

      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KScaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: KIconColor,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: KIconColor.withOpacity(0.2),
                    offset: Offset(0, 3),
                    blurRadius: 20,
                  ),
                ],
              ),
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TableCalendar<TaskWithColor>(
                firstDay: kFirstDay,
                lastDay: kLastDay,
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),

                calendarFormat: CalendarFormat.month,

                eventLoader: _getEventsForDay,
                startingDayOfWeek: StartingDayOfWeek.monday,
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleTextStyle:
                      TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                calendarStyle: CalendarStyle(
                  // Use `CalendarStyle` to customize the UI
                  outsideDaysVisible: false,
                  defaultTextStyle: TextStyle(fontWeight: FontWeight.w600),
                ),
                daysOfWeekHeight: 24,
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black45),
                  weekendStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black45),
                ),
                onDaySelected: _onDaySelected,
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                },
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ValueListenableBuilder<List<TaskWithColor>>(
                valueListenable: _selectedEvents,
                builder: (context, value, _) {
                  return ListView.builder(
                    itemCount: value.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: TaskListTile(
                            taskWithColor: value[index],
                            onTap: () {},
                            onCheckBoxTab: () {}),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
