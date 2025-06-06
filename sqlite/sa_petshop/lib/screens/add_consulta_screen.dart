import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sa_petshop/controllers/consultas_controller.dart';
import 'package:sa_petshop/models/consulta_model.dart';
import 'package:sa_petshop/screens/pet_detalhe_screen.dart';
// import 'package:sa_petshop/screens/pet_detalhe_screen.dart'; // Removido, pois a navegação é feita via pop

class AddConsultaScreen extends StatefulWidget {
  final int petId; // recebe o pet Id da Tela anterior

  AddConsultaScreen({super.key, required this.petId});

  @override
  State<StatefulWidget> createState() {
    return _AddConsultaScreenState();
  }
}

class _AddConsultaScreenState extends State<AddConsultaScreen> {
  final _formKey = GlobalKey<FormState>();
  final ConsultasController _controllerConsulta = ConsultasController();

  late String tipoServico;
  String observacao = "";
  DateTime _selectedDate = DateTime.now(); //data Selecionada é a data atual inicalmente
  TimeOfDay _selectedTime = TimeOfDay.now(); //hora Selecioanda é a hora atual Inicialmente

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

  // método para Seleção de hora
  Future<void> _selecionarHora(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() { // Adicionado setState para atualizar a UI com a hora selecionada
        _selectedTime = picked;
      });
    }
  }

  // método para Salvar Consulta
  Future<void> _salvarConsulta() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save(); // ESSENCIAL: Salva os valores do formulário

      final DateTime finalDateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );

      // criar a consulta (obj)
      final newConsulta = Consulta(
        petId: widget.petId,
        dataHora: finalDateTime,
        tipoServico: tipoServico,
        observacao: observacao.isEmpty ? "." : observacao, // Verifica se observacao está vazia
      );

      try {
        await _controllerConsulta.insertConsulta(newConsulta);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Consulta agendada com sucesso!")),
        );
        // Retorna para a tela anterior (PetDetalheScreen)
        Navigator.push(context, MaterialPageRoute(builder: (context)=>PetDetalheScreen(petId: widget.petId)));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erro ao agendar consulta: $e")),
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
        title: const Text("Nova Consulta"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey, // Atribui a chave ao formulário
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: "Tipo de Serviço"),
                validator: (value) => value!.isEmpty ? "Por favor, insira um tipo de serviço" : null,
                onSaved: (value) => tipoServico = value!,
              ),
              const SizedBox(height: 10), // Espaçamento
              Row(
                children: [
                  Expanded(child: Text("Data: ${dataFormatada.format(_selectedDate)}")),
                  TextButton(
                    onPressed: () => _selecionarData(context), // Chamada correta do método
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
                    onPressed: () => _selecionarHora(context), // Chamada correta do método
                    child: const Text("Selecionar Hora"),
                  ),
                ],
              ),
              const SizedBox(height: 10), // Espaçamento
              TextFormField(
                decoration: const InputDecoration(labelText: "Observação"),
                maxLines: 3,
                onSaved: (value) => observacao = value!,
              ),
              const SizedBox(height: 20), // Espaçamento
              ElevatedButton(
                onPressed: _salvarConsulta,
                child: const Text("Agendar Consulta"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}