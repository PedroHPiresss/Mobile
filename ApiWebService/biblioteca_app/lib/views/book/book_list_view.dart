import 'package:biblioteca_app/views/book/book_form_view.dart';
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
  List<BookModel> _filteredBooks = [];
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _load(); //carregar informações iniciais de books
  }

  void _load() async {
    setState(() => _loading = true);
    try {
      _books = await _controller.fetchAll();
      _filteredBooks = _books;
    } catch (e) {
      print(e);
    }
    setState(() => _loading = false);
  }

  //Método para criar uma lista de livros filtradas pelas letras que forem digitadas na barra de pesquisa
  void _booksFilter() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredBooks = _books.where((book) {
        return book.title.toLowerCase().contains(query) ||
            book.author.toLowerCase().contains(query);
      }).toList();
    });
  }


  void _openForm({BookModel? book}) async{
    await Navigator.push(context,
    MaterialPageRoute(builder: (context)=> BookFormView(book: book)));
    _load();
  }




  //build da tela
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Não precisa de Appbar -> já tem a appbar da homeview
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(labelText: "Pesquisar Livro",
                     border: OutlineInputBorder()),
                    onChanged: (value) => _booksFilter(),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _filteredBooks.length,
                      itemBuilder: (context, index) {
                        final book = _filteredBooks[index];
                        return Card(
                          child: ListTile(
                            title: Text(book.title),
                            subtitle: Text(book.author),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: onPressed,
                                  icon: icon) 
                          //      IconButton(
                          //        onPressed: () => _openForm(book:book),
                             //     icon: Icon(Icons.edit)),
                                IconButton(
                                  onPressed: ()=> _delete(book),
                                  icon: Icon(Icons.delete, color: Colors.red,))
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _openForm(),
            child: Icon(Icons.add),),
    );
  }
  
  void _delete(BookModel book) async {
    if(book.id == null) return;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context)=> AlertDialog(
        title: Text("Confirmar Exclusão"),
        content: Text("Deseja realmente excluir o livro ${book.title}?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text("Cancelar")),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text("Excluir")),

        ],
      ));

      if(confirm == true){
        try {
          await _controller.delete(book.id!);
          _load();
        } catch (e) {
          print(e);
        }
      }
  }
}