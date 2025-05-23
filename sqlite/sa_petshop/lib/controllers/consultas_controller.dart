import 'package:sa_petshop/models/consulta_model.dart';
import 'package:sa_petshop/database/db_helper.dart';

class ConsultasController {
  final PetShopDBHelper _dbHelper = PetShopDBHelper();

  Future<List<Consulta>> getConsultasByPet(int petId) async {
    return await _dbHelper.getConsultaForPet(petId);
  }

  Future<int> insertConsulta(Consulta consulta) async {
    return await _dbHelper.insertConsulta(consulta);
  }

  Future<int> deleteConsulta(int id) async {
    return await _dbHelper.deleteConsulta(id);
  }
}