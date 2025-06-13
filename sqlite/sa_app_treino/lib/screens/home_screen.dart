import 'package:flutter/material.dart';
import 'package:sa_app_treino/controllers/treinos_controller.dart';
import 'package:sa_app_treino/models/treino_model.dart';
import 'package:sa_app_treino/screens/add_treino_screen.dart';
import 'package:sa_app_treino/screens/rotina_detalhe_screen.dart';

class HomeScreen extends StatefulWidget {
  // controla a mudança de state
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TreinosController _treinosController = TreinosController();

  List<Treino> _treinos = [];
  bool _isLoading = true; // enquanto carrega o banco

  @override
  void initState() {
    super.initState();
    _loadTreinos();
  }

  Future<void> _loadTreinos() async {
    setState(() {
      _isLoading = true;
      _treinos = [];
    });
    try {
      _treinos = await _treinosController.fetchTreinos();
    } catch (erro) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Erro: $erro")));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Meus Treinos")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _treinos.length,
              itemBuilder: (context, index) {
                final treino = _treinos[index];
                return ListTile(
                  title: Text(treino.nome),
                  subtitle: Text(treino.objetivo),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RotinaDetalheScreen(treinoId: treino.id!),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Adicionar Novo Treino",
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTreinoScreen()),
          );
          _loadTreinos(); // Recarrega a lista após voltar da tela de adicionar
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
