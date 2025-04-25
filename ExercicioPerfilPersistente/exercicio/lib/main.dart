import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MaterialApp(home: PaginaInformacoesPessoais()));
}

class PaginaInformacoesPessoais extends StatefulWidget {
  @override
  _PaginaInformacoesPessoaisState createState() =>
      _PaginaInformacoesPessoaisState();
}

class _PaginaInformacoesPessoaisState extends State<PaginaInformacoesPessoais> {
  final TextEditingController controladorNome = TextEditingController();
  final TextEditingController controladorIdade = TextEditingController();
  String nome = '';
  String idade = '';
  String cor = 'red'; // Cor padrão

  // Carregar dados salvos
  void carregarDados() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      nome = prefs.getString('nome') ?? '';
      idade = prefs.getString('idade') ?? '';
      cor = prefs.getString('cor') ?? 'red';
    });
  }

  // Salvar dados
  void salvarDados() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('nome', controladorNome.text);
    await prefs.setString('idade', controladorIdade.text);
    await prefs.setString('cor', cor);
    carregarDados(); // Atualizar os dados na tela
  }

  @override
  void initState() {
    super.initState();
    carregarDados(); // Carregar dados assim que o app iniciar
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Informações Pessoais')),
      body: Container(
        color: Color(int.parse('0xff${cor.substring(1)}')), // Cor de fundo com base na cor favorita
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: controladorNome,
              decoration: InputDecoration(labelText: 'Nome'),
            ),
            TextField(
              controller: controladorIdade,
              decoration: InputDecoration(labelText: 'Idade'),
              keyboardType: TextInputType.number,
            ),
            // Botões para escolher a cor
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      cor = 'red';
                    });
                  },
                  child: Text('Vermelho'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red, // Cor do botão vermelho
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      cor = 'blue';
                    });
                  },
                  child: Text('Azul'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue, // Cor do botão azul
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: salvarDados,
              child: Text('Salvar Dados'),
            ),
            SizedBox(height: 20),
            Text('Nome: $nome'),
            Text('Idade: $idade'),
            Text('Cor favorita: $cor'),
          ],
        ),
      ),
    );
  }
}
