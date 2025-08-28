import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  // base URL para Conexão com API
  static const String _baseURL = "http://10.109.197.11:3013";

  // métodos da classe e não do obj => instanciar obj
  //GET (Listar todos os Recurso)
  static Future<List<dynamic>> getList(String path) async{
    final res = await http.get(Uri.parse("$_baseURL/$path"));
    if (res.statusCode == 200) return json.decode(res.body); //se deu certo interrompe o código aqui
    // se não deu cert a conexão -> gerar um erro 
    throw Exception("Falha ao Carregar Lista de $path");
  }

  //GET (Listar um Unico Recurso)
  static Future<Map<String,dynamic>> getOne(String path, String id) async{
    final res = await http.get(Uri.parse("$_baseURL/$path/$id"));
    if (res.statusCode ==200) return json.decode(res.body);
    // se não der certo
   throw Exception("Falha ao Carregar Recurso de $path");
  }

  //POST ( Criar novo Recurso)
  static Future<Map<String,dynamic>> post(String path, Map<String,dynamic> body) async{
    final res = await http.post(
      Uri.parse("$_baseURL/$path"),
      headers: {"Content-Type": "applciation/json"},
      body: json.encode(body)
    );
    if (res.statusCode == 201) return json.decode(res.body);
    throw Exception("Falha ao Criar em $path");
  }

  //PUT (Atualizar Recurso)
  static Future<Map<String,dynamic>> put(String path, Map<String,dynamic> body, String id) async{
    final res = await http.put(
      Uri.parse("$_baseURL/$path/$id"),
      headers: {"Content-Type": "applciation/json"},
      body: json.encode(body)
    );
    if (res.statusCode == 201) return json.decode(res.body);
    throw Exception("Falha ao Atualizar em $path");
  }

  //DELETE (Apagar Recurso)
  static delete(String path, String id) async{
    final res = await http.delete(Uri.parse("$_baseURL/$path/$id"));
    if ( res.statusCode != 200) throw Exception("Falha ao Deletar de $path");
  }

}