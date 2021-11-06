import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:schedule/core/constants/constants.dart';
import 'package:schedule/data/models/category.dart';
import 'package:schedule/logic/cubit/add_category/add_category_cubit.dart';
import 'package:schedule/logic/cubit/categories/categories_cubit.dart';
import 'package:schedule/logic/cubit/category/category_cubit.dart';
import 'package:schedule/logic/cubit/tasks/tasks_cubit.dart';
import 'package:schedule/presentation/widgets/color_picker_button.dart';

class AddCategoryScreen extends StatelessWidget {
  const AddCategoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: BlocConsumer<AddCategoryCubit, AddCategoryState>(
            listener: (context, state) async {
              if (state.isSubmitting && !state.isEdit) {
                await context
                    .read<CategoriesCubit>()
                    .addCategory(state.categoryName.value, state.categoryColor);
                Navigator.of(context).pop();
              } else if (state.isSubmitting && state.isEdit) {
                final updatedCategory = Category(
                    categoryID: state.categoryId,
                    categoryName: state.categoryName.value,
                    categoryColor: state.categoryColor);

                await context.read<CategoriesCubit>().updateCategory(
                      updatedCategory,
                    );

                await context.read<CategoryCubit>().updateCategory(
                      updatedCategory,
                    );

                Navigator.of(context).pop();
              }
            },
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.all(18),
                          shape: CircleBorder(),
                          side: BorderSide(
                              color: KIconColor.withOpacity(0.3), width: 2)),
                      child: Icon(
                        Icons.close,
                        size: 24,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  SizedBox(
                    height: 100,
                  ),
                  TextFormField(
                    initialValue: state.categoryName.value,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter Category name',
                        hintStyle: TextStyle(color: KIconColor.withOpacity(.8)),
                        errorText: state.errorText),
                    style: TextStyle(fontSize: 28, color: Colors.black87),
                    onChanged: (value) {
                      context
                          .read<AddCategoryCubit>()
                          .categoryInputChanged(value);
                    },
                    textInputAction: TextInputAction.done,
                  ),
                  SizedBox(
                    height: screenHeight / 25,
                  ),
                  Row(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            elevation: 2,
                            primary: Colors.red,
                            padding: EdgeInsets.symmetric(
                                horizontal: 32, vertical: 20),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100)),
                            side: BorderSide(
                                color: KIconColor.withOpacity(0.3), width: 2)),
                        child: Text(
                          'Delete',
                          style: TextStyle(fontSize: 18),
                        ),
                        onPressed: state.isEdit
                            ? () {
                                _showAlertDialog(context, state);
                              }
                            : null,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      ColorPickerButton(
                        color: state.categoryColor,
                        onPressed: () async {
                          _colorPicker(context, state);
                        },
                      )
                    ],
                  ),
                  Spacer(),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      width: 160.0,
                      height: 70.0,
                      decoration: BoxDecoration(
                          color: Colors.blueAccent[700],
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(50)),
                      child: RawMaterialButton(
                        elevation: 0.0,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                'Save',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                              Icon(
                                Icons.keyboard_arrow_up_outlined,
                                color: Colors.white,
                              )
                            ],
                          ),
                        ),
                        onPressed: () async {
                          context.read<AddCategoryCubit>().submit();
                        },
                      ),
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _showAlertDialog(BuildContext context, AddCategoryState state) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text('Delete category?'),
              content: Text(
                  'By deleting this category you won\'t be able to get it back again.'),
              actions: [
                TextButton(
                  onPressed: () {
                    final currentCategory = Category(
                        categoryID: state.categoryId,
                        categoryName: state.categoryName.value,
                        categoryColor: state.categoryColor);
                    context
                        .read<CategoriesCubit>()
                        .deleteCategory(currentCategory);

                    context
                        .read<TasksCubit>()
                        .deleteCategoryTasks(category: currentCategory);

                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  child: Text(
                    'Delete',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(),
                  ),
                ),
              ],
            ));
  }

  void _colorPicker(BuildContext context, AddCategoryState state) {
    showDialog<Color?>(
      context: context,
      builder: (
        BuildContext _,
      ) {
        Color currentColor = Color(state.categoryColor.value);
        return AlertDialog(
          scrollable: true,
          titlePadding: const EdgeInsets.all(0.0),
          contentPadding: const EdgeInsets.all(0.0),
          content: Column(
            children: [
              ColorPicker(
                pickerColor: state.categoryColor,
                onColorChanged: (changeColor) {
                  currentColor = changeColor;
                },
                enableAlpha: true,
                // hexInputController will respect it too.
                displayThumbColor: true,
                showLabel: true,
                paletteType: PaletteType.hsv,
                pickerAreaBorderRadius: const BorderRadius.only(
                  topLeft: const Radius.circular(2.0),
                  topRight: const Radius.circular(2.0),
                ),
                // <- here
                portraitOnly: true,
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextButton(
                  onPressed: () {
                    context
                        .read<AddCategoryCubit>()
                        .categoryColorChanged(currentColor);
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Select',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
