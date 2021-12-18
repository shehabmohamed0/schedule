part of 'task_date_time_picker.dart';

class ReminderTimeWidget extends StatefulWidget {
  const ReminderTimeWidget({
    Key? key,
    required this.taskDateTime,
    required this.hasTime,
    this.reminderTime,
  }) : super(key: key);

  final DateTime taskDateTime;
  final bool hasTime;
  final DateTime? reminderTime;

  @override
  _ReminderTimeWidgetState createState() => _ReminderTimeWidgetState();
}

class _ReminderTimeWidgetState extends State<ReminderTimeWidget> {
  late bool reminderIsOn;
  late int selectedValue;

  @override
  void initState() {
    super.initState();

    if (!widget.hasTime || widget.reminderTime == null) {
      reminderIsOn = false;
      selectedValue = 5;
    }

    if (widget.reminderTime != null) {
      reminderIsOn = true;
      selectedValue =
          widget.taskDateTime.difference(widget.reminderTime!).inMinutes;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Reminder is on',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Switch(
                  value: reminderIsOn,
                  onChanged: (val) {
                    setState(() {
                      reminderIsOn = val;
                    });
                  })
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Reminder at',
                style: TextStyle(
                    fontSize: 16,
                    color:
                        reminderIsOn ? Colors.black87 : Colors.grey.shade500),
              ),
              IgnorePointer(
                ignoring: !reminderIsOn,
                child: DropdownButton<int>(
                  value: reminderIsOn ? selectedValue : 1000,
                  style: TextStyle(color: Colors.grey.shade500),
                  iconEnabledColor: Colors.grey.shade500,
                  underline: const SizedBox(),
                  onChanged: (value) {
                    setState(
                      () {
                        selectedValue = value!;
                      },
                    );
                  },
                  items: [
                    if (!reminderIsOn)
                      const DropdownMenuItem(
                        child: Text('No'),
                        value: 1000,
                      ),
                    const DropdownMenuItem(
                      child: Text('Same with due Date'),
                      value: 0,
                    ),
                    const DropdownMenuItem(
                      child: Text('5 minute before'),
                      value: 5,
                    ),
                    const DropdownMenuItem(
                      child: Text('10 minute before'),
                      value: 10,
                    ),
                    const DropdownMenuItem(
                      child: Text('15 minute before'),
                      value: 15,
                    ),
                    const DropdownMenuItem(
                      child: Text('20 minute before'),
                      value: 20,
                    ),
                    const DropdownMenuItem(
                      child: Text('30 minute before'),
                      value: 30,
                    ),
                  ],
                ),
              ),
            ],
          ),
          TaskDialogActionsWidget(
            cancelButtonAction: () {
              Navigator.pop(context);
            },
            doneButtonAction: () {
              Navigator.pop(
                context,
                {'hasReminder': reminderIsOn, 'minutes': selectedValue},
              );
            },
          ),
        ],
      ),
    );
  }
}
