//Criar a classeTela de Cadastro

import 'package:flutter/material.dart';

class TelaCadastroView extends StatefulWidget{
  _TelaCadastroViewState createState() => _TelaCadastroViewState();
}

class _TelaCadastroViewState extends State<TelaCadastroView>{
  //classe com o método build
  //atributos
  String _nome = "";
  String _email = "";
  double _idade = 13;
  bool _aceiteTermos = false;
  final _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cadastro"),centerTitle: true,),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child:Column(
            children: [
              //Campo do Nome
              TextFormField(
                decoration: InputDecoration(labelText: "Digite o Nome"),
                validator: (value) => value!.length>=3 ? "Insira um Nome" : null, //Operador Ternário
                onSaved: (value)=> _nome = value!,
              ),
              SizedBox(height:20,),
              //Campo do Email
              TextFormField(
                decoration: InputDecoration(labelText: "Digite o Email"),
                validator: (value) => value!.contains("@") ? "Insira um Email Válido" : null, //Operador Ternário
                onSaved: (value) => _email = value!,
              ),
              SizedBox(height: 20,),
              //Slider da Idade
              Text("Informe a Idade"),
              Slider(
                value: _idade,
                min: 13,
                max: 99,
                divisions: 86,
                label: _idade.round().toString(),
                onChanged: (value)=>setState(() {
                  _idade = value;
                })),
                SizedBox(height: 20,),
                //CheckBox de Aceite
                CheckboxListTile(
                  value: _aceiteTermos,
                  title: Text("Aceito os Termos de Uso."),
                  onChanged: (value)=>setState(() {
                    _aceiteTermos = value!;
                  })),
                SizedBox(height: 20,),
                //Botão de Envio
                ElevatedButton(
                  onPressed: _enviarDados,
                  child: Text("Enviar"))
                  
            ],
          )), ),
    );
  }


  void _enviarDados() {
    if(_formKey.currentState!.validate() && _aceiteTermos){
      _formKey.currentState!.save();
      Navigator.pushNamed(context, "/confirmacao");
    }
  }
}
