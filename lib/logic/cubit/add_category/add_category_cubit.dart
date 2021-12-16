import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:schedule/data/models/add_model.dart';
import 'package:schedule/data/models/category.dart';

part 'add_category_state.dart';

class AddCategoryCubit extends Cubit<AddCategoryState> {
  AddCategoryCubit({Category? currentCategory})
      : super(
          currentCategory == null
              ? AddCategoryState(
                  isEdit: false,
                  isSubmitting: false,
                  categoryName: FormzNameModel.pure(),
                  categoryColor: Colors.blueAccent.shade400,
                  status: FormzStatus.pure)
              : AddCategoryState(
                  isEdit: true,
                  isSubmitting: false,
                  categoryId: currentCategory.categoryID,
                  categoryName: FormzNameModel.dirty(currentCategory.categoryName),
                  categoryColor: currentCategory.categoryColor,
                  status: FormzStatus.valid),
        );

  void categoryInputChanged(String category) {
    FormzNameModel newCategory = FormzNameModel.dirty(category);
    emit(state.copyWith(
        categoryName: FormzNameModel.dirty(category),
        status: Formz.validate([newCategory])));
  }

  void categoryColorChanged(Color categoryColor) {
    emit(state.copyWith(categoryColor: categoryColor));
  }

  void submit() {
    if (state.categoryName.pure) {
      final newCategory = FormzNameModel.dirty('');
      emit(state.copyWith(
          categoryName: newCategory, status: FormzStatus.invalid));
    } else if (state.categoryName.valid) {
      emit(state.copyWith(isSubmitting: true));
    }
  }
}
