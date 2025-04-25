// classe TelaConfirmacao

import 'package:flutter/material.dart';

class TelaConfirmacaoView extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Final"),),
      body: Center(
        child: Column(
          children: [
            Text("Cadastro realizado com Sucesso"),
            SizedBox(height: 20,),
            IconButton(onPressed: () => Navigator.pushNamed(context, "/"),
                       icon: Icon(Icons.home, size: 50,))
          ],
        ),
      )
    );
  }
}
