import 'package:flutter/material.dart';
import 'package:sa_somativa_hardware/controllers/auth_controller.dart';
import 'package:sa_somativa_hardware/views/registro_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _nifField = TextEditingController();
  final _senhaField = TextEditingController();
  final _authController = AuthController();
  bool _senhaOculta = true;

  void _login() async {
    try {
      await _authController.loginWithNif(
        _nifField.text.trim(),
        _senhaField.text,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Falha ao fazer login: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
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
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: const Text("Login"),
            ),
            TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RegistroView()),
              ),
              child: const Text("Não tem uma conta? Registre-se!"),
            ),
          ],
        ),
      ),
    );
  }
}
