import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schedule/core/constants/constants.dart';
import 'package:schedule/core/utils/utils.dart';
import 'package:schedule/data/models/taskWithColor.dart';
import 'package:schedule/logic/cubit/calendar/calendar_cubit.dart';
import 'package:schedule/logic/cubit/calendar/calendar_cubit.dart';
import 'package:schedule/logic/cubit/tasks/tasks_cubit.dart';
import 'package:schedule/presentation/widgets/task_list_tile.dart';
import 'package:schedule/presentation/widgets/task_table_calendar.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KScaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: KIconColor,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
      body: BlocConsumer<CalendarCubit, CalendarState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: KIconColor.withOpacity(0.2),
                      offset: Offset(0, 3),
                      blurRadius: 20,
                    ),
                  ],
                ),
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: TaskTableCalendar(
                  focusedDay: state.focusedDay,
                  selectedDay: state.selectedDay,
                  getEventsForDay: state.getEventsForDay,
                  onDaySelected: context.read<CalendarCubit>().onDaySelected,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: state.selectedEvents.isEmpty
                      ? const Center(
                          child: Text(
                            'No Tasks on the day.',
                            style: TextStyle(fontSize: 18, color: KIconColor),
                          ),
                        )
                      : ListView.builder(
                          itemCount: state.selectedEvents.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Dismissible(
                                key: Key(
                                    '${state.selectedEvents[index].task.taskId}'),
                                direction: DismissDirection.endToStart,
                                confirmDismiss: (direction) async {
                                  return await Future.value(
                                      direction == DismissDirection.endToStart);
                                },
                                onDismissed: (direction) async {
                                  await context.read<TasksCubit>().deleteTask(
                                      task: state.selectedEvents[index]);
                                  await context
                                      .read<CalendarCubit>()
                                      .deleteTask(state.selectedEvents[index]);
                                },
                                child: TaskListTile(
                                  taskWithColor: state.selectedEvents[index],
                                  onTap: () {},
                                  onCheckBoxTab: () async {
                                    await context.read<TasksCubit>().updateTask(
                                          task: state.selectedEvents[index].task
                                              .copyWith(
                                                  isCompleted: !state
                                                      .selectedEvents[index]
                                                      .task
                                                      .isCompleted),
                                          color: state.selectedEvents[index]
                                                  .color ??
                                              Colors.grey,
                                        );
                                    await context
                                        .read<CalendarCubit>()
                                        .updateTask(
                                            state.selectedEvents[index]);
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
