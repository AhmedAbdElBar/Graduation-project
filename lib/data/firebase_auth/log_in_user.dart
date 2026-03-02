import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String?> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null; 
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          return 'No account found with this email.';
        case 'wrong-password':
        case 'invalid-credential':
        case 'invalid-login-credentials':
          return 'Incorrect password.';
        case 'invalid-email':
          return 'Invalid email format.';
        case 'user-disabled':
          return 'This account has been disabled.';
        case 'network-request-failed':
          return 'Please check your internet connection.';
        default:
          return 'Unexpected error: ${e.code}';
      }
    } catch (_) {
      return 'Something went wrong. Please try again.';
    }
  }
}
