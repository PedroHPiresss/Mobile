import 'package:flutter/material.dart';
import 'package:json_shared_preferences/config_page.dart';
//Biblioteca instalada no pubspec (flutter pub add nome_da_biblioteca)
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';


void main(){
  runApp(MyApp());
}

class MyApp extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp>{
  //atributos
  bool temaEscuro = false;
  String nomeUsuario = "";

  //Para carregar informações no começo da aplicação
  @override
  void initState() {
    super.initState();
    carregarPreferencias();
  }

  //Métodos async -> não travar a aplicação enquanto carregam as informações de uma base de dados
  void carregarPreferencias() async {
    //Conexão com o cache para pegar informações armazenadas pelo usuário
    final prefs = await SharedPreferences.getInstance();
    //Armazenando em um texto as configurações salvas
    String? jsonString = prefs.getString('config');
    if (jsonString != null){
      //Converter o texto/Json em Map/Dart
      Map<String,dynamic> config = json.decode(jsonString);
      //Chama a mudança de estado
      setState(() {
        //Atribui a bool o valor da chave temaEscuro, caso null atribui falso
        temaEscuro = config["temaEscuro"] ?? false;
        nomeUsuario = config["nome"] ?? "";
      });
    }
  }//Fim do método

  //Método build
  @override
  Widget build(BuildContext context) {
    return(MaterialApp(
      title: "App de Configuração",
      //Operador Ternário (if else encurtado)
      theme: temaEscuro ? ThemeData.dark() : ThemeData.light(),
      home: ConfigPage(
        temaEscuro: temaEscuro,
        nomeUsuario: nomeUsuario,
        onSalvar: (bool novoTema, String novoNome){
          setState(() {
            temaEscuro = novoTema;
            nomeUsuario = novoNome;
          });
        }
      ),
    ));
  }
}
