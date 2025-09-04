import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:to_do_lis_firebase/firebase_options.dart';

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