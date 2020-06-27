import 'package:flutter/material.dart';

import 'screens/create_entry.dart';
import 'screens/login_screen.dart';
import 'screens/my_journal_screen.dart';
import 'screens/registration_screen.dart';
import 'screens/select_entry.dart';
import 'screens/view_entry.dart';
import 'screens/welcome_screen.dart';

void main() => runApp(MyJournalApp());

class MyJournalApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xff383b44),
      ),
      debugShowCheckedModeBanner: false,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        MyJournalScreen.id: (context) => MyJournalScreen(),
        CreateEntry.id: (context) => CreateEntry(),
        ViewEntry.id: (context) => ViewEntry(),
        SelectEntry.id: (context) => SelectEntry(),
      },
      initialRoute: WelcomeScreen.id,
    );
  }
}
