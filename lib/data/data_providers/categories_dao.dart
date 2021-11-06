import 'package:schedule/data/database/app_database.dart';
import 'package:schedule/data/models/category.dart';
import 'package:schedule/data/models/category_num_tasks.dart';
import 'package:schedule/data/models/task.dart';

class CategoriesDao {
  static final CategoriesDao instance = CategoriesDao._init();

  CategoriesDao._init();

  Future<Category> create(Category category) async {
    final db = await AppDatabase.instance.database;
    final categoryId = await db.insert(categoriesTable, category.toJson());
    return category.copyWith(categoryId: categoryId);
  }

  Future<Category> read(int id) async {
    final db = await AppDatabase.instance.database;

    final maps = await db.query(
      categoriesTable,
      columns: CategoryFields.values,
      where: '${CategoryFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Category.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Category>> readAll() async {
    final db = await AppDatabase.instance.database;
    final result = await db.query(
      categoriesTable,
    );
    return result.map((json) => Category.fromJson(json)).toList();
  }

  Future<List<CategoryNumTasks>> readAllWithNumTasks() async {
    final db = await AppDatabase.instance.database;
    final result = await db.rawQuery('''
      SELECT $categoriesTable.${CategoryFields.id},
        $categoriesTable.${CategoryFields.name},
        $categoriesTable.${CategoryFields.color},
        IFNULL(Completed,0) AS ${CategoryNumTasksFields.completedTasks},
        IFNULL(allTasks,0) AS ${CategoryNumTasksFields.AllTasks}
        FROM $categoriesTable
        LEFT JOIN ( 
          SELECT  COUNT($tasksTable.${TaskFields.id}) AS allTasks,
              $tasksTable.${TaskFields.categoryId} AS category_id,
         SUM(
         CASE WHEN $tasksTable.${TaskFields.isCompleted} = 1
                 THEN 1
            ELSE 0 
         END ) AS Completed
          FROM tasks
          GROUP BY $tasksTable.${TaskFields.categoryId}
           ) as T 
        on $categoriesTable.${CategoryFields.id} = T.category_id;
        )
      
    ''');

    return result.map((json) => CategoryNumTasks.fromJson(json)).toList();
  }

  Future<int> update(Category category) async {
    final db = await AppDatabase.instance.database;

    return await db.update(
      categoriesTable,
      category.toJson(),
      where: '${CategoryFields.id} = ?',
      whereArgs: [category.categoryID],
    );
  }

  Future<int> delete(int id) async {
    final db = await AppDatabase.instance.database;

    return await db.delete(
      categoriesTable,
      where: '${CategoryFields.id} = ?',
      whereArgs: [id],
    );
  }
}
