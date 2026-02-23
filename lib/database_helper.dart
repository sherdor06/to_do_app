import 'dart:async';
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:to_do_app/task.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._instance();
  static Database? _database;

  DatabaseHelper._instance(); // private constructor — DatabaseHelper faqat bitta instance bilan ishlashi uchun (Singleton pattern)

  String taskTable = 'task_table';
  String columnId = 'id';
  String columnTitle = 'title';
  String columnDate = 'date';
  String columnPriority = 'priority';
  String columnStatus = 'status';

  //Task tables
  //Id | title | date | priority | status
  //0    abs    1919    High      true
  //1
  Database? _db; // ochilgan databaseni saqlab turadi agar ochilgan bo'lsa

  Future<Database?> get db async => _db ??=
      await _initDb(); // agar database ochilgan bo‘lsa o‘shani qaytaradi, aks holda database yaratadi

  Future<Database> _initDb() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'todolist.db');
    final todolistDb = await openDatabase(
      path,
      version: 1,
      onCreate: _onCreateDb,
    );
    return todolistDb;
  }

  void _onCreateDb(Database db, int version) async {
    // database birinchi marta yaratilganda task_table jadvalini yaratadi
    await db.execute(
      'CREATE TABLE $taskTable('
      '$columnId INTEGER PRIMARY KEY AUTOINCREMENT, '
      '$columnTitle TEXT, '
      '$columnDate TEXT, '
      '$columnPriority TEXT, '
      '$columnStatus INTEGER)',
    );
  }

  Future<List<Map<String, dynamic>>> getTaskMapList() async {
    final db = await this.db;

    if (db == null) {
      return [];
    }

    final List<Map<String, dynamic>> result =
    await db.query(taskTable);

    return result;
  }
  Future<int?> getTaskList(List<Task> taskList) async {
    final List<Map<String, dynamic>>? taskMapList = await getTaskMapList();
    final List<Task> taskList = [];
    taskMapList?.forEach((element) {
      taskList.add(Task.fromMap(element));
    });
    return null;
  }

  Future<int?> insertTask(Task task) async {
    Database? db = await this.db;
    final int? result = await db?.insert(taskTable, task.toMap());
    return result;
  }

  Future<int?> updateTask(Task task) async {
    Database? db = await this.db;
    final int? result = await db?.update(
      taskTable,
      task.toMap(),
      where: '$columnId = ?',
      whereArgs: [task.id],
    );
    return result;
  }

  Future<int?> deleteTask(int id) async {
    Database? db = await this.db;
    final int? result = await db?.delete(
      taskTable,
      where: '$columnId = ?',
      whereArgs: [id],
    );
    return result;
  }
}
