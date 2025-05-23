import 'package:sa_petshop/database/db_helper.dart';

import '../models/pet_model.dart';

class PetsController {
  //atributo -> é conexão com o banco de dados
  final PetShopDBHelper _dbHelper = PetShopDBHelper();


  Future<int> addPet(Pet pet) async {
    return await _dbHelper.insertPet(pet);
  }

  Future<List<Pet>> fetchPets() async {
    return await _dbHelper.getPets();
  }

  Future<Pet?> findPetById(int id) async {
    return await _dbHelper.getPetById(id);
  }

  Future<int> deletePet(int id) async {
    return await _dbHelper.deletePet(id);
  }
}