class Treino {
  final int? id;
  final String nome;
  final String objetivo;
  final int repeticoes;
  final int series;

  Treino({
    this.id,
    required this.nome,
    required this.objetivo,
    required this.repeticoes,
    required this.series
  });

  Map<String, dynamic> toMap() {
    return {
      "id":id,
      "nome":nome,
      "objetivo":objetivo,
      "repeticoes":repeticoes,
      "series":series
    };
  }

  factory Treino.fromMap(Map<String,dynamic> map) {
    return Treino(
      id:map["id"] as int,
      nome:map["nome"] as String,
      objetivo:map["objetivo"] as String,
      repeticoes:map["repeticoes"] as int,
      series:map["series"] as int
    );
  }

  @override
  String toString() {
    return "Treino{id: $id, nome: $nome, objetivo: $objetivo, repeticões: $repeticoes, series: $series}";
  }
}