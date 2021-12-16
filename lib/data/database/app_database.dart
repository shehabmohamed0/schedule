import 'dart:io';

import 'package:path/path.dart';
import 'package:schedule/data/models/category.dart';
import 'package:schedule/data/models/task.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class AppDatabase {
  static final AppDatabase instance = AppDatabase._init();
  static Database? _database;

  AppDatabase._init();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDB('tasks.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final Directory document = await getApplicationDocumentsDirectory();
    String path = join(document.path, filePath);
    return await openDatabase(path,
        version: 1, onCreate: _createDB, onOpen: _onOpen);
  }

  Future _onOpen(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON;');
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';

    final textType = 'TEXT NOT NULL';
    final nullTextType = 'TEXT';

    final boolType = 'BOOLEAN NOT NULL';

    final integerType = 'INTEGER NOT NULL';
    final nullIntegerType = 'INTEGER';

    //Create categories table
    await db.execute('''
      CREATE TABLE $categoriesTable(
      ${CategoryFields.id} $idType,
      ${CategoryFields.name} $textType,
      ${CategoryFields.color} $integerType    
      )
    ''');

    //Create tasks t-able with foreign key from categories
    await db.execute('''
      CREATE TABLE $tasksTable(
      ${TaskFields.id} $idType,
      ${TaskFields.name} $textType,
      ${TaskFields.isCompleted} $boolType,
      ${TaskFields.taskDate} $textType,
      ${TaskFields.hasStartTime} $boolType,
      ${TaskFields.reminderDateTime} $nullTextType,
      ${TaskFields.categoryId} $nullIntegerType, 
       CONSTRAINT fk_category FOREIGN KEY (${TaskFields.categoryId})
       REFERENCES $categoriesTable (${CategoryFields.id})
       ON DELETE CASCADE
      )
    ''');
  }
}
