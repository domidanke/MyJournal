import 'package:flutter/material.dart';

import 'screens/create_journal_entry_screen.dart';
import 'screens/journal_entry_detail_screen.dart';
import 'screens/journal_entry_overview_screen.dart';
import 'screens/login_screen.dart';
import 'screens/registration_screen.dart';
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
        CreateJournalEntryScreen.id: (context) => CreateJournalEntryScreen(),
        JournalEntryDetailScreen.id: (context) =>
            const JournalEntryDetailScreen(),
        JournalEntryOverviewScreen.id: (context) =>
            JournalEntryOverviewScreen(),
      },
      initialRoute: WelcomeScreen.id,
    );
  }
}
