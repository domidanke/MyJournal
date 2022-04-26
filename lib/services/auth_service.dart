import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  factory AuthService() {
    return _singleton;
  }
  AuthService._internal();
  static final AuthService _singleton = AuthService._internal();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final _fireStore = FirebaseFirestore.instance;
  var _darkMode = false;

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

  User getCurrentFirebaseUser() {
    return _firebaseAuth.currentUser;
  }

  Future<bool> getIsDarkMode() async {
    final userLoaded = await _fireStore
        .collection('users')
        .where('userID', isEqualTo: _firebaseAuth.currentUser.uid)
        .get();
    _darkMode = userLoaded.docs[0].data()['darkMode'];
    return _darkMode;
  }

  bool isDarkMode() {
    return _darkMode;
  }

  //region Toggle Dark Mode
  Future<void> toggleDarkMode(bool darkMode) async {
    final userLoaded = await _fireStore
        .collection('users')
        .where('userID', isEqualTo: _firebaseAuth.currentUser.uid)
        .get();
    final userData = userLoaded.docs[0];
    await _fireStore
        .collection('users')
        .doc(userData.id)
        .update({'darkMode': darkMode});
    _darkMode = darkMode;
  }
  //endregion

  Future<User> signUp(String email, String password) async {
    try {
      final newUser = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return newUser.user;
    } on FirebaseAuthException catch (e) {
      print(e);
      return null;
    }
  }
}
