import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:schedule/core/constants/constants.dart';
import 'package:schedule/data/data_providers/categories_dao.dart';
import 'package:schedule/data/models/category.dart';
import 'package:schedule/data/models/task.dart';
import 'package:schedule/logic/cubit/add_task/add_task_cubit.dart';
import 'package:schedule/logic/cubit/tasks/tasks_cubit.dart';
import 'package:schedule/presentation/widgets/category_pricker_list_tile.dart';
import 'package:schedule/presentation/widgets/color_picker_button.dart';
import 'package:schedule/presentation/widgets/date_picker_button.dart';
import 'package:schedule/presentation/widgets/task_date_time_picker.dart';

class AddTaskScreen extends StatelessWidget {
  const AddTaskScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          child: BlocConsumer<AddTaskCubit, AddTaskState>(
            listener: (context, state) {
              //TODO: Implement this method
              if (state.isSubmitting && !state.isEdit) {
                context.read<TasksCubit>().createTaskAndAddItToUI(
                    task: Task(
                        name: state.task.value,
                        taskDay: state.taskDateTime,
                        hasStartTime: state.hasStartTime,
                        reminderDateTime: state.reminderDateTime),
                    category: state.category ?? null);

                Navigator.of(context).pop();
              } else if (state.isSubmitting && state.isEdit) {
                context.read<TasksCubit>().updateTask(
                    task: Task(
                      taskId:
                          context.read<AddTaskCubit>().currentTask!.task.taskId,
                      name: state.task.value,
                      taskDay: state.taskDateTime,
                      hasStartTime: state.hasStartTime,
                      reminderDateTime: state.reminderDateTime,
                      categoryId: state.category?.categoryID,
                    ),
                    color: state.category?.categoryColor ?? Colors.grey);
                Navigator.of(context).pop();
              }
            },
            builder: (context, state) {
              return LayoutBuilder(builder: (_, constrains) {
                return SingleChildScrollView(
                  child: Container(
                    height: constrains.maxHeight,
                    width: constrains.maxWidth,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.all(18),
                                shape: const CircleBorder(),
                                side: BorderSide(
                                    color: KIconColor.withOpacity(0.3),
                                    width: 2)),
                            child: const Icon(
                              Icons.close,
                              size: 24,
                              color: KIconColor,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        const Spacer(
                          flex: 2,
                        ),
                        TextFormField(
                          initialValue: state.task.value,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Enter new task',
                              hintStyle:
                                  TextStyle(color: KIconColor.withOpacity(.8)),
                              errorText: state.errorText),
                          style: const TextStyle(
                              fontSize: 28, color: Colors.black87),
                          onChanged: (value) {
                            context
                                .read<AddTaskCubit>()
                                .taskInputChanged(value);
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
                                  _datePicker(context: context, state: state);
                                },
                                dateTimeString: state.dateTimeString),
                            ColorPickerButton(
                              color: state.categoryColor,
                              onPressed: () async {
                                _categoryPicker(
                                    context: context,
                                    screenWidth: screenWidth,
                                    screenHeight: screenHeight);
                              },
                            )
                          ],
                        ),
                        const Spacer(
                          flex: 2,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const SizedBox(),
                            IconButton(
                              icon: const Icon(
                                Icons.create_new_folder_outlined,
                                color: KIconColor,
                                size: 32,
                              ),
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: const Icon(
                                FontAwesomeIcons.flag,
                                color: KIconColor,
                                size: 26,
                              ),
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: const Icon(
                                FontAwesomeIcons.moon,
                                color: KIconColor,
                                size: 26,
                              ),
                              onPressed: () {},
                            ),
                            const SizedBox(),
                          ],
                        ),
                        const Spacer(
                          flex: 2,
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            width: 185.0,
                            height: 70.0,
                            decoration: BoxDecoration(
                                color: Colors.blueAccent[700],
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(50)),
                            child: RawMaterialButton(
                              elevation: 0.0,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      state.submitText,
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 18),
                                    ),
                                    const Icon(
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
                    ),
                  ),
                );
              });
            },
          ),
        ),
      ),
    );
  }

  void _categoryPicker(
      {required BuildContext context,
      required double screenWidth,
      required double screenHeight}) async {
    final categories = await CategoriesDao.instance.readAll()
      ..add(
        Category(
            categoryID: null,
            categoryName: 'No Category',
            categoryColor: Colors.grey),
      );
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
                maxHeight: screenHeight / 3, maxWidth: screenWidth / 1.5),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Scrollbar(
                isAlwaysShown: false,
                thickness: 5,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: categories.length,
                  itemBuilder: (_, index) => CategoryPickerListTile(
                    category: categories[index],
                    onTap: () {
                      context
                          .read<AddTaskCubit>()
                          .taskCategoryChanged(categories[index]);
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _datePicker(
      {required BuildContext context, required AddTaskState state}) async {
    final tempTask = await showDialog<Task?>(
      context: context,
      builder: (_) => Dialog(
        elevation: 1,
        backgroundColor: Colors.white,
        child: TaskDateTimePicker(
          currentTaskDay: state.taskDateTime,
          hasStartTime: state.hasStartTime,
          reminderDateTime: state.reminderDateTime,
        ),
      ),
    );
    if (tempTask != null) {
      context.read<AddTaskCubit>().setTaskTimeInfo(
          taskDateTime: tempTask.taskDay,
          hasStartTime: tempTask.hasStartTime,
          reminderTime: tempTask.reminderDateTime);
    }
  }
}
