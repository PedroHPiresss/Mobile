import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sa_app_treino/controllers/rotinas_controller.dart';
import 'package:sa_app_treino/controllers/treinos_controller.dart';
import 'package:sa_app_treino/models/rotina_model.dart';
import 'package:sa_app_treino/models/treino_model.dart';

class RotinaDetalheScreen extends StatefulWidget {
  final int treinoId;

  const RotinaDetalheScreen({Key? key, required this.treinoId}) : super(key: key);

  @override
  State<RotinaDetalheScreen> createState() => _RotinaDetalheScreenState();
}

class _RotinaDetalheScreenState extends State<RotinaDetalheScreen> {
  final RotinasController _rotinasController = RotinasController();
  final TreinosController _treinosController = TreinosController();

  Treino? _treino;
  List<Rotina> _rotinas = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTreinoELista();
  }

  Future<void> _loadTreinoELista() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final treino = await _treinosController.findTreinoById(widget.treinoId);
      final rotinas = await _rotinasController.getRotinasByTreino(widget.treinoId);

      setState(() {
        _treino = treino;
        _rotinas = rotinas;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao carregar rotinas: $e")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final formatter = DateFormat('dd/MM/yyyy HH:mm');
    return formatter.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_treino != null ? 'Rotinas: ${_treino!.nome}' : 'Detalhes do Treino'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _rotinas.isEmpty
              ? const Center(child: Text('Nenhuma rotina cadastrada.'))
              : ListView.builder(
                  itemCount: _rotinas.length,
                  itemBuilder: (context, index) {
                    final rotina = _rotinas[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        title: Text('Tipo: ${rotina.tipoTreino}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Data/Hora: ${_formatDateTime(rotina.dataHora)}'),
                            const SizedBox(height: 4),
                            Text('Observação: ${rotina.observacao}'),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
