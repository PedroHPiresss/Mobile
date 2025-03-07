import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        // Barra de navegação superior
        appBar: AppBar(
          title: Text("Exemplo appBar"),
          backgroundColor: Colors.blue,
        ),
        // Corpo do aplicativo
        body: Center(
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center, // Alinha os elementos ao centro
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Container azul em cima
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(200),
                      color: Colors.blue,
                    ),
                  ),
                  CircleAvatar(
                    child: Image.asset(
                    'assets/img/image.png',
                    width: 150,
                    height: 150,
                    ),
                   ), //AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
                ],
              ),
              SizedBox(
                height: 20,
              ), // Adicionado um pequeno espaçamento entre o azul e os verdes
              // Containers verdes abaixo, mais próximos
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Centraliza os containers
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(color: Colors.green),
                      ),
                      Text(
                        "Container 1",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 10), // Menos espaçamento entre os containers
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(color: Colors.green),
                      ),
                      Text(
                        "Container 2",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 10), // Menos espaçamento entre os containers
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(color: Colors.green),
                      ),
                      Text(
                        "Container 3",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: "Buscar"),
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          ],
        ),
      ),
    );
  }
}
