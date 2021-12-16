part of 'add_task_cubit.dart';

class AddTaskState extends Equatable {
  final FormzNameModel task;
  final DateTime taskDateTime;
  final bool hasStartTime;
  final DateTime? reminderDateTime;
  final Category? category;

  //Identify that are we adding a new task or modifying existing one
  final bool isEdit;
  final bool isSubmitting;

  AddTaskState({
    required this.isEdit,
    required this.isSubmitting,
    required this.task,
    required this.taskDateTime,
    required this.hasStartTime,
    this.reminderDateTime,
    required this.category,
  });

  String? get errorText {
    return ((task.pure) || task.valid) ? null : 'Task can not be empty.';
  }

  Color get categoryColor {
    return category == null ? Colors.grey : category!.categoryColor;
  }

  String get dateTimeString {
    int differenceInDays = taskDateTime.day - DateTime.now().day;
    int differenceInMonths = taskDateTime.month - DateTime.now().month;
    int differenceInYears = taskDateTime.year - DateTime.now().year;
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
      return DateFormat.Md().format(taskDateTime);
    }
  }

  String get submitText => isEdit ? 'Save' : 'New Task';

  AddTaskState copyWith({
    // we don't need to change isEdit
    bool? isSubmitting,
    FormzNameModel? task,
    DateTime? taskDateTime,
    bool? hasStartTime,
    DateTime? reminderDateTime,
    Category? category,
  }) =>
      AddTaskState(
        isEdit: this.isEdit,
        isSubmitting: isSubmitting ?? this.isSubmitting,
        task: task ?? this.task,
        taskDateTime: taskDateTime ?? this.taskDateTime,
        hasStartTime: hasStartTime ?? this.hasStartTime,
        reminderDateTime: reminderDateTime ?? this.reminderDateTime,
        category: category ?? this.category,
      );

  @override
  List<Object?> get props => [
        isEdit,
        isSubmitting,
        task,
        taskDateTime,
        hasStartTime,
        reminderDateTime,
        category
      ];
}
