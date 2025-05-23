import 'dart:io';

import 'package:path/path.dart';
import 'package:sa_petshop/models/consulta_model.dart';
import 'package:sa_petshop/models/pet_model.dart';
import 'package:sqflite/sqflite.dart';

class PetShopDBHelper{
  static Database? _database; // objeto para criar conexões

  Future<Database> get database async {
    if(_database != null){
      return _database!; //retorna o banco de dados já criado - se o banco de dados já existe, retorna ele mesmo
    }
    //se o banco de dados não existe, cria um novo
    _database = await _initDatabase(); //chama o método de inicialização do banco de dados
    return _database!; //retorna o banco de dados criado
  }

  Future<Database> _initDatabase() async {
    final _dbPath = await getDatabasesPath(); //pega o caminho do banco de dados
    final path = join(_dbPath,"petshop.db"); //cria o caminho do banco de dados
    
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async{
    //criar a tabela de PETS
    await db.execute(
      "CREATE TABLE pets(id INTEGER PRIMARY KEY AUTOINCREMENT, nome TEXT NOT NULL, raca TEXT NOT NULL, nome_dono TEXT NOT NULL, telefone_dono TEXT NOT NULL)", // cria a tabela de pets
    );

    // Criar a tabela de CONSULTAS
    await db.execute(
      "CREATE TABLE consultas(id INTEGER PRIMARY KEY AUTOINCREMENT, pet_id INTEGER NOT NULL, data_hora TEXT NOT NULL, tipo_servico TEXT NOT NULL, observacao TEXT, FOREIGN KEY(pet_id) REFERENCES pets(id) ON DELETE CASCADE)", // cria a tabela de consultas
    );
  }

  // Métodos CRUD para PETS
  Future<int> insertPet(Pet pet) async {
    final db = await database;
    return await db.insert("pets", pet.toMap()); // retorna o id do pet inserido
  }

  Future<List<Pet>> getPets() async {
    final db = await database;
    final List<Map<String,dynamic>> maps = await db.query("pets"); // busca todos os pets
    // converter em objetos
    return maps.map((e)=>Pet.fromMap(e)).toList();
    // adiciona elemento por elemnto na lista ja convertido em objeto
  }

  Future<Pet?> getPetById(int id) async {
    final db = await database;
    final List<Map<String,dynamic>> maps = await db.query( // Faz a busca no banco de dados
      "pets",where: "id = ?", whereArgs: [id]); // busca o pet pelo id solicitado
      // Se encontrado
    if(maps.isNotEmpty){
      return Pet.fromMap(maps.first); // retorna o primeiro elemento da lista
    }else{
      null; // se não encontrado, retorna null
    }
  }

  Future<int> deletePet(int id) async {
    final db = await database;
    return await db.delete("pets", where: "id = ?", whereArgs: [id]); // deleta o pet da tabela pelo id
  }

  // Métodos CRUDs para CONSULTAS

  Future<int> insertConsulta (Consulta consulta) async {
    final db = await database;
    // insere a consulta no banco de dados
    return await db.insert("consultas", consulta.toMap()); // retorna o id da consulta inserida
  }

  Future<List<Consulta>> getConsultaForPet(int petId) async {
    final db = await database;
    //Consulta por pet especifico
    final List<Map<String,dynamic>> maps = await db.query(
      "consultas",
      where: "pet_id = ?",
      whereArgs: [petId],
      orderBy: "data_hora ASC" // ordena por data e hora
    );
    // converter a map para objeto
    return maps.map((e)=>Consulta.fromMap(e)).toList();
  }

  Future<int> deleteConsulta(int id) async {
    final db = await database;
    // deleta a consulta pelo id
    return await db.delete("consultas", where: "id = ?", whereArgs: [id]);
  }
}