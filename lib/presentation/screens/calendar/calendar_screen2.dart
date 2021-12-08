import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schedule/core/constants/constants.dart';
import 'package:schedule/core/utils.dart';
import 'package:schedule/data/models/taskWithColor.dart';
import 'package:schedule/logic/cubit/calendar/calendar_cubit.dart';
import 'package:schedule/logic/cubit/calendar/calendar_cubit.dart';
import 'package:schedule/logic/cubit/tasks/tasks_cubit.dart';
import 'package:schedule/presentation/widgets/task_list_tile.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen2 extends StatelessWidget {
  const CalendarScreen2({Key? key}) : super(key: key);

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
                child: TableCalendar<TaskWithColor>(
                  firstDay: kFirstDay,
                  lastDay: kLastDay,
                  focusedDay: state.focusedDay,
                  selectedDayPredicate: (day) =>
                      isSameDay(state.selectedDay, day),

                  calendarFormat: CalendarFormat.month,

                  eventLoader: state.getEventsForDay,
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleTextStyle:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  calendarStyle: CalendarStyle(
                    // Use `CalendarStyle` to customize the UI
                    outsideDaysVisible: false,
                    defaultTextStyle: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  daysOfWeekHeight: 24,
                  daysOfWeekStyle: DaysOfWeekStyle(
                    weekdayStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black45),
                    weekendStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black45),
                  ),
                  onDaySelected: context.read<CalendarCubit>().onDaySelected,
                  // onPageChanged: (focusedDay) {
                  //   _focusedDay = focusedDay;
                  // },
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ListView.builder(
                    itemCount: state.selectedEvents.length,
                    itemBuilder: (context, index) {

                      return Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Dismissible(
                          key:
                              Key('${state.selectedEvents[index].task.taskId}'),
                          direction: DismissDirection.endToStart,
                          confirmDismiss: (direction) async {
                            return await Future.value(
                                direction == DismissDirection.endToStart);
                          },
                          onDismissed: (direction) async {
                            await context
                                .read<TasksCubit>()
                                .deleteTask(task: state.selectedEvents[index]);
                            await context
                                .read<CalendarCubit>()
                                .deleteTask(state.selectedEvents[index]);
                          },
                          child: TaskListTile(
                              taskWithColor: state.selectedEvents[index],
                              onTap: () {},
                              onCheckBoxTab: () async{

                                await  context.read<TasksCubit>().updateTask(
                                  task:state.selectedEvents[index].task.copyWith(
                                      isCompleted:
                                      !state.selectedEvents[index].task.isCompleted),
                                  color: state.selectedEvents[index].color ?? Colors.grey,
                                );
                                await context
                                    .read<CalendarCubit>()
                                    .updateTask(state.selectedEvents[index]);
                              }),
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
