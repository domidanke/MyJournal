import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  AuthService(this._firebaseAuth);
  final FirebaseAuth _firebaseAuth;

  Stream<User> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<String> signIn(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return 'Signed in';
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<User> signUp(String email, String password) async {
    try {
      final newUser = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return newUser.user;
    } on FirebaseAuthException catch (e) {
      return null;
    }
  }
}
