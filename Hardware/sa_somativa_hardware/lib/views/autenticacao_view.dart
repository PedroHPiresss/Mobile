import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sa_somativa_hardware/views/login_view.dart';
import 'package:sa_somativa_hardware/views/home_view.dart';

// Tela que direciona o usuário de acordo com o status de autenticação
class AutenticacaoView extends StatelessWidget {
  const AutenticacaoView({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>( //Classe User é modelo pronto do FireBaseAuth
      // A mudança de tela é determinada pela conexão do usuário ao firebaseAuth
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot){
        if(snapshot.hasData){ //Se o snapshot contém dados do usuário
          //direciona o usuário para a tela de tarefas
          return HomeView();
        }
        // Caso não haja dados do usuário
        // Direciona para tela de Login. Receba!
        return LoginView();
      });
  }
}