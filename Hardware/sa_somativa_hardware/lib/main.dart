import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sa_somativa_hardware/firebase_options.dart';
import 'package:sa_somativa_hardware/views/autenticacao_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MaterialApp(
    title: "Sistema de Ponto",
    home: AutenticacaoView(),
  ));
}
