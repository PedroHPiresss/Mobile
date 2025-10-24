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
        SnackBar(
          content: Text("Falha ao fazer login: $e"),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade700, Colors.blue.shade500],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.blue.shade50],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.login,
                size: 80,
                color: Colors.blue.shade700,
              ),
              const SizedBox(height: 20),
              Text(
                "Bem-vindo de volta!",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.blue.shade700,
                ),
              ),
              const SizedBox(height: 40),
              TextField(
                controller: _nifField,
                decoration: const InputDecoration(
                  labelText: "NIF",
                  prefixIcon: Icon(Icons.person, color: Colors.blue),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _senhaField,
                decoration: InputDecoration(
                  labelText: "Senha",
                  prefixIcon: Icon(Icons.lock, color: Colors.blue),
                  suffix: IconButton(
                    onPressed: () => setState(() {
                      _senhaOculta = !_senhaOculta;
                    }),
                    icon: _senhaOculta
                        ? const Icon(Icons.visibility)
                        : const Icon(Icons.visibility_off),
                  ),
                ),
                obscureText: _senhaOculta,
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Entrar", style: TextStyle(fontSize: 18)),
                ),
              ),
              const SizedBox(height: 20),
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
      ),
    );
  }
}
