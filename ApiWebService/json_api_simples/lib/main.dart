import 'dart:convert';

import 'package:flutter/material.dart';
import "package:http/http.dart" as http;

void main(){
  runApp(MaterialApp(home: TarefasPage(),));
}

class TarefasPage extends StatefulWidget{
  //construtor
  const TarefasPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _TarefasPageState();
  }
}

class _TarefasPageState extends State<TarefasPage>{
  //atributos
  List<Map<String,dynamic>> tarefas = [];
  final TextEditingController _tarefaController = TextEditingController();
  //endereço da API (json-Server do Computador)
  final String baseUrl = "http://10.109.197.4:3013/tarefas";

  @override
  void initState() {
    super.initState();
    _carregarTarefas();
  }

  void _carregarTarefas() async{
    try {
      // fazer a conexão HTTP ( instalação da biblioteca http)
      // fazendo uma solicitação get para o endereço da API (converter Str -> URL)
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200){
        //decodificando para Map
        List<dynamic> dados = json.decode(response.body);
        setState(() {
          //tarefas = dados.map((item) => Map<String, dynamic>.from(item)).toList();
          tarefas = dados.cast<Map<String, dynamic>>();
        });
      }
    } catch (e) {
      print("Erro ao Adiconar Tarefa $e");
    }
  }

  void _removerTarefa(String id) async{
    try {
      //solicita http delete
      final response = await http.delete(Uri.parse("$baseUrl/$id"));
      if(response.statusCode == 200){
        _carregarTarefas();
      }
    } catch (e) {
      print("Erro ao Deletar Tarefa $e");
    }
  }

  void _adicionarTarefa(String titulo) async{
    try {
      final tarefa = {"titulo":titulo, "concluida": false};
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {"Content-type":"application/json"},
        body: json.encode(tarefa)
      );
      if (response.statusCode == 201){
        _tarefaController.clear();
        _carregarTarefas();
      }
    } catch (e) {
      print("Erro ao adicionar tarefa $e");
      
    }
  }

  //Update da Tarefa
  void _updateTarefa(String id, bool concluida) async{
    try {
      final tarefa = {"concluida":!concluida};
      final response = await http.patch(
        Uri.parse("$baseUrl/$id"),
        headers: {"Content-Type":"application/json"},
        body: json.encode(tarefa)
      );
      if (response.statusCode == 200)
        setState(() {
          _carregarTarefas();
        });
     
    } catch (e) {
      print("Erro ao atualizar Tarefa $e");
    }
  }


  //build da Tela
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tarefas via API"),),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _tarefaController,
              decoration: InputDecoration(
                labelText: "Nova Tarefa",
                border: OutlineInputBorder()),
              //envia a tarefa ao apertar enter
              onSubmitted: _adicionarTarefa,
            ),
            SizedBox(height: 12,),
            Divider(),
            Expanded(
              //operador ternário
              child: tarefas.isEmpty ?
              Center(child: Text("Nenhuma Tarefa"),) :
              ListView.builder(
                itemCount: tarefas.length,
                itemBuilder: (_,index){
                  final tarefa = tarefas[index];
                  return ListTile(
                    leading: Checkbox(
                      value: tarefa["concluida"], 
                      onChanged: (bool? value) => _updateTarefa(tarefa["id"], tarefa["concluida"])
                      ),
                    title: Text(tarefa["titulo"]),
                    subtitle: Text(tarefa["concluida"] ? "Concluída" : "Pendente"),
                    trailing: IconButton(
                      onPressed: () => _removerTarefa(tarefa["id"]), 
                      icon: Icon(Icons.delete)),
                  );
                })
            )
          ],
        ),
      ),
    );
  }
}