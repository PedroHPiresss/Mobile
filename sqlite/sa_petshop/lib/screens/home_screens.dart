import 'package:flutter/material.dart';
import 'package:sa_petshop/controllers/pets_controller.dart';
import 'package:sa_petshop/screens/add_pet_screen.dart';

import '../models/pet_model.dart' show Pet;

class HomeScreens extends StatefulWidget{
  @override
  State<HomeScreens> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreens> {
  // Instância do controlador de pets
  final PetsController _petsController = PetsController();

  List<Pet> _pets = [];
  bool _isLoading = true; //enquanto carrega o banco de dados, mostra o loading
  
  @override
  void initState() {
    super.initState();
    _loadPets();
  }

  Future<void> _loadPets() async {
    setState(() {
      _isLoading = true; // enquanto carrega o banco de dados, mostra o loading
    });
    try {
        _pets = await _petsController.fetchPets();
    } catch (erro) { // Pega o erro do sistema 
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Exeption: $erro")));
    } finally { // Execução obrigatória
      setState(() {
        _isLoading = false; // quando terminar de carregar o banco de dados, tira o loading
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text ("Meus Pets")),
      body: _isLoading ? Center(child: CircularProgressIndicator()) : ListView.builder(
        itemCount: _pets.length,
        itemBuilder: (context,index) {
          final pet = _pets[index];
          return ListTile(
            title: Text(pet.nome),
            subtitle: Text(pet.raca),
            onTap: () async {
              // Navega para a tela de detalhes do pet
            },
          );
        }),
      floatingActionButton: FloatingActionButton(
        tooltip: "Adicionar Novo Pet",
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(
            builder: (context) => AddPetScreen(), //Pagina de cadastro de pet
          ));
        },
        child: Icon(Icons.add),
        ),
    );
  }

}