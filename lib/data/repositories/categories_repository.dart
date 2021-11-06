import 'package:schedule/data/data_providers/categories_dao.dart';
import 'package:schedule/data/models/category.dart';
import 'package:schedule/data/models/category_num_tasks.dart';

class CategoriesRepository {
  CategoriesDao categoriesDao = CategoriesDao.instance;

  Future<Category> create(Category category) async {
    return categoriesDao.create(category);
  }

  Future<Category> read(int id) async {
    return await categoriesDao.read(id);
  }

  Future<List<Category>> readAll() async {
    return await categoriesDao.readAll();
  }

  Future<List<CategoryNumTasks>> readAllWithNumTasks() async {
    return await categoriesDao.readAllWithNumTasks();
  }

  Future<int> update(Category category) async {
    return await categoriesDao.update(category);
  }

  Future<int> delete(int id) async {
    return categoriesDao.delete(id);
  }
}
