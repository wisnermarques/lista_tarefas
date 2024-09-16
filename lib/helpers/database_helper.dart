import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:lista_tarefas/models/tarefa.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  factory DatabaseHelper() {
    return _instance;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'todo_list.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE tarefas(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, dateTime TEXT)',
        );
      },
    );
  }

  Future<void> insertTarefa(Tarefa tarefa) async {
    final db = await database;
    await db.insert('tarefas', tarefa.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Tarefa>> getTarefas() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('tarefas');
    return List.generate(maps.length, (i) {
      return Tarefa(
        id: maps[i]['id'],
        title: maps[i]['title'],
        dateTime: DateTime.parse(maps[i]['dateTime']),
      );
    });
  }

  Future<void> deleteTarefa(int id) async {
    final db = await database;
    await db.delete('tarefas', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> clearTarefas() async {
    final db = await database;
    await db.delete('tarefas');
  }
}
