import 'dart:convert';
import 'dart:io'; //Biblioteca nativa do dart para manipulação de arquivos

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() => runApp(MaterialApp(home: ProdutoPage(),));

class ProdutoPage extends StatefulWidget{
  //construtor => super.key
   const ProdutoPage({super.key});

   @override
   State<StatefulWidget> createState() {
    return _ProdutoPageState();
   }
}

//Classe que vai construir a tela para as mudanças
class _ProdutoPageState extends State<ProdutoPage>{
  //atributos
  List<Map<String,dynamic>> produtos = [];
  final TextEditingController _nomeProdutoController = TextEditingController();
  final TextEditingController _valorProdutoController = TextEditingController();

  //Métodos
  //Método para carregar informações antes de construir a página
  @override
  void initState() {
    super.initState();
    _carregarProdutos();
  }

  //Método para retornar o arquivo interno do meu dispositivo
  Future<File> _getFile() async{
    //Busca a pasta de documentos do dispositivo
    final dir = await getApplicationDocumentsDirectory();
    return File("${dir.path}/produtos.json");
  }

  //Busco as informações e salvo na lista
  void _carregarProdutos() async{
    //Tratamento de erro
    try {
      final file = await _getFile();
      String conteudo = await file.readAsString();
      //Decodificar o texto/json para dart
      List<dynamic> dados = json.decode(conteudo);
      setState(() {
        produtos = dados.cast<Map<String,dynamic>>();
      });
    } catch (e) {
      setState(() {
        produtos = [];
      });
      print(e);
    }
  }

  //Salvar os produtos da lista para o json
  void _salvarProdutos() async{
    try {
      final file = await _getFile();
      String jsonProdutos = json.encode(produtos);
      await file.writeAsString(jsonProdutos);
    } catch (e) {
      print(e);
    }
  }

  //Método para adicionar produto na lista de produtos
  void _adicionarProduto() {
    String nome = _nomeProdutoController.text.trim();
    String valorStr = _valorProdutoController.text.trim();
    if(nome.isEmpty || valorStr.isEmpty) return; //Interrompe o método
    double? valor = double.tryParse(valorStr);
    if (valor ==null) return; //Se não conseguir converter interrompe o método
    final produto = {"nome": nome, "valor": valor};
    setState(() {
      //Adiciona o produto dentro do vetor
      produtos.add(produto);
    });
    _salvarProdutos();
    _nomeProdutoController.clear();
    _valorProdutoController.clear();
  }

  //Método para remover produto da lista de produtos
  void _removerProduto(int index){
    setState(() {
      produtos.removeAt(index);
    });
    _salvarProdutos();
  }

  //Build da tela
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cadastro de Produtos"),),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nomeProdutoController,
              decoration: InputDecoration(labelText: "Nome do Produto"),
            ),
            TextField(
              controller: _valorProdutoController,
              decoration: InputDecoration(labelText: "Valor (ex: 15.55)"),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            SizedBox(height: 10,),
            ElevatedButton(
              onPressed: _adicionarProduto,
              child: Text("Adicionar Produto")),
            Divider(),
            Expanded(
              //Operador Ternário (if/else encurtado)
              child: produtos.isEmpty ?
              Center(child: Text("Nenhum produto adicionado"),) :
              ListView.builder(
                itemCount: produtos.length,
                itemBuilder: (context, index){
                  final produto = produtos[index];
                  return ListTile(
                    title: Text(produto["nome"]),
                    subtitle: Text("R\$ ${produto["valor"]}"),
                    trailing: IconButton(
                      onPressed: () => _removerProduto(index),
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