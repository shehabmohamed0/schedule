part of 'add_category_cubit.dart';

class AddCategoryState extends Equatable {
  final int? categoryId;
  final FormzNameModel categoryName;
  final Color categoryColor;
  final FormzStatus status;

  //Identify that are we adding a new task or modifying existing one
  final bool isEdit;
  final bool isSubmitting;

  AddCategoryState({
    this.categoryId,
    required this.categoryName,
    required this.categoryColor,
    required this.status,
    required this.isEdit,
    required this.isSubmitting,
  });

  AddCategoryState copyWith(
          {FormzNameModel? categoryName,
          Color? categoryColor,
          FormzStatus? status,
          bool? isSubmitting}) =>
      AddCategoryState(
        isEdit: this.isEdit,
        isSubmitting: isSubmitting ?? this.isSubmitting,
        categoryId: this.categoryId,
        categoryName: categoryName ?? this.categoryName,
        categoryColor: categoryColor ?? this.categoryColor,
        status: status ?? this.status,
      );

  String? get errorText {
    return ((categoryName.pure) || categoryName.valid)
        ? null
        : 'Category name can not be empty.';
  }

  @override
  List<Object> get props => [categoryName, categoryColor, status, isSubmitting];
}
