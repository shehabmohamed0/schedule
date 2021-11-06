import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schedule/core/constants/constants.dart';
import 'package:schedule/logic/cubit/categories/categories_cubit.dart';
import 'package:schedule/presentation/animation/show_up_animation.dart';
import 'package:schedule/presentation/router/app_router.dart';
import 'package:schedule/presentation/widgets/category_card.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconTheme.of(context).copyWith(color: KIconColor),
        backgroundColor: Colors.transparent,
        title: Text(
          'Categories',
          style: TextStyle(color: KDrawerColor),
        ),
      ),
      backgroundColor: KScaffoldBackgroundColor,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent[700],
        onPressed: () {
          Navigator.pushNamed(context, AppRouter.addCategoryScreen);
        },
        child: Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: BlocConsumer<CategoriesCubit, CategoriesState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state is CategoriesLoadedState) {
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    mainAxisExtent: 110),
                itemCount: state.categories.length,
                itemBuilder: (context, index) {
                  final currentCategory = state.categories[index];

                  return ShowUp(
                    goesUp: true,
                    delay: index * 100,
                    child: CategoryCard(
                      numAllTasks: currentCategory.numAllTasks,
                      showedTaskWord: state.showedWord(currentCategory),
                      categoryName: currentCategory.category.categoryName,
                      sliderColor: currentCategory.category.categoryColor,
                      sliderProgressValue: state.progressValue(currentCategory),
                      onTab: () {
                        Navigator.pushNamed(context, AppRouter.categoryScreen,
                            arguments: currentCategory);
                      },
                    ),
                  );
                },
              );
            } else if (state is CategoriesEmptyState) {
              return const _EmptyStateWidget();
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}

class _EmptyStateWidget extends StatelessWidget {
  const _EmptyStateWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Align(
        alignment: Alignment.center,
        child: ShowUp(
          goesUp: true,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Spacer(),
              const Expanded(
                child: Image(
                  image: const AssetImage('images/noCategories.png'),
                ),
              ),
              Text(
                'Their is no Categories',
                style: TextStyle(
                    fontSize: 28,
                    color: KIconColor,
                    fontWeight: FontWeight.w600),
              ),
              Text(
                '\"Go add Some \"',
                style: TextStyle(color: Colors.grey),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
