class Nota{
  //atributos
  final int? id; //permite que seja nula
  final String titulo;
  final String conteudo;

  //constructor
  Nota({this.id, required this.titulo, required this.conteudo});

  // métodos Map // Factory ==> tradução entre banco de dados e Objeto

  //converte um objeto da classe nota para um Map (para inserir no banco de dados)
  Map<String,dynamic> toMap(){
    return{
      "id":id, //id é null
      "titulo":titulo,
      "conteudo":conteudo
    };
  }

  //Converte um Map (vindo do banco de dados) => Objeto da Classe Nota
  factory Nota.fromMap(Map<String,dynamic> map){
    return Nota(
      id: map["id"] as int,
      titulo: map["titulo"] as String,
      conteudo: map["conteudo"] as String
    );
  }

  // método para imprimir os dados
  @override
  String toString() {
    return 'Nota{id: $id, título: $titulo, conteudo: $conteudo}';
  }



}