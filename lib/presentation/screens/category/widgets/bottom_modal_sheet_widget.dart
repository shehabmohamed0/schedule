part of '../category_screen.dart';

class BottomModalSheetWidget extends StatefulWidget {
  const BottomModalSheetWidget({Key? key, required this.category})
      : super(key: key);
  final Category category;

  @override
  _BottomModalSheetWidgetState createState() => _BottomModalSheetWidgetState();
}

class _BottomModalSheetWidgetState extends State<BottomModalSheetWidget> {
  TextEditingController inputText = TextEditingController();

  DateTime taskDateTime = DateTime.now();
  bool hasStartTime = false;
  DateTime? reminderDateTime;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                  color: KIconColor.withOpacity(.2),
                  borderRadius: BorderRadius.circular(15)),
              child: TextField(
                controller: inputText,
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(5),
                    hintText: 'Input new task here',
                    hintStyle: TextStyle(
                        fontSize: 20,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold),
                    border: InputBorder.none),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Transform.scale(
                    scale: .87,
                    child: DatePickerButton(
                        onPressed: () {
                          _datePicker(context: context);
                        },
                        dateTimeString: _getDateString(taskDateTime))),
                // PickerOutlinedButton(
                //     shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(100)),
                //     onPressed: () async {
                //       var newTime = await showTimePicker(
                //           context: context, initialTime: time);
                //       if (newTime != null) {
                //         setState(
                //           () {
                //             time = newTime;
                //           },
                //         );
                //       }
                //     },
                //     child: Text(
                //       '${time.format(context)}',
                //       style: TextStyle(
                //           color: KIconColor,
                //           fontSize: 15,
                //           fontWeight: FontWeight.w500),
                //     )),
                const Spacer(),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.grey,
                    shape: const CircleBorder(),
                  ),
                  onPressed: () async {
                    if (inputText.text.isEmpty) {
                      await Fluttertoast.showToast(
                          msg: "Task can't be empty.",
                          gravity: ToastGravity.SNACKBAR,
                          fontSize: 16.0);
                      return;
                    }

                    final newTask =
                        //any Id
                        Task(
                            name: inputText.text,
                            taskDay: this.taskDateTime,
                            hasStartTime: this.hasStartTime,
                            reminderDateTime: this.reminderDateTime);
                    final taskWithID = await context
                        .read<CategoryCubit>()
                        .createTask(task: newTask, category: widget.category);
                    await context
                        .read<TasksCubit>()
                        .addTaskToUIAndSetNotification(
                            task: taskWithID!.task, category: widget.category);
                    inputText.clear();
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: RotatedBox(
                      quarterTurns: 3,
                      child: Icon(
                        Icons.send,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _datePicker({required BuildContext context}) async {
    final tempTask = await showDialog<Task?>(
      context: context,
      builder: (_) => Dialog(
        elevation: 1,
        backgroundColor: Colors.white,
        child: TaskDateTimePicker(
          currentTaskDay: this.taskDateTime,
          hasStartTime: this.hasStartTime,
          reminderDateTime: this.reminderDateTime,
        ),
      ),
    );
    if (tempTask != null) {
      setState(() {
        this.taskDateTime = tempTask.taskDay;
        this.hasStartTime = tempTask.hasStartTime;
        this.reminderDateTime = reminderDateTime;
      });
    }
  }

  String _getDateString(DateTime date) {
    int differenceInDays = date.day - DateTime.now().day;
    int differenceInMonths = date.month - DateTime.now().month;
    int differenceInYears = date.year - DateTime.now().year;
    if (differenceInDays == 0 &&
        differenceInMonths == 0 &&
        differenceInYears == 0) {
      return 'Today';
    } else if (differenceInDays == 1 &&
        differenceInMonths == 0 &&
        differenceInYears == 0) {
      return 'Tomorrow';
    } else if (differenceInDays == -1 &&
        differenceInMonths == 0 &&
        differenceInYears == 0) {
      return 'Yesterday';
    } else {
      return DateFormat.Md().format(date);
    }
  }
}
