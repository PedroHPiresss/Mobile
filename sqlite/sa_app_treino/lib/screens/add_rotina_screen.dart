import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sa_app_treino/controllers/rotinas_controller.dart';
import 'package:sa_app_treino/models/rotina_model.dart';
import 'package:sa_app_treino/screens/rotina_detalhe_screen.dart';

class AddRotinaScreen extends StatefulWidget {
  final int treinoId; // recebe o treino Id da Tela anterior

  AddRotinaScreen({super.key, required this.treinoId});

  @override
  State<StatefulWidget> createState() {
    return _AddRotinaScreenState();
  }
}

class _AddRotinaScreenState extends State<AddRotinaScreen> {
  final _formKey = GlobalKey<FormState>();
  final RotinasController _controllerRotina = RotinasController();

  late String tipoServico;
  String observacao = "";
  DateTime _selectedDate = DateTime.now(); // data selecionada inicia com a data atual
  TimeOfDay _selectedTime = TimeOfDay.now(); // hora selecionada inicia com a hora atual

  // método para Seleção da Data
  Future<void> _selecionarData(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(), // Não permite selecionar data do passado
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // método para Seleção de Hora
  Future<void> _selecionarHora(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  // método para Salvar Rotina
  Future<void> _salvarRotina() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save(); // ESSENCIAL: salva os valores do formulário

      final DateTime finalDateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );

      // criar a rotina (obj)
      final newRotina = Rotina(
        treinoId: widget.treinoId,
        dataHora: finalDateTime,
        tipoTreino: tipoServico,
        observacao: observacao.isEmpty ? "." : observacao,
      );

      try {
        await _controllerRotina.insertRotina(newRotina);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Rotina agendada com sucesso!")),
        );
        // Retorna para a tela anterior (RotinaDetalheScreen)
        Navigator.push(context, MaterialPageRoute(builder: (context) => RotinaDetalheScreen(treinoId: widget.treinoId)));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erro ao agendar rotina: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat dataFormatada = DateFormat("dd/MM/yyyy");
    final DateFormat horaFormatada = DateFormat("HH:mm"); // biblioteca intl

    return Scaffold(
      appBar: AppBar(
        title: const Text("Nova Rotina"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey, // atribui a chave ao formulário
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: "Tipo de Serviço"),
                validator: (value) => value!.isEmpty ? "Por favor, insira um tipo de serviço" : null,
                onSaved: (value) => tipoServico = value!,
              ),
              const SizedBox(height: 10), // espaçamento
              Row(
                children: [
                  Expanded(child: Text("Data: ${dataFormatada.format(_selectedDate)}")),
                  TextButton(
                    onPressed: () => _selecionarData(context),
                    child: const Text("Selecionar Data"),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Hora: ${horaFormatada.format(DateTime(0, 0, 0, _selectedTime.hour, _selectedTime.minute))}",
                    ),
                  ),
                  TextButton(
                    onPressed: () => _selecionarHora(context),
                    child: const Text("Selecionar Hora"),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: const InputDecoration(labelText: "Observação"),
                maxLines: 3,
                onSaved: (value) => observacao = value!,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _salvarRotina,
                child: const Text("Agendar Rotina"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
