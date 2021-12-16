import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:schedule/core/constants/constants.dart';
import 'package:schedule/data/models/category.dart';
import 'package:schedule/data/models/task.dart';
import 'package:schedule/logic/cubit/add_category/add_category_cubit.dart';
import 'package:schedule/logic/cubit/categories/categories_cubit.dart';
import 'package:schedule/logic/cubit/category/category_cubit.dart';
import 'package:schedule/logic/cubit/tasks/tasks_cubit.dart';
import 'package:schedule/presentation/animation/show_up_animation.dart';
import 'package:schedule/presentation/screens/add_category/add_category_screen.dart';
import 'package:schedule/presentation/widgets/date_picker_button.dart';
import 'package:schedule/presentation/widgets/picker_outlined_button.dart';
import 'package:schedule/presentation/widgets/task_list_tile.dart';

part 'widgets/task_number_card.dart';

part 'widgets/bar_widget.dart';

part 'widgets/bottom_modal_sheet_widget.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KScaffoldBackgroundColor,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: BlocConsumer<CategoryCubit, CategoryState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state is CategoryTasksLoadedState) {
              final int numAllTasks = state.categoryNumTasks.numAllTasks;
              final int numCompletedTasks =
                  state.categoryNumTasks.numCompletedTasks;
              final Color categoryColor =
                  state.categoryNumTasks.category.categoryColor;
              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                      ),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 15,
                          color: KIconColor.withOpacity(0.1),
                        )
                      ],
                    ),
                    child: Column(
                      children: [
                        CircularPercentIndicator(
                          radius: 150,
                          percent: state.progressPercent,
                          lineWidth: 4,
                          progressColor: categoryColor,
                          circularStrokeCap: CircularStrokeCap.round,
                          animateFromLastPercent: true,
                          animation: true,
                          animationDuration: 1000,
                          center: Text(
                            state.categoryNumTasks.category.categoryName,
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: KDrawerColor),
                          ),
                        ),
                        SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TaskNumberCard(
                                number: numCompletedTasks,
                                text: 'Finished',
                                color: categoryColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              TaskNumberCard(
                                number: numAllTasks - numCompletedTasks,
                                text: 'Pending',
                                color: categoryColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                    padding: EdgeInsets.symmetric(vertical: 15),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 15,
                          color: KIconColor.withOpacity(0.1),
                        )
                      ],
                    ),
                    child: BarWidget(
                      category: state.categoryNumTasks.category,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text(
                        'All TASKS',
                        style: TextStyle(
                          fontSize: 14,
                          color: KIconColor,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: Stack(
                      children: [
                        state.tasks.isEmpty
                            ? const _EmptyStateWidget()
                            : Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: ListView.builder(
                                  padding: EdgeInsets.zero,
                                  itemCount: state.tasks.length,
                                  itemBuilder: (context, index) {
                                    final currentTask = state.tasks[index];

                                    return Dismissible(
                                      key: Key('${currentTask.task.taskId}'),
                                      direction: DismissDirection.endToStart,
                                      confirmDismiss: (direction) async {
                                        return await Future.value(direction ==
                                            DismissDirection.endToStart);
                                      },
                                      onDismissed: (direction) async {
                                        await context
                                            .read<CategoryCubit>()
                                            .deleteTask(task: currentTask);
                                        await context
                                            .read<TasksCubit>()
                                            .deleteTask(task: currentTask);
                                      },
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 10.0),
                                        child: TaskListTile(
                                          taskWithColor: state.tasks[index],
                                          onCheckBoxTab: () async {
                                            final newTaskWithColor =
                                                await context
                                                    .read<CategoryCubit>()
                                                    .updateTask(
                                                        coloredTask:
                                                            state.tasks[index]);

                                            context
                                                .read<TasksCubit>()
                                                .refreshUiOnUpdate(
                                                    taskWithColor:
                                                        newTaskWithColor);
                                          },
                                          onTap: () {},
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                        Positioned(
                          bottom: 10,
                          right: 15,
                          child: FloatingActionButton(
                            backgroundColor:
                                state.categoryNumTasks.category.categoryColor,
                            child: Icon(Icons.add),
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                isDismissible: true,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(15),
                                        topLeft: Radius.circular(15))),
                                builder: (_) => BlocProvider.value(
                                  value: context.read<CategoryCubit>(),
                                  child: BottomModalSheetWidget(
                                      category:
                                          state.categoryNumTasks.category),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}

class _EmptyStateWidget extends StatelessWidget {
  const _EmptyStateWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: ShowUp(
        goesUp: true,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 4.0),
          child: Image(
            image: const AssetImage('images/noThing.png'),
          ),
        ),
      ),
    );
  }
}
