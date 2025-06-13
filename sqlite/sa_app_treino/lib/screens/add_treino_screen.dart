import 'package:flutter/material.dart';
import 'package:sa_app_treino/controllers/treinos_controller.dart';
import 'package:sa_app_treino/models/treino_model.dart';
import 'package:sa_app_treino/screens/home_screen.dart';

class AddTreinoScreen extends StatefulWidget {
  @override
  State<AddTreinoScreen> createState() => _AddTreinoScreenState();
}

class _AddTreinoScreenState extends State<AddTreinoScreen> {
  final _formKey = GlobalKey<FormState>(); // chave para o formulário
  final _treinosController = TreinosController();

  late String _nome = "";
  late String _objetivo = "";
  int? _repeticoes;
  int? _series;

  Future<void> _salvarTreino() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final newTreino = Treino(
        nome: _nome,
        objetivo: _objetivo,
        repeticoes: _repeticoes ?? 0,
        series: _series ?? 0,
      );

      try {
        await _treinosController.addTreino(newTreino);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Treino adicionado com sucesso!")),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erro ao salvar treino: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Novo Treino")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: "Nome do Treino"),
                validator: (value) =>
                    value == null || value.isEmpty ? "Campo obrigatório" : null,
                onSaved: (value) => _nome = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Objetivo"),
                validator: (value) =>
                    value == null || value.isEmpty ? "Campo obrigatório" : null,
                onSaved: (value) => _objetivo = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Repetições"),
                keyboardType: TextInputType.number,
                onSaved: (value) =>
                    _repeticoes = value != null && value.isNotEmpty
                        ? int.tryParse(value)
                        : 0,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Séries"),
                keyboardType: TextInputType.number,
                onSaved: (value) =>
                    _series = value != null && value.isNotEmpty
                        ? int.tryParse(value)
                        : 0,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _salvarTreino,
                child: const Text("Salvar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
