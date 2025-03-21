import 'package:flutter/material.dart';

void main(){
  runApp(MaterialApp(
    home: TelaCadastro(),
  ));
}

class TelaCadastro extends StatefulWidget{
  _TelaCadastroState createState() => _TelaCadastroState();
}

class _TelaCadastroState extends State<TelaCadastro>{
  //atributos
  // chave se seleção de componentes do formulário
  final _formKey = GlobalKey<FormState>();
  String nome = "";
  String email = "";
  String senha = "";
  String genero = "";
  String dataNascimento = "";
  double _experiencia = 0;
  bool _aceite = false;

  //métodos
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cadastro de Usuário"),),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              //Campo Nome
              TextFormField(
                decoration: InputDecoration(labelText: "Nome"),
                validator:(value) => value!.isEmpty ? "Digite seu Nome" : null,
                onSaved: (value) => nome = value!,
              ),
              SizedBox(height: 10,),
              //Campo Email
              TextFormField(
                decoration: InputDecoration(labelText: "E-mail"),
                validator: (value) => value!.contains("@") ? null : "Digite um e-mail",
                onSaved: (value) => email = value!,
              ),
              SizedBox(height: 10,),
              //Campo Senha
              TextFormField(
                decoration: InputDecoration(labelText: "Senha"),
                obscureText: true,
                validator: (value) => value!.length < 6 ? "A senha deve ter no mínimo 6 char" : null ,
                onSaved: (value)=> senha = value!,
              ),
              SizedBox(height: 10,),
              //Seleção de Gênero
              Text("Gênero"),
              DropdownButtonFormField(
                items: ["Masculino", "Feminino", "Outro"].map((String genero){
                  return DropdownMenuItem(
                    value: genero,
                    child: Text(genero),
                  );
                }).toList(),
                onChanged: (value) {},
                validator: (value) => value == null ? "Selecione um gênero" : null,
                onSaved: (value)=> genero = value!,
              ),
              SizedBox(height: 10,),
              //Seleção de Data Nascimento
              TextFormField(
                decoration: InputDecoration(labelText: "Data de Nascimento"),
                validator: (value) => value!.isEmpty ? "Digite a data de nascimento" : null,
                onSaved:(value)=> dataNascimento = value!
              ),
              SizedBox(height: 10,),
              //Slider de Seleção
              Slider(
                value: _experiencia,
                min: 0,
                max: 20,
                divisions: 20, 
                label: _experiencia.round().toString(),
                onChanged: (value){
                  setState(() {
                    _experiencia = value;
                  });
                }),
                SizedBox(height: 10,),
                //Aceito dos Termos de uso
                CheckboxListTile(
                  value: _aceite,
                  title: Text("Aceito os termos de uso"), 
                  onChanged:(value) => setState(() {
                    _aceite = value!;
                  })),
                  SizedBox(height: 10,),
                  ElevatedButton(
                    onPressed: _enviarFormulario, 
                    child: Text("Enviar"))
            ],
          ))
        )
    );
  }

  void _enviarFormulario() {
    if(_formKey.currentState!.validate() && _aceite){
      _formKey.currentState!.save();
      showDialog(
        context: context, 
        builder: (context) =>
        AlertDialog(
          title: Text("Dados do Formulários"),
          content: Column(
            children: [
              Text("Nome: $nome"),
              Text("Email: $email")
            ],
          )
        ));
    }
  }
}