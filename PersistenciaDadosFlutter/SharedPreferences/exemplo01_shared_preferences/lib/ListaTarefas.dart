import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListaTarefas extends StatefulWidget{

  @override
  _ListaTarefasState createState() => _ListaTarefasState();
}

class _ListaTarefasState extends State<ListaTarefas>{
  //Lista de tarefas
  List<String> _tarefas = []; //armazenar as tarefas
  bool _darkMode = false;
  String _nome = ""; //Nome do Usuário

  //Controller para o TextField
  TextEditingController _tarefaController = TextEditingController();
  
  // Métodos
  @override
  void initState() {
    super.initState();
    _carregarPreferencias(); // método para carregar o SharedPreferences
  }
  // Método para carregar as preferências
  void _carregarPreferencias() async{
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    setState(() {
      _darkMode = _prefs.getBool("darkMode") ?? false;
      _nome = _prefs.getString("nome") ?? "";
      //pegar a lista de tarefas
      _tarefas = _prefs.getStringList("tarefas") ?? [];
    }); 
  }
  //método para adicionar tarefas
  void _adicionarTarefas() async{
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    if (_tarefaController.text.trim().isNotEmpty){
      setState(() {
        _tarefas.add(_tarefaController.text);
        _prefs.setStringList("tarefas", _tarefas);
        _tarefaController.clear();
      });
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Digite uma Tarefa"),));
    }
  }
  //método para remover tarefas
  void _removerTarefas(int index) async{
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    setState(() {
      _tarefas.removeAt(index);
      _prefs.setStringList("tarefas", _tarefas);
    });
  }
  //build do app
  @override
  Widget build(BuildContext context){
    return AnimatedTheme(
      data: _darkMode ? ThemeData.dark() : ThemeData.light(), // Operador Ternário
      duration: Duration(milliseconds: 500),
      child: Scaffold(
        appBar: AppBar(title: Text("Lista de Tarefas de ${_nome=="" ? "Visitante" : _nome}"),),
        body: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              TextField(
                controller: _tarefaController,
                decoration: InputDecoration(labelText: "Digite uma Tarefa"),
              ),
              SizedBox(height: 15,),
              ElevatedButton(
                child: Text("Enviar Tarefa"),
                onPressed: () => _adicionarTarefas(),),
              SizedBox(height: 15,),
              Expanded(
                child: ListView.builder(
                  itemCount: _tarefas.length,
                  itemBuilder:((context, index) {
                    ListTile(
                      title: Text(_tarefas[index]),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _removerTarefas(index)),
                    );
                    return null;
                  }), ))
            ],
          ),),
      ));
  }
}