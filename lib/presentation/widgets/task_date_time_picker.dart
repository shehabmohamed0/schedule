import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:schedule/data/models/task.dart';
import 'package:schedule/presentation/widgets/task_table_calendar.dart';
import 'package:table_calendar/table_calendar.dart';

import 'custom_time_picker_dialog.dart';

part 'task_dialog_list_tile.dart';

part 'reminder_time_widget.dart';

part 'task_dialog_actions_widget.dart';

class TaskDateTimePicker extends StatefulWidget {
  const TaskDateTimePicker({
    Key? key,
    required this.currentTaskDay,
    required this.hasStartTime,
    this.reminderDateTime,
  }) : super(key: key);

  final DateTime currentTaskDay;
  final bool hasStartTime;
  final DateTime? reminderDateTime;

  @override
  State<TaskDateTimePicker> createState() => _TaskDateTimePickerState();
}

class _TaskDateTimePickerState extends State<TaskDateTimePicker> {
  late DateTime selectedDay;

  TimeOfDay? timeOfDay;
  DateTime? reminderDateTime;

  String _getTimeText(TimeOfDay? timeOfDay) {
    return timeOfDay == null ? 'No' : timeOfDay.format(context);
  }

  @override
  void initState() {
    super.initState();
    selectedDay = widget.currentTaskDay;
    widget.hasStartTime
        ? timeOfDay = TimeOfDay.fromDateTime(selectedDay)
        : timeOfDay = null;
    reminderDateTime = widget.reminderDateTime;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: TaskTableCalendar(
            focusedDay: DateTime.now(),
            selectedDay: selectedDay,
            onDaySelected: (selectedDay, focusedDay) {
              if (!isSameDay(this.selectedDay, selectedDay)) {
                setState(
                  () {
                    this.selectedDay = DateTime(
                        selectedDay.year,
                        selectedDay.month,
                        selectedDay.day,
                        this.selectedDay.hour,
                        this.selectedDay.minute);
                  },
                );
              }
            },
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        TaskDialogListTile(
          leadingIcon: FontAwesomeIcons.solidClock,
          title: 'Time',
          trailingText: _getTimeText(timeOfDay),
          onTap: () async {
            final mapState = await showCustomTimePicker(
              context: context,
              initialTime: TimeOfDay.fromDateTime(selectedDay),
            );

            if (mapState == null) {
              return;
            } else if (mapState['state'] == TimePickerCallbackState.Cancel) {
              return;
            } else if (mapState['state'] == TimePickerCallbackState.No_TIME) {
              setState(() {
                timeOfDay = null;
                reminderDateTime = null;
              });
            } else if (mapState['state'] == TimePickerCallbackState.Ok) {
              final TimeOfDay timeOfDay = mapState['value'] as TimeOfDay;
              setState(
                () {
                  this.timeOfDay = timeOfDay;
                  selectedDay = DateTime(selectedDay.year, selectedDay.month,
                      selectedDay.day, timeOfDay.hour, timeOfDay.minute);
                  reminderDateTime = DateTime(
                          selectedDay.year,
                          selectedDay.month,
                          selectedDay.day,
                          timeOfDay.hour,
                          timeOfDay.minute)
                      .subtract(const Duration(minutes: 5));
                },
              );
            }
          },
        ),
        Opacity(
          opacity: reminderDateTime == null ? 0.5 : 1,
          child: AbsorbPointer(
            absorbing:
                (reminderDateTime == null && timeOfDay == null) ? true : false,
            child: TaskDialogListTile(
              leadingIcon: FontAwesomeIcons.solidBell,
              title: 'Reminder',
              trailingText: reminderDateTime == null
                  ? 'No'
                  : _getTimeText(TimeOfDay.fromDateTime(reminderDateTime!)),
              onTap: () async {
                final returnedMap = await showDialog<Map<String, dynamic>>(
                  context: context,
                  builder: (context) => Dialog(
                    child: ReminderTimeWidget(
                      taskDateTime: selectedDay,
                      hasTime: timeOfDay == null ? false : true,
                      reminderTime: reminderDateTime,
                    ),
                  ),
                );

                if (returnedMap == null) return;

                final hasReminder = returnedMap['hasReminder'] as bool;
                if (hasReminder) {
                  final minutes = returnedMap['minutes'] as int;
                  setState(
                    () {
                      reminderDateTime =
                          selectedDay.subtract(Duration(minutes: minutes));
                      if (minutes == 0) {
                        reminderDateTime =
                            reminderDateTime!.add(const Duration(seconds: 5));
                      }
                    },
                  );
                } else {
                  setState(
                    () {
                      reminderDateTime = null;
                    },
                  );
                }
              },
            ),
          ),
        ),
        TaskDialogActionsWidget(
          cancelButtonAction: () {
            Navigator.of(context).pop();
          },
          doneButtonAction: () {
            Navigator.pop(
              context,
              Task(
                name: 'Random',
                taskDay: selectedDay,
                hasStartTime: timeOfDay == null ? false : true,
                reminderDateTime: reminderDateTime,
              ),
            );
          },
        ),
      ],
    );
  }
}
