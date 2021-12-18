part of'task_date_time_picker.dart';

class TaskDialogActionsWidget extends StatelessWidget {
  const TaskDialogActionsWidget(
      {Key? key,
        required this.cancelButtonAction,
        required this.doneButtonAction})
      : super(key: key);
  final VoidCallback cancelButtonAction;
  final VoidCallback doneButtonAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: cancelButtonAction,
          child: Text(
            'CANCEL',
            style: TextStyle(
                fontSize: 16,
                color: Colors.blueAccent.shade100,
                fontWeight: FontWeight.w400),
          ),
        ),
        TextButton(
          onPressed: doneButtonAction,
          child: const Text(
            'DONE',
            style: TextStyle(fontSize: 16, color: Colors.blue),
          ),
        ),
        const SizedBox(
          width: 15,
        ),
      ],
    );
  }
}
