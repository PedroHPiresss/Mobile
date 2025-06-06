//tela de Detalhes do PET
import 'package:flutter/material.dart';
import 'package:sa_petshop/controllers/consultas_controller.dart';
import 'package:sa_petshop/controllers/pets_controller.dart';
import 'package:sa_petshop/models/consulta_model.dart';
import 'package:sa_petshop/models/pet_model.dart';
import 'package:sa_petshop/screens/add_consulta_screen.dart';

class PetDetalheScreen extends StatefulWidget {
  final int petId; //Receber o Id do Pet

  const PetDetalheScreen({
    super.key,
    required this.petId,
  }); //construtor para pegar o Id do PET

  @override
  State<StatefulWidget> createState() {
    return _PetDetalheScreenState();
  }
}

class _PetDetalheScreenState extends State<PetDetalheScreen> {
  //build  da Tela
  final PetsController _controllerPets = PetsController();
  final ConsultasController _controllerConsultas = ConsultasController();
  bool _isLoading = true;

  Pet? _pet; //inicialmente pode ser nulo

  List<Consulta> _consultas = []; // 

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadPetConsultas();
  }

  Future<void> _loadPetConsultas() async {
    setState(() {
      _isLoading = true;
    });
    try {
      _pet = await _controllerPets.findPetById(widget.petId);
      _consultas = await _controllerConsultas.getConsultasByPet(widget.petId);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Exception $e")));
    }finally{
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _deleteConsulta(int consultaId) async {
    try {
      await _controllerConsultas.deleteConsulta(consultaId);
      // Recarrega as consultas após a exclusão para atualizar a lista
      await _loadPetConsultas(); 
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Consulta deletada com sucesso!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao deletar consulta: $e")),
      );
    }
  }

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalhes do Pet"),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _pet == null // Verifica se o pet foi carregado
              ? const Center(child: Text("Erro ao carregar o Pet. Verifique o ID."))
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Nome: ${_pet!.nome}", style: const TextStyle(fontSize: 20)),
                      Text("Raça: ${_pet!.raca}"),
                      Text("Dono: ${_pet!.nomeDono}"),
                      Text("Telefone: ${_pet!.telefoneDono}"),
                      const Divider(),
                      const Text("Consultas:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      _consultas.isEmpty
                          ? const Center(child: Text("Não existem consultas cadastradas para este pet."))
                          : Expanded(
                              child: ListView.builder(
                                itemCount: _consultas.length,
                                itemBuilder: (context, index) {
                                  final consulta = _consultas[index];
                                  return Card( // Usando Card para um visual melhor
                                    margin: const EdgeInsets.symmetric(vertical: 4),
                                    child: ListTile(
                                      title: Text(consulta.tipoServico),
                                      subtitle: Text(consulta.dataHoraFormata),
                                      trailing: IconButton(
                                        onPressed: () => _deleteConsulta(consulta.id!),
                                        icon: const Icon(Icons.delete, color: Colors.red),
                                      ),
                                      // onTap: () {
                                      //   // Implementar navegação para detalhes da consulta, se necessário
                                      // },
                                    ),
                                  );
                                },
                              ),
                            ),
                    ],
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Aguarda o retorno da tela de adicionar consulta para recarregar as consultas
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddConsultaScreen(petId: widget.petId),
            ),
          );
          _loadPetConsultas(); // Recarrega as consultas quando voltar para esta tela
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}