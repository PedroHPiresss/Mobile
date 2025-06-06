import 'package:intl/intl.dart';

class Rotina {
  final int? id;
  final int treinoId;
  final DateTime dataHora;
  final String tipoTreino;
  final String observacao;

  //construtor
  Rotina({
    this.id,
    required this.treinoId,
    required this.dataHora,
    required this.tipoTreino,
    required this.observacao
  });

  //Converter Map Obj => BD
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "treino_id": treinoId,
      "data_hora": dataHora.toIso8601String(),
      "tipo_treino": tipoTreino,
      "observacao": observacao
    };
  }

  //Converte Obj: BD => Obj
  factory Rotina.fromMap(Map<String, dynamic> map) {
    return Rotina(
      id: map["id"] as int,
      treinoId: map["treino_id"] as int,
      dataHora: DateTime.parse(map["data_hora"] as String),
      tipoTreino: map["tipo_treino"] as String,
      observacao: map["observacao"] as String,
    );
  }

  //Formatação de data e hora em formato regional
  String get dataHoraFormata {
    final formatter = DateFormat("dd/MM/yyyy HH:mm");
    return formatter.format(dataHora);
  }

  @override
  String toString() {
    return "Rotina{id: $id, treinoId: $treinoId, dataHora: $dataHora, tipoTreino: $tipoTreino, observacao: $observacao}";
  }
}