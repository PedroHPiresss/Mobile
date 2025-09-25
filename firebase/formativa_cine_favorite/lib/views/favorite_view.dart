import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:formativa_cine_favorite/controllers/firestore_controller.dart';
import 'package:formativa_cine_favorite/models/movie.dart';
import 'package:formativa_cine_favorite/views/search_movie_view.dart';

class FavoriteView extends StatefulWidget {
  const FavoriteView({super.key});

  @override
  State<FavoriteView> createState() => _FavoriteViewState();
}

class _FavoriteViewState extends State<FavoriteView> {
  final _firestoreController = FirestoreController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Filmes Favoritos"),
        actions: [
          IconButton(
            onPressed: FirebaseAuth.instance.signOut, 
            icon: Icon(Icons.logout))
        ],
      ),
      //Cria um gridView com os filmes favoritos
      body: StreamBuilder<List<Movie>>(
        stream: _firestoreController.getFavoriteMovies(),
        builder: (context, snapshot){
          if(snapshot.hasError){
            return Center(child: Text("Erro ao carregar lista de filmes"),);
          }
          if(!snapshot.hasData){
            return Center(child:CircularProgressIndicator());
          }
          if(snapshot.data!.isEmpty){
            return Center(child: Text("Nenhum filme adicionado aos favoritos"),);
          }
          final favoriteMovies = snapshot.data!;
          return GridView.builder(
            padding: EdgeInsets.all(8),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 0.7),
              itemCount: favoriteMovies.length,
            itemBuilder: (context, index){
              final movie = favoriteMovies[index];
              return Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Image.file(
                              File(movie.posterPath),
                              fit: BoxFit.cover,
                            ),
                          ),
                          // deletar o negocio
                          Positioned(
                            top: 4,
                            right: 4,
                            child: IconButton(
                              color: Colors.white,
                              icon: Icon(Icons.delete),
                              onPressed: () async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: Text('Remover favorito'),
                                    content: Text('Deseja remover "${movie.title}" dos favoritos?'),
                                    actions: [
                                      TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: Text('Cancelar')),
                                      TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: Text('Remover')),
                                    ],
                                  )
                                );
                                if(confirm == true){
                                  _firestoreController.removeFavoriteMovie(movie.id);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('"${movie.title}" removido dos favoritos')),
                                  );
                                }
                              },
                            ),
                          ),
                          // editar nota (estrela)
                          Positioned(
                            top: 4,
                            left: 4,
                            child: IconButton(
                              color: Colors.white,
                              icon: Icon(Icons.star),
                              onPressed: () async {
                                double newRating = movie.rating;
                                final result = await showDialog<double?>(
                                  context: context,
                                  builder: (ctx) => StatefulBuilder(
                                    builder: (ctx, setStateDialog) => AlertDialog(
                                      title: Text('Avaliar "${movie.title}"'),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text('Nota: ${newRating.toStringAsFixed(1)}'),
                                          Slider(
                                            min: 0,
                                            max: 5,
                                            divisions: 50,
                                            value: newRating.clamp(0.0, 5.0),
                                            onChanged: (v) => setStateDialog(() { newRating = v; }),
                                          ),
                                        ],
                                      ),
                                      actions: [
                                        TextButton(onPressed: () => Navigator.of(ctx).pop(null), child: Text('Cancelar')),
                                        TextButton(onPressed: () => Navigator.of(ctx).pop(newRating), child: Text('Salvar')),
                                      ],
                                    ),
                                  )
                                );
                                if(result != null){
                                  _firestoreController.updateMovieRating(movie.id, result);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Nota atualizada para ${result.toStringAsFixed(1)}')),
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      ),),
                      Padding(padding: EdgeInsets.all(8),
                      child: Text(movie.title),),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text("Nota: ${movie.rating.toStringAsFixed(2)}"))
                  ],
                ),
              );
            });
        }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.push(context,
          MaterialPageRoute(builder: (context) => SearchMovieView()))),
    );
  }
}