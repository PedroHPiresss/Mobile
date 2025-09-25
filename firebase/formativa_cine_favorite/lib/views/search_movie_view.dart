// Tela de busca de filmes

import 'package:flutter/material.dart';
import 'package:formativa_cine_favorite/controllers/firestore_controller.dart';
import 'package:formativa_cine_favorite/controllers/tmdb_controller.dart';



class SearchMovieView extends StatefulWidget {
  const SearchMovieView({super.key});

  @override
  State<SearchMovieView> createState() => _SearchMovieViewState();
}

class _SearchMovieViewState extends State<SearchMovieView> {
  //atributos
  final _firestoreController = FirestoreController();
  final _searchField = TextEditingController();

  List<Map<String,dynamic>> _searchResults = [];
  bool _isLoading = false;

  void _searchMovies() async{
    final query = _searchField.text.trim();
    if(query.isEmpty) return; //para o método
    setState(() {
      _isLoading = true;
    });
    try { // tenta conectar com a API
    // armazena o resultado da busca
      final resultado = await TmdbController.searchMovies(query);
      setState(() {
        // passo o resultado para a lista 
        _searchResults = resultado;
        _isLoading = false;
      });

    } catch (e) {
      setState(() {
        _isLoading = false;
        _searchResults = [];
      });
      // mostrar um aviso de erro
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao buscar filmes: $e"))
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Buscar Filme'),),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _searchField,
              decoration: InputDecoration(
                labelText: "Nome do Filme",
                border: OutlineInputBorder(),
                suffix: IconButton(
                  onPressed: _searchMovies,
                  icon: Icon(Icons.search))
              ),
            ),
            SizedBox(height: 10,),
            // Operador ternário
            _isLoading ? CircularProgressIndicator()
            : _searchResults.isEmpty ? Text("Nenhum filem encontrado")
            : Expanded(
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index){
                  final movie = _searchResults[index];
                  return ListTile(
                    //exibir lista de filmes
                    title: Text(movie["title"]),
                    subtitle: Text(movie["release_date"]),
                    trailing: IconButton(
                      onPressed: ()async{
                        //adicionar a coleção de filmes favoritos
                        _firestoreController.addFavoriteMovie(movie);
                        //mostrar um aviso
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("${movie["title"]} adicionado aos favoritos"))
                        );
                        Navigator.pop(context); //volto para a tela de favoritos
                      },
                      icon: Icon(Icons.add)),
                  );
                }))
          ],
        ),),
    );
  }
}