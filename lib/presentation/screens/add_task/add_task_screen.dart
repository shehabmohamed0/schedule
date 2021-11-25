import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:schedule/core/constants/constants.dart';
import 'package:schedule/data/data_providers/categories_dao.dart';
import 'package:schedule/data/models/add_model.dart';
import 'package:schedule/data/models/category.dart';
import 'package:schedule/data/models/task.dart';
import 'package:schedule/data/models/taskWithColor.dart';
import 'package:schedule/logic/cubit/add_task/add_task_cubit.dart';
import 'package:schedule/logic/cubit/tasks/tasks_cubit.dart';
import 'package:schedule/presentation/widgets/color_picker_button.dart';
import 'package:schedule/presentation/widgets/date_picker_button.dart';

class AddTaskScreen extends StatelessWidget {
  AddTaskScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          child: BlocConsumer<AddTaskCubit, AddTaskState>(
            listener: (context, state) {
              if (state.isSubmitting && !state.isEdit) {
                context.read<TasksCubit>().createTask(
                    task: Task(name: state.task.value, taskDay: state.dateTime),
                    category: state.category ?? null);

                Navigator.of(context).pop();
              } else if (state.isSubmitting && state.isEdit) {
                context.read<TasksCubit>().updateTask(
                    task: Task(
                        taskId: context
                            .read<AddTaskCubit>()
                            .currentTask!
                            .task
                            .taskId,
                        name: state.task.value,
                        categoryId: state.category?.categoryID,
                        taskDay: state.dateTime),
                    color: state.category?.categoryColor ?? Colors.grey);
                Navigator.of(context).pop();
              }
            },
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.all(18),
                          shape: CircleBorder(),
                          side: BorderSide(
                              color: KIconColor.withOpacity(0.3), width: 2)),
                      child: Icon(
                        Icons.close,
                        size: 24,
                        color: KIconColor,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  SizedBox(
                    height: screenHeight / 6,
                  ),
                  TextFormField(
                    initialValue: state.task.value,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter new task',
                        hintStyle: TextStyle(color: KIconColor.withOpacity(.8)),
                        errorText: state.errorText),
                    style: TextStyle(fontSize: 28, color: Colors.black87),
                    onChanged: (value) {
                      context.read<AddTaskCubit>().taskInputChanged(value);
                    },
                    textInputAction: TextInputAction.done,
                  ),
                  SizedBox(
                    height: screenHeight / 25,
                  ),
                  Row(
                    children: [
                      DatePickerButton(
                          onPressed: () async {
                            _datePicker(
                                context: context, initialDate: state.dateTime);
                          },
                          dateTimeString: state.dateTimeString),
                      ColorPickerButton(
                        color: state.categoryColor,
                        onPressed: () async {
                          _categoryPicker(
                              context: context, screenWidth: screenWidth);
                        },
                      )
                    ],
                  ),
                  Spacer(
                    flex: 1,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(),
                      IconButton(
                        icon: Icon(
                          Icons.timer_outlined,
                          color: KIconColor,
                          size: 28,
                        ),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.timer_outlined,
                          color: KIconColor,
                          size: 28,
                        ),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.timer_outlined,
                          color: KIconColor,
                          size: 28,
                        ),
                        onPressed: () {},
                      ),
                      SizedBox(),
                    ],
                  ),
                  Spacer(
                    flex: 2,
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      width: 180.0,
                      height: 70.0,
                      decoration: BoxDecoration(
                          color: Colors.blueAccent[700],
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(50)),
                      child: RawMaterialButton(
                        elevation: 0.0,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                state.submitText,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                              Icon(
                                Icons.keyboard_arrow_up_outlined,
                                color: Colors.white,
                              )
                            ],
                          ),
                        ),
                        onPressed: () async {
                          context.read<AddTaskCubit>().submit();
                        },
                      ),
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _categoryPicker(
      {required BuildContext context, required double screenWidth}) async {
    final categories = await CategoriesDao.instance.readAll()
      ..add(Category(
          categoryID: null,
          categoryName: 'No Category',
          categoryColor: Colors.grey));
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: screenWidth / 1.5,
              padding: EdgeInsets.all(10),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var category in categories)
                    Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          onTap: () {
                            context
                                .read<AddTaskCubit>()
                                .taskCategoryChanged(category);
                            Navigator.of(context).pop();
                          },
                          leading: Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                                color: category.categoryColor,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: category.categoryColor,
                                    blurRadius: 2,
                                    offset: Offset(1, 1),
                                  ),
                                ]),
                          ),
                          title: Text(
                            category.categoryName,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                        )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _datePicker(
      {required BuildContext context, required DateTime initialDate}) async {
    final newDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (newDate != null) {
      context.read<AddTaskCubit>().taskDateChanged(newDate);
    }
  }
}
