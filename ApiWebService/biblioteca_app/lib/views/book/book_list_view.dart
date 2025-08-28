import 'package:flutter/material.dart';
import 'package:biblioteca_app/controllers/book_controler.dart';
import 'package:biblioteca_app/models/book_model.dart';

class BookListView extends StatefulWidget {
  const BookListView({super.key});

  @override
  State<BookListView> createState() => _BookListViewState();
}

class _BookListViewState extends State<BookListView> {
  //atributos
  final _controller = BookControler();
  List<BookModel> _books = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load(); //carregar informações iniciais de books
  }

  void _load() async{
    setState(() => _loading = true);
      try {
        _books = await _controller.fetchAll();
      } catch (e) {
        print(e);
      }
      setState(() => _loading = false);
    }


  //build da tela 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Não precisa de Appbar -> já tem a appbar da homeview
      body: _loading
      ? Center(child: CircularProgressIndicator(),)
      : Padding(
        padding: EdgeInsets.all(16),
        child: Expanded(
          child:ListView.builder(
            itemCount: _books.length,
            itemBuilder: (context,index){
              final book = _books[index];
              return Card(
                child: ListTile(
                  title: Text(book.title),
                  subtitle: Text(book.author),
                ),
              );
            }) ),)
    );
  }
}