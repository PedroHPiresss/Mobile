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

  //Criar um Obj a partir dos dados do firestore
  //fabricar um OBJ a partir de um JSON
  factory Movie.fromMap(Map<String,dynamic> map){
    double rating = 0.0;
    try {
      if (map.containsKey("rating") && map["rating"] != null) {
        final r = map["rating"];
        if (r is num) {
          rating = r.toDouble();
        } else if (r is String) {
          rating = double.tryParse(r) ?? 0.0;
        }
      }
    } catch (_) {
      rating = 0.0;
    }

    return Movie(
      id: map["id"], 
      title: map["title"], 
      posterPath: map["posterPath"],
      rating: rating,
    );
  }
}