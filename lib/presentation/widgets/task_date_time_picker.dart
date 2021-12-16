import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:schedule/presentation/widgets/task_table_calendar.dart';
import 'package:table_calendar/table_calendar.dart';

part 'task_dialog_list_tile.dart';

class TaskDateTimePicker extends StatefulWidget {
  const TaskDateTimePicker({
    Key? key,
  }) : super(key: key);

  @override
  State<TaskDateTimePicker> createState() => _TaskDateTimePickerState();
}

class _TaskDateTimePickerState extends State<TaskDateTimePicker> {
  DateTime selectedDay = DateTime.now();
  TimeOfDay? timeOfDay;
  TimeOfDay? reminderTime;

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
                    this.selectedDay = selectedDay;
                  },
                );
              }
            },
          ),
        ),
        SizedBox(
          height: 20,
        ),
        TaskDialogListTile(
          leadingIcon: FontAwesomeIcons.solidClock,
          title: 'Time',
          trailingText: '19:00',
        ),
        Opacity(
          opacity: 0.5,
          child: AbsorbPointer(
            absorbing: true,
            child: TaskDialogListTile(
              leadingIcon: FontAwesomeIcons.solidBell,
              title: 'Reminder',
              trailingText: 'No',
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'CANCEL',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.blueAccent.shade100,
                    fontWeight: FontWeight.w400),
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                'DONE',
                style: TextStyle(fontSize: 16, color: Colors.blue),
              ),
            ),
            SizedBox(
              width: 15,
            ),
          ],
        )
      ],
    );
  }
}
