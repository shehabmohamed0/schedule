import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:schedule/data/models/category.dart';
import 'package:schedule/data/models/category_num_tasks.dart';
import 'package:schedule/data/models/taskWithColor.dart';
import 'package:schedule/data/repositories/categories_repository.dart';
import 'package:schedule/logic/cubit/tasks/tasks_cubit.dart';

part 'categories_state.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  CategoriesRepository _categoriesRepository = CategoriesRepository();

  CategoriesCubit() : super(CategoriesInitialState());

  Future<void> loadCategories() async {
    final categories = await _categoriesRepository.readAllWithNumTasks();
    if (categories.isEmpty) {
      emit(CategoriesEmptyState());
    } else {
      emit(CategoriesLoadedState(categories: categories));
    }
  }

  Future<void> addCategory(String categoryName, Color categoryColor) async {
    await _categoriesRepository.create(
        Category(categoryName: categoryName, categoryColor: categoryColor));
    await loadCategories();
  }

  Future<void> updateCategory(Category category) async {
    if (state is CategoriesLoadedState) {
      await _categoriesRepository.update(category);
      await loadCategories();
    }
  }

  Future<void> deleteCategory(Category category) async {
    if (state is CategoriesLoadedState) {
      await _categoriesRepository.delete(category.categoryID!);
      await loadCategories();
    }
  }
}
