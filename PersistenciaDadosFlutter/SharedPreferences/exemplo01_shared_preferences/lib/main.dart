import 'package:exemplo01_shared_preferences/listaTarefas.dart'; // Certifique-se de que o nome do arquivo está correto
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MaterialApp(
    home: MyApp(),
    theme: ThemeData(brightness: Brightness.light),
    darkTheme: ThemeData(brightness: Brightness.dark),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TextEditingController _nomeController = TextEditingController();
  String _nome = "";
  bool _darkMode = false;

  @override
  void initState() {
    super.initState();
    _carregarPreferencias();
  }

  void _carregarPreferencias() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    setState(() {
      _nome = _prefs.getString("nome") ?? "";
      _darkMode = _prefs.getBool("darkMode") ?? false;
    });
  }

  void _salvarNome() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    if (_nomeController.text.trim().isNotEmpty) {
      await _prefs.setString("nome", _nomeController.text);
      setState(() {
        _nome = _nomeController.text;
      });
      _nomeController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Digite um Nome Válido!")),
      );
    }
  }

  void _mudarDarkMode() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    setState(() {
      _darkMode = !_darkMode;
    });
    _prefs.setBool("darkMode", _darkMode);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedTheme(
      data: _darkMode ? ThemeData.dark() : ThemeData.light(),
      duration: Duration(milliseconds: 500),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Bem-Vindo ${_nome.isEmpty ? "Visitante" : _nome}"),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(_darkMode ? Icons.light_mode : Icons.dark_mode),
              onPressed: _mudarDarkMode,
            )
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _nomeController,
                decoration: InputDecoration(labelText: "Digite seu Nome"),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _salvarNome,
                child: Text("Entrar"),
              ),
              SizedBox(height: 15),
              ElevatedButton(
                child: Text("Ver Lista de Tarefas"),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ListaTarefas()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}