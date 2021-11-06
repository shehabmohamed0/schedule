part of 'categories_cubit.dart';

@immutable
abstract class CategoriesState extends Equatable {}

class CategoriesInitialState extends CategoriesState {
  @override
  List<Object?> get props => [];
}

class CategoriesLoadingState extends CategoriesState {
  @override
  List<Object?> get props => [];
}

class CategoriesLoadedState extends CategoriesState {
  final List<CategoryNumTasks> categories;

  CategoriesLoadedState({required this.categories});

  double progressValue(CategoryNumTasks currentCategory) {
    return currentCategory.numAllTasks != 0
        ? (currentCategory.numCompletedTasks / currentCategory.numAllTasks)
        : 0.04;
  }

  String showedWord(CategoryNumTasks currentCategory) {
    return (currentCategory.numAllTasks >= 0 &&
            currentCategory.numAllTasks <= 2)
        ? 'Task'
        : 'Tasks';
  }

  @override
  List<Object?> get props => [categories];
}

class CategoriesEmptyState extends CategoriesState {
  @override
  List<Object?> get props => [];
}
