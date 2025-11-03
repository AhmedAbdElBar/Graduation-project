import 'package:firebase_auth/firebase_auth.dart';

class AuthServiceForRegister {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String?> registerUser({
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    // 🔹 تحقق إن الباسوردين متطابقين
    if (password != confirmPassword) {
      return 'Passwords do not match.';
    }

    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null; // ✅ null يعني العملية نجحت
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          return 'This email is already registered.';
        case 'invalid-email':
          return 'Invalid email format.';
        case 'weak-password':
          return 'Password must be at least 6 characters.';
        case 'network-request-failed':
          return 'Network error. Please check your connection.';
        default:
          return 'Unexpected error: ${e.code}';
      }
    } catch (_) {
      return 'Something went wrong. Please try again.';
    }
  }
}
