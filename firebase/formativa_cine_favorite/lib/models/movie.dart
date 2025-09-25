//classe modelo de filmes

class Movie {
  //atributos
  final int id; //Id do filme no TMDB
  final String title; //Titulo do Filme
  final String posterPath; //URL da imagem do pôster

  double rating; //nota que o usuário dará ao filme (de 0 a 5)

  //construtor
  Movie({
    required this.id,
    required this.title,
    required this.posterPath,
    this.rating = 0.0 
  });

  //converter de um OBJ para modelo de dados para o FireStore
  // toMap OBJ=> JSON
  Map<String,dynamic> toMap(){
    return {
      "id":id,
      "title":title,
      "posterPath":posterPath,
      "rating":rating
    };
  }

  //Criar um Obj a partir dos dados da API TMDB
  //fromMap Json => OBJ
  factory Movie.fromMap(Map<String,dynamic> map){
    return Movie(
      id: map["id"], 
      title: map["title"], 
      posterPath: map["posterPath"]);
  }
}