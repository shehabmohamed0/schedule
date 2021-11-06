import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schedule/core/constants/constants.dart';
import 'package:schedule/logic/cubit/categories/categories_cubit.dart';
import 'package:schedule/presentation/animation/show_up_animation.dart';
import 'package:schedule/presentation/router/app_router.dart';

import '../../../widgets/category_card.dart';

class CategoriesListView extends StatelessWidget {
  const CategoriesListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CategoriesCubit, CategoriesState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is CategoriesLoadedState) {
          return ShowUp(
            goesUp: false,
            child: ListView.separated(
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final currentCategory = state.categories[index];
                return CategoryCard(
                  numAllTasks: currentCategory.numAllTasks,
                  showedTaskWord: state.showedWord(currentCategory),
                  categoryName: currentCategory.category.categoryName,
                  sliderColor: currentCategory.category.categoryColor,
                  sliderProgressValue: state.progressValue(currentCategory),
                  onTab: () {
                    Navigator.pushNamed(context, AppRouter.categoryScreen,
                        arguments: currentCategory);
                  },
                );
              },
              itemCount: state.categories.length,
              clipBehavior: Clip.none,
              scrollDirection: Axis.horizontal,
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(
                  width: 10,
                );
              },
            ),
          );
        } else if (state is CategoriesEmptyState) {
          return _EmptyStateWidget();
        } else
          return Container();
        //_categoriesLoadingStateWidget();
      },
    );
  }
}

class _EmptyStateWidget extends StatelessWidget {
  const _EmptyStateWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShowUp(
      goesUp: true,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            image: const AssetImage('images/noCategories.png'),
          ),
          SizedBox(
            width: 20,
          ),
          Column(
            children: [
              Text(
                'No categories yet!',
                style: TextStyle(
                    fontSize: 24,
                    color: KIconColor,
                    fontWeight: FontWeight.w600),
              ),
              Text(
                '\"Go add Some\"',
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.blueAccent[400], shape: CircleBorder()),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: (Icon(Icons.add)),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, AppRouter.addCategoryScreen);
                  }),
            ],
          )
        ],
      ),
    );
  }
}
