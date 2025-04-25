//criar a classe da tela inicial

import 'package:flutter/material.dart';

class TelaInicialView extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Bem-Vindo!"), centerTitle: true,),
      body: Center(
        child: Column(
          children: [
            Text("Olá Visitante, Seja Bem-Vindo ao Nosso App!",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
            SizedBox(height: 20,),
            ElevatedButton(onPressed: ()=> Navigator.pushNamed(context, "/cadastro"),
                           child: Text("Cadastro"))
          ],
        ),
      )
    );
  }
}
