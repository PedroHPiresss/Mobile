import 'package:sa_app_treino/database/db_helper.dart';
import 'package:sa_app_treino/models/treino_model.dart';

class TreinosController {
  final AppTreinoDBHelper _dbHelper = AppTreinoDBHelper();


  Future<int> addTreino(Treino treino) async {
    return await _dbHelper.insertTreino(treino);
  }

  Future<List<Treino>> fetchTreinos() async {
    return await _dbHelper.getTreinos();
  }

  Future<Treino?> findTreinoById(int id) async {
    return await _dbHelper.getTreinoById(id);
  }

  Future<int> deleteTreino(int id) async {
    return await _dbHelper.deleteTreino(id);
  }
}