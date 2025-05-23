class Pet {
  final int? id; //Permite valores nulos na criação do objeto - ID gerado pelo BD, pode ser null na criação do objeto
  final String nome;
  final String raca;
  final String nomeDono;
  final String telefoneDono;

  // Construtor da classe Pet - para instanciar um objeto Pet
  Pet({
    this.id,
    required this.nome,
    required this.raca,
    required this.nomeDono,
    required this.telefoneDono
  });

  // Converter um objeto Pet em um mapa - para facilitar a inserção no banco de dados
  //tabela não ordenada, é buscada por chave
  Map<String,dynamic> toMap() {
    return {
      "id":id,
      "nome":nome,
      "raca":raca,
      "nome_dono":nomeDono,
      "telefone_dono":telefoneDono
    };
  }

  //Criar um objeeto a partir de um Map (ler uma info do BD)
  factory Pet.fromMap(Map<String,dynamic> map) {
    return Pet(
      id:map["id"] as int,
      nome: map["nome"] as String,
      raca: map["raca"] as String,
      nomeDono: map["nome_dono"] as String,
      telefoneDono: map["telefone_dono"] as String);
  }

  @override
  String toString() {
    // TODO: implement toString
    return "Pet{id: $id, nome: $nome, raça: $raca, dono: $nomeDono, telefone: $telefoneDono}";
  }
}