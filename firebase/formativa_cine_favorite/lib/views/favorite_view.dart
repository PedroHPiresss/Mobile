import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FavoriteView extends StatefulWidget {
  const FavoriteView({super.key});

  @override
  State<FavoriteView> createState() => _FavoriteViewState();
}

class _FavoriteViewState extends State<FavoriteView> {
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
    );
  }
}