import 'package:biblioteca_app/controllers/book_controler.dart';
import 'package:biblioteca_app/models/book_model.dart';
import 'package:biblioteca_app/views/book/book_list_view.dart';
import 'package:flutter/material.dart';

class BookFormView extends StatefulWidget {
  //atributo
  final BookModel? book; //Pode ser nulo

  const BookFormView({super.key, this.book});

  @override
  State<BookFormView> createState() => _BookFormViewState();
}

class _BookFormViewState extends State<BookFormView> {
  //atributos
  final _formkey = GlobalKey<FormState>(); //Armazenar as informações do form
  final _controller = BookControler();
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();

  @override
  void initState() {
    super.initState();
    //Se for edição de usuário existente
    if(widget.book !=null){
    _titleController.text = widget.book!.title;
    _authorController.text = widget.book!.author;
    }
  }

  void _save() async{
    if(_formkey.currentState!.validate()){
      final book = BookModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text,
        author: _authorController.text,
        avaliable: true // Ajustar aqui depois ó !!!!!!!!!!!!!!!!!!!!!!!
      );
      await _controller.create(book);
      Navigator.pop(context);
      Navigator.pushReplacement(context,
      MaterialPageRoute(builder: (context)=> BookListView()));
    }
  }

  void _update() async{
    if(_formkey.currentState!.validate()){
      final book = BookModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text,
        author: _authorController.text,
        avaliable: true
      );
      await _controller.update(book);
      Navigator.pop(context);
      Navigator.pushReplacement(context,
      MaterialPageRoute(builder: (context)=> BookListView()));
    }
  }

  //build da tela
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(
        widget.book == null ? "Novo Livro" : "Editar Livro"
      ),),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formkey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: "Titulo"),
                validator: (value) => value!.isEmpty? "Informe o titulo": null,
              ),
              TextFormField(
                controller: _authorController,
                decoration: InputDecoration(labelText: "Autor"),
                validator: (value) => value!.isEmpty? "Informe o autor": null,
              ),
              SizedBox(height: 20,),
              ElevatedButton(
                onPressed: widget.book == null ? _save : _update,
                child: Text(widget.book == null ? "Salvar" : "Atualizar"))
            ],
          )),),
    );
  }
}