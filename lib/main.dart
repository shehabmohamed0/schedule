import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schedule/core/constants/constants.dart';
import 'package:schedule/data/data_providers/categories_dao.dart';
import 'package:schedule/data/models/category.dart';
import 'package:schedule/data/repositories/categories_repository.dart';
import 'package:schedule/data/data_providers/notification_plugin.dart';
import 'package:schedule/presentation/router/app_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data/models/recieved_notification.dart';
import 'logic/cubit/add_task/add_task_cubit.dart';
import 'logic/cubit/categories/categories_cubit.dart';
import 'logic/cubit/tasks/tasks_cubit.dart';
import 'logic/debug/app_bloc_observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initialize();
  NotificationPlugin.initialize();
  NotificationPlugin.instance
      .setListenedForLowerVersions(onNotificationInLowerVersions);
  NotificationPlugin.instance.setOnNotificationClick(onNotificationClick);
  //Bloc.observer = AppBlocObserver();

  runApp(const MyApp());
}

Future<void> initialize() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.getInt('key') == null) {
    CategoriesDao.instance.create(
        Category(categoryName: 'Business', categoryColor: Colors.purpleAccent));

    CategoriesDao.instance.create(Category(
        categoryName: 'Personal', categoryColor: Colors.blueAccent[700]!));
    prefs.setInt('key', 1);
  }
}

void onNotificationInLowerVersions(ReceivedNotification receivedNotification) {}

void onNotificationClick(String payload) {}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TasksCubit>(
          create: (BuildContext context) => TasksCubit()..loadTasks(),
        ),
        BlocProvider<CategoriesCubit>(
          create: (BuildContext context) => CategoriesCubit()..loadCategories(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme:
            ThemeData(primaryIconTheme: const IconThemeData(color: KIconColor)),
        onGenerateRoute: AppRouter.onGenerateRoute,
        initialRoute: AppRouter.drawerNavigator,
      ),
    );
  }
}
