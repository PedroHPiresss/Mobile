import 'package:biblioteca_app/models/book_model.dart';
import 'package:biblioteca_app/services/api_service.dart';

class BookControler {
  //obs: não precisa instaciar obj de ApiService (métodos static)

  //métodos
  // GET dos Livros
  Future<List<BookModel>> fetchAll() async{
    final list = await ApiService.getList("books?_sort=name"); //?_sort=name -> flag para organizar em order alfabetica
    //retorna a Lista de Livro Convertidas para Book Model List<dynamic> => List<OBJ>
    return list.map<BookModel>((item)=>BookModel.FromMap(item)).toList();
  }

  // POST -> Criar novo Livro
  Future<BookModel> create(BookModel u) async{
    final created  = await ApiService.post("books", u.toMap());
    // adiciona um Livro e Retorna o Livro Criado -> ID
    return BookModel.FromMap(created);
  }

  // GET -> Buscar um Livro
  Future<BookModel> fetchOne(String id) async{
    final book = await ApiService.getOne("books", id);
    // Retorna o Livro Encontrado no Banco de Dados
    return BookModel.FromMap(book);
  }

  // PUT -> Atualizar Livro
  Future<BookModel> update(BookModel u) async{
    final updated = await ApiService.put("books", u.toMap(), u.id!);
    //Retorna o Livro Atualizado
    return BookModel.FromMap(updated);
  }

  Future<void> delete(String id) async{
    await ApiService.delete("books", id);
    // Não há retorno, Livro deletado com sucesso
  }

}