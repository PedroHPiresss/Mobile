import 'package:flutter/material.dart';
import 'package:sa04_widget_navegacao/view/tela_cadastro_view.dart';
import 'package:sa04_widget_navegacao/view/tela_confirmacao_view.dart';
import 'package:sa04_widget_navegacao/view/tela_inicial_view.dart';

void main(){
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: "/",
    routes: { //3 Telas de Navegação do App
      "/": (context)=> TelaInicialView() /*Tela Inicial*/,
      "/cadastro":(context)=> TelaCadastroView()/*Tela de Cadastro*/,
      "/confirmacao":(context)=> TelaConfirmacaoView()/*Tela de Confirmação*/
    },
  ));
}

//Quando era uma unica tela -> continuava na Class