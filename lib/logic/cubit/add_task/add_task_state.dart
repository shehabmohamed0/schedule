part of 'add_task_cubit.dart';

class AddTaskState extends Equatable {
  final AddModel task;
  final Category? category;
  final DateTime dateTime;

  //Identify that are we adding a new task or modifying existing one
  final bool isEdit;
  final bool isSubmitting;

  AddTaskState(
      {required this.isEdit,
      required this.isSubmitting,
      required this.task,
      required this.category,
      required this.dateTime});

  String? get errorText {
    return ((task.pure) || task.valid) ? null : 'Task can not be empty.';
  }

  Color get categoryColor {
    return category == null ? Colors.grey : category!.categoryColor;
  }

  String get dateTimeString {
    int differenceInDays = dateTime.day - DateTime.now().day;
    int differenceInMonths = dateTime.month - DateTime.now().month;
    int differenceInYears = dateTime.year - DateTime.now().year;
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
      return DateFormat.Md().format(dateTime);
    }
  }

  String get submitText => isEdit ? 'Save' : 'New Task';

  AddTaskState copyWith({
    // we don't need to change isEdit
    AddModel? task,
    Category? category,
    DateTime? dateTime,
    bool? isSubmitting,
  }) =>
      AddTaskState(
          isEdit: this.isEdit,
          isSubmitting: isSubmitting ?? this.isSubmitting,
          task: task ?? this.task,
          category: category ?? this.category,
          dateTime: dateTime ?? this.dateTime);

  @override
  List<Object?> get props => [task, category, dateTime, isEdit, isSubmitting];
}
