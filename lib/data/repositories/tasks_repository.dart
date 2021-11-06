import 'package:schedule/data/data_providers/tasks_dao.dart';
import 'package:schedule/data/models/task.dart';
import 'package:schedule/data/models/taskWithColor.dart';
import 'package:schedule/data/models/category.dart';

class TasksRepository {
  final tasksDao = TasksDao.instance;

  Future<Task> create(Task task) async {
    return await tasksDao.create(task);
  }

  Future<Task?> read(int id) async {
    return await tasksDao.read(id);
  }

  Future<List<Task>> readAll() async {
    return tasksDao.readAll();
  }

  Future<List<TaskWithColor>> readAllWithColor() async {
    return await tasksDao.readAllWithColor();
  }

  Future<List<TaskWithColor>> readCategoryTasksWithColor(
      Category category) async {
    return await tasksDao.readCategoryTasksWithColor(category);
  }

  Future<int> update(Task task) async {
    return tasksDao.update(task);
  }

  Future<int> delete(int id) async {
    return tasksDao.delete(id);
  }

  Future<void> deleteCategoryTasks(int id) async {
    return tasksDao.deleteCategoryTasks(id);
  }

  Future<void> deleteAll() async {
    return tasksDao.deleteAll();
  }
}
