import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sa_somativa_hardware/firebase_options.dart';
import 'package:sa_somativa_hardware/views/autenticacao_view.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  //inicializa o firebase - ao mesmo tempo que abre as telas 
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(MaterialApp(
    title: "Lista de Tarefas",
    home: AutenticacaoView(), //Direciona para a tela de autenticação
  ));
}