import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:formativa_cine_favorite/views/favorite_view.dart';
import 'package:formativa_cine_favorite/views/login_view.dart';

void main() async{ // Async -> Conect com FireBase
  // garanto o carregamento dos widgets antes de conectar com o firebase
  WidgetsFlutterBinding.ensureInitialized();
  //conexão com o Firebase
  await Firebase.initializeApp();
  //montagem das Caracteristicas do APP
  runApp(MaterialApp(
    title: "CineFavorite",
    theme: ThemeData(
      primarySwatch: Colors.deepOrange,
      brightness: Brightness.dark
    ),
    home: AuthStream(),
  ));
}

//Listerner para Direcioanr a Navegação da Tela Inicial
class AuthStream extends StatelessWidget {
  const AuthStream({super.key});

  @override
  Widget build(BuildContext context) {
    // verifica se o usuário já esta logado ou não
    return StreamBuilder<User?>(
      // o listener esta na mudança de status do usuário
      stream: FirebaseAuth.instance.authStateChanges(), 
      builder: (context,snapshot){
        //se estiver logado , vai para HomeScreen(Tela FAvorito)
        if(snapshot.hasData){
          return FavoriteView();
        }
        //se não tiver logado
        return LoginView();
      });
  }
}