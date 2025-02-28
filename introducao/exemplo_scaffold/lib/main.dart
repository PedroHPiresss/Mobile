//void main
import 'package:flutter/material.dart';

void main(){
    runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        //estudo do scaffold
        home: Scaffold(
            //Barra de navegação superior
            appBar: AppBar(
                title: Text("Exemplo appBar"),
                backgroundColor: Colors.blue,
            ),
            //Corpo do aplicativo
            body: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                    Icon(Icons.person),
                    Text("Coluna 2"),
                    Text("Coluna 3")],
                ),
                    Icon(Icons.person),
                    Text("Linha 3"),
                ],
            ),
            
            //Barra lateral (menu hamburguer)
            drawer: Drawer(
                child: ListView(
                    children: [
                        Text("Iníco"),
                        Text("Conteúdo"),
                        Text("Contato"),
                    ],
                )
            ),
            //Barra de navegação inferior
            bottomNavigationBar: BottomNavigationBar(items: [
                BottomNavigationBarItem(icon: Icon(Icons.home),label: "home"),
                BottomNavigationBarItem(icon: Icon(Icons.search),label: "Pesquisa"),
                BottomNavigationBarItem(icon: Icon(Icons.person),label: "Usuario"),
            ],
            ),
            //Botão flutuante
            floatingActionButton: FloatingActionButton(onPressed: (){
                print("Botão Clicado");
            },
            child: Icon(Icons.add),
            ),
        ),
    );
  }   
}