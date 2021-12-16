part of 'tasks_cubit.dart';

@immutable
abstract class TasksState extends Equatable {}

class TasksInitialState extends TasksState {
  @override
  List<Object?> get props => [];
}

class TasksLoadingState extends TasksState {
  @override
  List<Object?> get props => [];
}

class TasksLoadedState extends TasksState {
  final List<ColoredTask> tasks;

  TasksLoadedState({required this.tasks});

  @override
  List<Object?> get props => [tasks];
}

class TasksEmptyState extends TasksState {
  @override
  List<Object?> get props => [];
}
