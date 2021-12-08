import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:schedule/presentation/animation/show_up_animation.dart';
import 'package:schedule/presentation/screens/home_screen/widgets/tasks_list_view.dart';

import 'package:schedule/core/constants/constants.dart';
import 'package:schedule/presentation/router/app_router.dart';
import 'package:schedule/presentation/screens/home_screen/widgets/categories_list_view.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key, required this.openCallBack}) : super(key: key);
  final VoidCallback openCallBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KScaffoldBackgroundColor,
      appBar: AppBar(
        leadingWidth: 60,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: FaIcon(
            FontAwesomeIcons.gripLines,
            color: KIconColor,
          ),
          onPressed: openCallBack,
        ),
        actions: [
          IconButton(
            icon: FaIcon(
              FontAwesomeIcons.search,
              color: KIconColor,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: FaIcon(
              FontAwesomeIcons.calendar,
              color: KIconColor,
            ),
            onPressed: () {
              Navigator.of(context).pushNamed(AppRouter.calendarScreen);
            },
          )
        ],
      ),
      floatingActionButton: ShowUp(
        goesUp: false,
        child: FloatingActionButton(
          backgroundColor: Colors.blueAccent[700],
          onPressed: () {
            Navigator.pushNamed(context, AppRouter.addTaskScreen);
          },
          child: Icon(Icons.add),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: SafeArea(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                ShowUp(
                  goesUp: false,
                  child: Text(
                    'What\'s up, Joy!',
                    style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        color: KDrawerColor),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                ShowUp(
                  goesUp: false,
                  duration: Duration(milliseconds: 600),
                  child: Text(
                    'CATEGORIES',
                    style: TextStyle(
                        fontSize: 14, letterSpacing: 1.5, color: KIconColor),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  height: 110,
                  child: CategoriesListView(),
                ),
                SizedBox(
                  height: 40,
                ),
                ShowUp(
                  goesUp: false,
                  duration: Duration(milliseconds: 600),
                  child: Text(
                    'TODAY\'S TASKS',
                    style: TextStyle(
                      fontSize: 14,
                      color: KIconColor,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TasksListView(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
