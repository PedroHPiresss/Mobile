//classe responsavel per buscar as informações no TMDB e converter em OBJ
// serviço de conexão com a API

import 'dart:convert';

import 'package:http/http.dart' as http;

class TmdbController {
  //Colocar os dados da API
  static const String _apiKey = "1fa5c2d59029fd1c438cc35713720604";
  static const String _baseURL = "https://api.themoviedb.org/3";
  // static -> atributo da classe e não do OBJ


  //método para buscar filme com base no texto
  // static -> método executado pela classe e não pelo OBJ
  static Future<List<Map<String,dynamic>>> searchMovies(String query) async{
    //convert String em URL
    final queryUrl = Uri.parse("$_baseURL/search/movie?api_key=$_apiKey&query=$query&language=pt-BR");
    //http.get(baseURL)
    final response = await http.get(queryUrl);
    
    //se reposta form ok ==200
    if(response.statusCode == 200){
      //convert json => string (dart)
      final data = json.decode(response.body);
      // retorna converte string em List<Map<String,dynamic>>
      return List<Map<String,dynamic>>.from(data["results"]);
    }else{
    //caso contrário cria uma exception
      throw Exception("Falha ao Carregar filmes da API");
    }
  }

}
