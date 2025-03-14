import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // widget build
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Exemplo Widget Exibição")),
        body: Center(
          child: Column(
            children: [
              Text(
                "Um Texto Qualquer",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2
                ),),
                Image.network("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSHfvJQdTD8IFAUS4jNkFrVYGai1NknAbHAMA&s",
                width: 200,
                height: 200,
                fit: BoxFit.cover),
                Image.asset("assets/img/einstein.png",
                width: 200,
                height: 200,
                fit: BoxFit.cover),
                Icon(Icons.star,
                size: 100,
                color: Colors.amber),
            ],
          ),
        ),
      ),
    );
  }
}
