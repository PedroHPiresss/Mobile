//gerenciar o relacionamento do aplicativo com o FireStore DataBase

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:formativa_cine_favorite/models/movie.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class FirestoreController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  
  //método para pegar o usuário atual
  User? get currentUser => _auth.currentUser;

  //vamos criar um listener => pegar a lista de filmes favoritos
  Stream<List<Movie>> getFavoriteMovies(){ // lista salva no FireBase 
  //não é a lista da API
  //se usuário == nul, retorna uma list vazia
    if(currentUser == null) return Stream.value([]);

    return _db
    .collection("users")
    .doc(currentUser!.uid)
    .collection("favorite_movies")
    .snapshots() // memora instantanea do aplicativo
    .map((snapshot)=>
    //converte cada doc do BD em OBJ da classe Movie
      snapshot.docs.map((doc)=>Movie.fromMap(doc.data())).toList());
  }

  //adicionar um filme a lista de favoritos
  void addFavoriteMovie(Map<String,dynamic> movieData) async{
    //carregar imagem diretamente do cache do aplicativo 
    if(movieData["poster_path"] == null || currentUser == null) return; // se filme não tiver o poste não armazena

    //baixando a imagem do Poster do Filme
    final imagemUrl = "https://image.tmdb.org/t/p/w500${movieData["poster_path"]}";
    final responseImg = await http.get(Uri.parse(imagemUrl));

    //armazenar a imagem no cache do aplicativo
    final tempDir = await getApplicationDocumentsDirectory(); //armazenar imagem no aplicativo
    final file = File("${tempDir.path}/${movieData["id"]}.jpg");
    await file.writeAsBytes(responseImg.bodyBytes);

    //criar o filme
    final movie = Movie(
      id: movieData["id"],
      title: movieData["title"],
      posterPath: file.path.toString());

    //armazenar no firestore
    await _db.collection("users").doc(currentUser!.uid)
    .collection("favorite_movies").doc(movie.id.toString()).set(movie.toMap());
    //doc é criado com o id = ao do TMDB
  }

  //removeFavoriteMovie
  void removeFavoriteMovie(int movieId) async{
    if(currentUser == null) return;

    // aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
    await _db.collection("users").doc(currentUser!.uid)
    .collection("favorite_movies").doc(movieId.toString()).delete();
    //deleta o doc da base de dados

    //deletar a imagem do diretório
    final imagemPath = await getApplicationDocumentsDirectory();
    final imagemFile = File("${imagemPath.path}/$movieId.jpg");
    try {
      await imagemFile.delete();
    } catch (e) {
      print("Erro ao deletar imagem $e");
    }
  }

  //Update movie rating
  void updateMovieRating( int movieId, double rating) async{
    if(currentUser ==null) return;

    await _db.collection("users").doc(currentUser!.uid)
    .collection("favorite_movies")
    .doc(movieId.toString()).update({"rating":rating});
  }
    
}