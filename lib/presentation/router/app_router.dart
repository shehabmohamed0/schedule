import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schedule/data/models/category_num_tasks.dart';
import 'package:schedule/data/models/taskWithColor.dart';
import 'package:schedule/logic/cubit/add_category/add_category_cubit.dart';
import 'package:schedule/logic/cubit/add_task/add_task_cubit.dart';
import 'package:schedule/logic/cubit/calendar/calendar_cubit.dart';
import 'package:schedule/logic/cubit/category/category_cubit.dart';
import 'package:schedule/presentation/animation/drawer_navigator.dart';
import 'package:schedule/presentation/screens/add_category/add_category_screen.dart';
import 'package:schedule/presentation/screens/add_task/add_task_screen.dart';
import 'package:schedule/presentation/screens/calendar/calendar_screen.dart';
import 'package:schedule/presentation/screens/categories/categories_screen.dart';
import 'package:schedule/presentation/screens/category/category_screen.dart';
import '../../core/exceptions/route_exception.dart';
import '../notification_screen.dart';

class AppRouter {
  static const String drawerNavigator = 'drawerNavigator';
  static const String addTaskScreen = 'addTask';
  static const String categoriesScreen = 'categories';
  static const String addCategoryScreen = 'addCategory';
  static const String categoryScreen = 'category';
  static const String notificationScreen = 'notification';
  static const String calendarScreen = 'calendar';

  const AppRouter._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case drawerNavigator:
        return MaterialPageRoute(
          builder: (_) => DrawerNavigator(),
        );
      case addTaskScreen:
        final ColoredTask? args = settings.arguments as ColoredTask?;

        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => BlocProvider<AddTaskCubit>(
            create: (context) => AddTaskCubit(args),
            child: AddTaskScreen(),
          ),
          transitionsBuilder: (_, a, __, c) =>
              FadeTransition(opacity: a, child: c),
        );
      case categoriesScreen:
        return MaterialPageRoute(
          builder: (_) => const CategoriesScreen(),
        );
      case addCategoryScreen:
        return MaterialPageRoute(
          fullscreenDialog: true,
          builder: (_) => BlocProvider<AddCategoryCubit>(
            create: (context) => AddCategoryCubit(),
            child: const AddCategoryScreen(),
          ),
        );
      case categoryScreen:
        final args = settings.arguments as CategoryNumTasks;
        return MaterialPageRoute(
          fullscreenDialog: true,
          builder: (_) => BlocProvider<CategoryCubit>(
            create: (context) =>
                CategoryCubit(categoryNumTasks: args)..loadCategoryTasks(),
            child: const CategoryScreen(),
          ),
        );
      case notificationScreen:
        return MaterialPageRoute(
          fullscreenDialog: true,
          builder: (_) => const NotificationScreen(),
        );
      case calendarScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider<CalendarCubit>(
            create: (context) => CalendarCubit()..initialize(),
            child: const CalendarScreen(),
          ),
        );
      default:
        throw const RouteException('Route not found!');
    }
  }
}
