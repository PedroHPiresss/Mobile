import 'package:exemplo_sqlite/nota_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class NotaDBHelper {
  //ATRIBUTOS
  static const String db_nome = "notas.db";
  static const String table_nome = "notas";
  static const String create_table =
      "CREATE TABLE IF NOT EXISTS notas(id INTEGER PRIMARY KEY AUTOINCREMENT, titulo TEXT, conteudo TEXT)";

  //métodos de conexão

  Future<Database> _getDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), db_nome),
      onCreate: (db, version) {
        return db.execute(create_table);
      },
      version: 1,
    );
  }

  //CRUD do banco de dados

  //create
  Future<void> create(Nota nota) async {
    try {
      final Database db = await _getDatabase();
      await db.insert(
        table_nome,
        nota.toMap(),
      ); //Insere o contato no Banco de Dados com Dados já traduzidos
    } catch (e) {
      print(e);
      return;
    }
  }

  //read
  Future<List<Nota>> getNotas() async {
    try {
      final Database db = await _getDatabase();
      //listar todasas notas pelo query
      final List<Map<String, dynamic>> maps = await db.query(table_nome);
      //converter essa lista em objetos
      return List.generate(maps.length, (i) => Nota.fromMap(maps[i]));
    } catch (e) {
      print(e);
      return [];
    }
  }

  //Atualizar Nota Existente
  Future<void> updateNota(Nota nota) async {
    try {
      final db = await _getDatabase();
      //Usar o update do sqflite
      await db.update(
        table_nome,
        nota.toMap(),
        where: "id = ?",
        whereArgs: [nota.id],
      );
    } catch (e) {
      print(e);
      return;
    }
  }

  //deletar Nota
  Future<void> deleteNota(int id) async{
    try {
      final Database db = await _getDatabase();
      await db.delete(table_nome, where: "id = ?", whereArgs: [id]);
    } catch (e) {
      print(e);
      return;
    }
  }
}
