import 'package:sa_app_treino/models/rotina_model.dart';
import 'package:sa_app_treino/database/db_helper.dart';

class RotinasController {
  final AppTreinoDBHelper _dbHelper = AppTreinoDBHelper();

  Future<List<Rotina>> getRotinasByTreino(int treinoId) async {
    return await _dbHelper.getRotinaForTreino(treinoId);
  }

  Future<int> insertRotina(Rotina rotina) async {
    return await _dbHelper.insertRotina(rotina);
  }

  Future<int> deleteRotina(int id) async {
    return await _dbHelper.deleteRotina(id);
  }
}