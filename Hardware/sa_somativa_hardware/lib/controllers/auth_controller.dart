import 'package:firebase_auth/firebase_auth.dart';
import 'package:local_auth/local_auth.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final LocalAuthentication _localAuth = LocalAuthentication();

  User? get currentUser => _auth.currentUser;

  // Login with NIF and password (NIF treated as email)
  Future<void> loginWithNif(String nif, String password) async {
    await _auth.signInWithEmailAndPassword(
      email: '$nif@nif.com', // Append domain to make it email-like
      password: password,
    );
  }

  // Register with NIF and password
  Future<void> registerWithNif(String nif, String password) async {
    await _auth.createUserWithEmailAndPassword(
      email: '$nif@nif.com',
      password: password,
    );
  }

  // Logout
  Future<void> logout() async {
    await _auth.signOut();
  }

  // Check if biometric is available
  Future<bool> isBiometricAvailable() async {
    return await _localAuth.canCheckBiometrics;
  }

  // Authenticate with biometric
  Future<bool> authenticateBiometric() async {
    try {
      return await _localAuth.authenticate(
        localizedReason: 'Confirme sua identidade para registrar o ponto',
        options: const AuthenticationOptions(
          biometricOnly: true,
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );
    } catch (e) {
      return false;
    }
  }
}
