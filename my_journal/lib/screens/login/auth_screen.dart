import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_journal/screens/login/loading_screen.dart';
import 'package:my_journal/screens/login/welcome_screen.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key key}) : super(key: key);
  static String id = '/';

  /// Firebase logic goes into '/'-route for some odd reason
  @override
  Widget build(BuildContext context) {
    try {
      final firebaseUser = context.watch<User>();
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
