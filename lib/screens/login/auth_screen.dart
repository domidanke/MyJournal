import 'package:flutter/cupertino.dart';
import 'package:my_journal/screens/login/loading_screen.dart';
import 'package:my_journal/screens/login/welcome_screen.dart';
import 'package:my_journal/services/auth_service.dart';

class AuthScreen extends StatelessWidget {
  AuthScreen({Key key}) : super(key: key);
  static String id = '/';
  final _authService = AuthService();

  /// Firebase logic goes into '/'-route for some odd reason
  @override
  Widget build(BuildContext context) {
    try {
      final firebaseUser = _authService.getCurrentFirebaseUser();
      if (firebaseUser != null) {
        return LoadingScreen();
      } else {
        return WelcomeScreen();
      }
    } catch (e) {
      return WelcomeScreen();
    }
  }
}
