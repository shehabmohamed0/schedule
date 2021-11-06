import 'category.dart';

class CategoryNumTasksFields {
  static const completedTasks = 'completedTasks';
  static const AllTasks = 'AllTasks';
}

class CategoryNumTasks {
  final Category category;
  final int numCompletedTasks;
  final int numAllTasks;

  const CategoryNumTasks(
      {required this.category,
      required this.numCompletedTasks,
      required this.numAllTasks});

  static CategoryNumTasks fromJson(Map<String, Object?> json) {
    return CategoryNumTasks(
        category: Category.fromJson(json),
        numCompletedTasks: json[CategoryNumTasksFields.completedTasks] as int,
        numAllTasks: (json[CategoryNumTasksFields.AllTasks] as int));
  }

  CategoryNumTasks copyWith(
          {Category? category, int? numCompletedTasks, int? numAllTasks}) =>
      CategoryNumTasks(
          category: category ?? this.category,
          numCompletedTasks: numCompletedTasks ?? this.numCompletedTasks,
          numAllTasks: numAllTasks ?? this.numAllTasks);
}
