import 'package:exemplo_sqlite/nota_dbhelper.dart';
import 'package:exemplo_sqlite/nota_model.dart';
import 'package:flutter/material.dart';

class NotaView extends StatefulWidget{
  @override
  _NotasViewState createState()=> _NotasViewState();
}

class _NotasViewState extends State<NotaView>{
  //instanciar o helper
  final NotaDBHelper _dbHelper = NotaDBHelper();
  //Lista com Notas
  List<Nota> _notes=[];
  bool _isLoading = true; //carregar um indicador de conexão com o database

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadNotas();
  }

  Future<void> _loadNotas() async{
    setState(() {
      _isLoading = true;
    });
    //chamar o método getNotas
    _notes = [];
    _notes = await _dbHelper.getNotas();
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _addNotas() async{
    Nota novaNota = Nota(titulo: "Nota ${DateTime.now()}", conteudo: "Conteúdo da Nota");
    await _dbHelper.create(novaNota);
    _loadNotas();
  }

  void _deleteNote(int id) async{
    await _dbHelper.deleteNota(id);
    _loadNotas();
  }

  void _updateNota(Nota nota) async{
    Nota notaAtualizada = Nota(id: nota.id, titulo: "${nota.titulo} (editado)", conteudo: nota.conteudo);
    await _dbHelper.updateNota(notaAtualizada);
    //criar um alerDialog para mudar o conteúdo
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Atualizar Nota"),
        content: TextField(
          controller: TextEditingController(text: nota.conteudo),
          onChanged: (value) {
            notaAtualizada = Nota(id: nota.id, titulo: nota.titulo, conteudo: value);
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _dbHelper.updateNota(notaAtualizada);
              _loadNotas();
            },
            child: Text("Atualizar"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text("Minhas Notas"),),
      body: _isLoading ? Center( child: CircularProgressIndicator()) : ListView.builder(
        itemCount: _notes.length,
        itemBuilder: (context, index){
          final nota = _notes[index];
          return ListTile(
            title: Text(nota.titulo),
            subtitle: Text(nota.conteudo),
            trailing: IconButton(
              onPressed: () => _deleteNote(nota.id!),
              icon: Icon(Icons.delete),
            ),
            onTap: () => _updateNota(nota),
          );
        }
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _addNotas,
          tooltip: "Adicionar Nota",
          child: Icon(Icons.add),),
    );
  }
  
}