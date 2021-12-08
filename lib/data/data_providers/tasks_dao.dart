import 'package:schedule/data/database/app_database.dart';
import 'package:schedule/data/models/category.dart';
import 'package:schedule/data/models/task.dart';
import 'package:schedule/data/models/taskWithColor.dart';

class TasksDao {
  static final TasksDao instance = TasksDao._init();

  TasksDao._init();

  Future<Task> create(Task task) async {
    final db = await AppDatabase.instance.database;
    final taskId = await db.insert(tasksTable, task.toJson());
    return task.copyWith(taskId: taskId);
  }

  Future<Task> read(int id) async {
    final db = await AppDatabase.instance.database;

    final maps = await db.query(
      tasksTable,
      columns: TaskFields.values,
      where: '${TaskFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Task.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Task>> readAll() async {
    final db = await AppDatabase.instance.database;
    final result = await db.query(
      tasksTable,
    );
    print(result);
    return result.map((json) => Task.fromJson(json)).toList();
  }

  Future<List<TaskWithColor>> readAllWithColor() async {
    final db = await AppDatabase.instance.database;

    final result = await db.rawQuery('''
    SELECT  * from $tasksTable LEFT JOIN $categoriesTable
    ON ($tasksTable.${TaskFields.categoryId} = $categoriesTable.${CategoryFields.id} ) 
    ''');
    return result.map((json) => TaskWithColor.fromJson(json)).toList();
  }

  Future<List<TaskWithColor>> readCategoryTasksWithColor(
      Category category) async {
    final db = await AppDatabase.instance.database;

    final result = await db.rawQuery('''
    SELECT  * from $tasksTable JOIN $categoriesTable
    ON $tasksTable.${TaskFields.categoryId} = $categoriesTable.${CategoryFields.id} 
    WHERE $tasksTable.${TaskFields.categoryId} = ${category.categoryID}
    ''');
    return result.map((json) => TaskWithColor.fromJson(json)).toList();
  }

  Future<int> update(Task task) async {
    final db = await AppDatabase.instance.database;

    return await db.update(
      tasksTable,
      task.toJson(),
      where: '${TaskFields.id} = ?',
      whereArgs: [task.taskId],
    );
  }

  Future<int> delete(int id) async {
    final db = await AppDatabase.instance.database;

    return await db.delete(
      tasksTable,
      where: '${TaskFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteCategoryTasks(int id) async {
    final db = await AppDatabase.instance.database;

    await db.delete(
      tasksTable,
      where: '${TaskFields.categoryId} = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteAll() async {
    final db = await AppDatabase.instance.database;

    db.delete(tasksTable);
  }
}
