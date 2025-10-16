import 'package:flutter/material.dart';
import 'package:sa_somativa_hardware/controllers/auth_controller.dart';

class RegistroView extends StatefulWidget {
  const RegistroView({super.key});

  @override
  State<RegistroView> createState() => _RegistroViewState();
}

class _RegistroViewState extends State<RegistroView> {
  final _nifField = TextEditingController();
  final _senhaField = TextEditingController();
  final _confSenhaField = TextEditingController();
  final _authController = AuthController();
  bool _senhaOculta = true;
  bool _confSenhaOculta = true;

  void _registrar() async {
    if (_senhaField.text != _confSenhaField.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Senhas não coincidem")),
      );
      return;
    }
    try {
      await _authController.registerWithNif(
        _nifField.text.trim(),
        _senhaField.text,
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Falha ao registrar: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registro")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _nifField,
              decoration: const InputDecoration(labelText: "NIF"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _senhaField,
              decoration: InputDecoration(
                labelText: "Senha",
                suffix: IconButton(
                  onPressed: () => setState(() {
                    _senhaOculta = !_senhaOculta;
                  }),
                  icon: _senhaOculta ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off),
                ),
              ),
              obscureText: _senhaOculta,
            ),
            TextField(
              controller: _confSenhaField,
              decoration: InputDecoration(
                labelText: "Confirmar Senha",
                suffix: IconButton(
                  onPressed: () => setState(() {
                    _confSenhaOculta = !_confSenhaOculta;
                  }),
                  icon: _confSenhaOculta ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off),
                ),
              ),
              obscureText: _confSenhaOculta,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _registrar,
              child: const Text("Registrar"),
            ),
          ],
        ),
      ),
    );
  }
}
