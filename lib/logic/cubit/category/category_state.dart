part of 'category_cubit.dart';

abstract class CategoryState extends Equatable {}

class CategoryTasksLoadingState extends CategoryState {
  @override
  List<Object?> get props => [];
}

class CategoryTasksLoadedState extends CategoryState {
  final CategoryNumTasks categoryNumTasks;
  final List<ColoredTask> tasks;

  CategoryTasksLoadedState(
      {required this.categoryNumTasks, required this.tasks});

  double get progressPercent {
    if (categoryNumTasks.numAllTasks == 0)
      return 0;
    else
      return categoryNumTasks.numCompletedTasks / categoryNumTasks.numAllTasks;
  }

  @override
  List<Object?> get props => [categoryNumTasks, tasks];
}
