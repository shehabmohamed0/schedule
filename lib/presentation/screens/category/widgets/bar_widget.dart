part of '../category_screen.dart';

class BarWidget extends StatelessWidget {
  const BarWidget({Key? key, required this.category}) : super(key: key);

  final Category category;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(
            Icons.arrow_back_rounded,
            color: category.categoryColor,
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => MultiBlocProvider(
                          providers: [
                            BlocProvider.value(
                                value: context.read<CategoryCubit>()),
                            BlocProvider<AddCategoryCubit>(
                              create: (context) =>
                                  AddCategoryCubit(currentCategory: category),
                            ),
                          ],
                          child: AddCategoryScreen(),
                        )));
          },
          child: Icon(
            Icons.edit,
            color: category.categoryColor,
          ),
        ),
        InkWell(
          onTap: () {
            _showAlertDialog(context, category);
          },
          child: Icon(
            Icons.delete,
            color: category.categoryColor,
          ),
        ),
      ],
    );
  }

  void _showAlertDialog(BuildContext context, Category category) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text('Delete category?'),
              content: Text(
                  'By deleting this category you won\'t be able to get it back again.'),
              actions: [
                TextButton(
                  onPressed: () async {
                    await context
                        .read<CategoryCubit>()
                        .deleteCategoryTasks(category: category);
                    await context
                        .read<TasksCubit>()
                        .deleteCategoryTasks(category: category);

                    await context.read<CategoriesCubit>().loadCategories();
                    Navigator.of(context).pop();
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
}
