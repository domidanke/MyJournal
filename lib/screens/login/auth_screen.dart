import 'package:flutter/material.dart';
import 'package:my_journal/main.dart';
import 'package:my_journal/screens/login/welcome_screen.dart';
import 'package:my_journal/screens/main/main_screen.dart';
import 'package:my_journal/services/auth_service.dart';

class AuthScreen extends StatelessWidget {
  AuthScreen({Key key}) : super(key: key);
  static String id = '/';
  final _authService = AuthService();

  /// Firebase logic goes into '/'-route for some odd reason
  @override
  Widget build(BuildContext context) {
    final firebaseUser = _authService.getCurrentFirebaseUser();
    if (firebaseUser == null) {
      return WelcomeScreen();
    } else {
      return FutureBuilder<bool>(
        future: _authService.getIsDarkMode(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (!snapshot.hasData) {
            // while data is loading:
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            // data loaded:
            final darkMode = snapshot.data;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              MyJournalApp.themeNotifier.value =
                  darkMode ? ThemeMode.dark : ThemeMode.light;
            });
            return MainScreen();
          }
        },
      );
    }
  }
}
