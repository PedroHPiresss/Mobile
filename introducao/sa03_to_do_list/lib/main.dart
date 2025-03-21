import 'package:flutter/material.dart';

void main(){
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ListaTarefas()
  ));
}

class ListaTarefas extends StatefulWidget{ //chamar as mudanças de estrutura
  @override
  _ListaTarefasState createState() => _ListaTarefasState();
}

class _ListaTarefasState extends State<ListaTarefas>{ //construtora
  //atributo
  final TextEditingController _tarefaController = TextEditingController();
  final List<Map<String,dynamic>> _tarefas = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Lista de Tarefas"),),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _tarefaController, //receber as informações do usuário
              decoration: InputDecoration(labelText: "Digite uma Tarefa"),
            ),
            SizedBox(height: 10,),
            ElevatedButton(onPressed: _adicionarTarefa, child: Text("Adicionar Tarefa")),
            Expanded(
              child: ListView.builder(
                itemCount: _tarefas.length,
                itemBuilder: (context,index) => ListTile(
                  title: Text(_tarefas[index]["titulo"],
                            style: TextStyle(
                              //uso do perador ternário para marcar a tarefa como concluída ou não
                              // (condição) ? caso verdadeiro : caso falso
                              decoration: _tarefas[index]["concluida"]?TextDecoration.lineThrough:null,
                            ),),
                  leading: Checkbox(
                    value: _tarefas[index]["concluida"],
                    onChanged: (bool ? valor)=> setState(() { //envia a mudança de estado para a classe
                      _tarefas[index]["concluida"] = valor!;
        
                    })),
                ))),
          ],
        ),
      ),
    floatingActionButton: FloatingActionButton(
      onPressed: _removerTarefasConcluidas,
      child: Icon(Icons.recycling),),
    );
  }//fim do build

  //Método para adicionar tarefa
  void _adicionarTarefa(){
    if(_tarefaController.text.trim().isNotEmpty){
      setState(() {
        _tarefas.add({"titulo":_tarefaController.text,
                      "concluida":false});
        _tarefaController.clear();
      });
    }
  }


  void _removerTarefasConcluidas() {
    setState(() {
      //pega todas as tarefas concluidas do list
      _tarefas.removeWhere((tarefa)=>tarefa['concluida']);
    });
  }
}//fim da classe 