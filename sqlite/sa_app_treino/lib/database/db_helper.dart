import 'package:flutter/widgets.dart';
import 'package:sa_app_treino/models/rotina_model.dart';
import 'package:sa_app_treino/models/treino_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';

class AppTreinoDBHelper {
  static Database? _database;

  static final AppTreinoDBHelper _instance = AppTreinoDBHelper._internal();

  AppTreinoDBHelper._internal();
  factory AppTreinoDBHelper() {
    return _instance;
  }

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final _dbPath = await getDatabasesPath();
    final path = join(_dbPath, "apptreino.db");

    return await openDatabase(path, version: 1, onCreate: _onCreateDB);
  }

  Future<void> _onCreateDB(Database db, int version) async {
    //Cria tabela treino
    await db.execute('''
      CREATE TABLE IF NOT EXISTS treinos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        objetivo TEXT NOT NULL,
        repeticoes INTEGER NOT NULL,
        series INTEGER NOT NULL
      )
    ''');
    print("banco treino criado");

    //Cria tabela rotina
    await db.execute('''
      CREATE TABLE IF NOT EXISTS rotinas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        treino_id INTEGER NOT NULL,
        data_hora TEXT NOT NULL,
        tipo_treino TEXT NOT NULL,
        observacao TEXT NOT NULL,
        FOREIGN KEY (treino_id) REFERENCES treinos(id) ON DELETE CASCADE
      )
    ''');
    print("banco rotina criado");
  }

  Future<int> insertTreino(Treino treino) async {
    final db = await database;
    return await db.insert("treinos", treino.toMap());
  }

  Future<List<Treino>> getTreinos() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      "treinos",
    );
    return maps.map((e) => Treino.fromMap(e)).toList();
  }

  Future<Treino?> getTreinoById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      "treinos",
      where: "id=?",
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Treino.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> deleteTreino(int id) async {
    final db = await database;
    return await db.delete("treinos", where: "id=?", whereArgs: [id]);
  }

  //Métodos CRUDs para rotinas

  Future<int> insertRotina(Rotina rotina) async {
    final db = await database;
    return await db.insert("rotinas", rotina.toMap());
  }

  Future<List<Rotina>> getRotinaForTreino(int treinoId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      "rotinas",
      where: "treino_id = ?",
      whereArgs: [treinoId],
      orderBy: "data_hora ASC"
    );

    return maps.map((e) => Rotina.fromMap(e)).toList();
  }

  Future<int> deleteRotina(int id) async {
    final db = await database;
    return await db.delete("rotinas", where: "id = ?", whereArgs: [id]);
  }
}