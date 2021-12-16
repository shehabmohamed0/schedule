import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schedule/core/constants/constants.dart';
import 'package:schedule/data/models/taskWithColor.dart';
import 'package:schedule/logic/cubit/categories/categories_cubit.dart';
import 'package:schedule/logic/cubit/tasks/tasks_cubit.dart';
import 'package:schedule/presentation/animation/show_up_animation.dart';
import 'package:schedule/presentation/router/app_router.dart';
import 'package:schedule/presentation/widgets/task_list_tile.dart';

class TasksListView extends StatelessWidget {
  const TasksListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TasksCubit, TasksState>(
      listener: (context, state) {
        if (state is TasksLoadedState || state is TasksEmptyState) {
          context.read<CategoriesCubit>().loadCategories();
        }
      },
      builder: (context, state) {
        if (state is TasksLoadedState)
          return _TasksLoadedStateWidget(tasks: state.tasks);
        else if (state is TasksEmptyState) return const _EmptyStateWidget();

        return Container();
      },
    );
  }
}

class _TasksLoadedStateWidget extends StatelessWidget {
  final List<ColoredTask> tasks;

  const _TasksLoadedStateWidget({Key? key, required this.tasks})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          final currentTaskWithColor = tasks[index];
          return ShowUp(
            goesUp: false,
            delay: index * 200,
            child: Dismissible(
              key: Key('${currentTaskWithColor.task.taskId} +Task'),
              direction: DismissDirection.endToStart,
              confirmDismiss: (direction) async {
                return await Future.value(
                    direction == DismissDirection.endToStart);
              },
              onDismissed: (direction) async {
                //_showSnackBar(context, state.tasks[index]);
                await context
                    .read<TasksCubit>()
                    .deleteTask(task: currentTaskWithColor);
              },
              child: Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: TaskListTile(
                  taskWithColor: currentTaskWithColor,
                  onCheckBoxTab: () {
                    context.read<TasksCubit>().updateTask(
                          task: currentTaskWithColor.task.copyWith(
                              isCompleted:
                                  !currentTaskWithColor.task.isCompleted),
                          color: currentTaskWithColor.color ?? Colors.grey,
                        );
                  },
                  onTap: () {
                    Navigator.pushNamed(context, AppRouter.addTaskScreen,
                        arguments: tasks[index]);
                  },
                ),
              ),
            ),
          );
        },
        itemCount: tasks.length,
      ),
    );
  }
}

class _EmptyStateWidget extends StatelessWidget {
  const _EmptyStateWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Align(
        alignment: Alignment.center,
        child: ShowUp(
          goesUp: true,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Expanded(
                child: Image(
                  image: const AssetImage('images/noThing.png'),
                ),
                flex: 8,
              ),
              Text(
                'No Tasks Today!',
                style: TextStyle(
                    fontSize: 28,
                    color: KIconColor,
                    fontWeight: FontWeight.w600),
              ),
              Text(
                '\"Go add Some Tasks\"',
                style: TextStyle(color: Colors.grey),
              ),
              Spacer(
                flex: 2,
              )
            ],
          ),
        ),
      ),
    );
  }
}
