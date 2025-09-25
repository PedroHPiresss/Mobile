import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegistroView extends StatefulWidget {
  const RegistroView({super.key});

  @override
  State<RegistroView> createState() => _RegistroViewState();
}

class _RegistroViewState extends State<RegistroView> {
 //atributos
  final _emailField = TextEditingController();
  final _senhaField = TextEditingController();
  final _confSenhaField = TextEditingController();
  final _authController = FirebaseAuth.instance; //controlador do Firebase Auth
  bool _senhaOculta = true;
  bool _confSenhaOculta = true;

  //método _registrar
  void _registrar() async{
    if(_senhaField.text != _confSenhaField.text) return;//interrompe o método se senhas diferentes
    try {
      await _authController.createUserWithEmailAndPassword(
        email: _emailField.text.trim(), 
        password: _senhaField.text);
      Navigator.pop(context); //fecha a tela de Registro
      // é logado automaticamente após o cadastro
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Falha ao registrar: $e"))
      );
    }
  }

  //build da tela
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Registro")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailField,
              decoration: InputDecoration(labelText: "Email"),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _senhaField,
              decoration: InputDecoration(
                labelText: "Senha",
                suffix: IconButton(
                  onPressed: () => setState(() {
                    _senhaOculta =
                        !_senhaOculta; //inverte o valor da variável booleana
                  }),
                  icon: _senhaOculta
                      ? Icon(Icons.visibility)
                      : Icon(Icons.visibility_off),
                ),
              ),
              obscureText: _senhaOculta,
            ),
            TextField(
              controller: _confSenhaField,
              decoration: InputDecoration(
                labelText: "Senha",
                suffix: IconButton(
                  onPressed: () => setState(() {
                    _confSenhaOculta =
                        !_confSenhaOculta; //inverte o valor da variável booleana
                  }),
                  icon: _confSenhaOculta
                      ? Icon(Icons.visibility)
                      : Icon(Icons.visibility_off),
                ),
              ),
              obscureText: _confSenhaOculta,
            ),

            SizedBox(height: 20),
            ElevatedButton(onPressed: _registrar, child: Text("Registrar")),
          ],
        ),
      ),
    );
  }
}