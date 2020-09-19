import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:my_journal/app_localization.dart';

import 'screens/create_journal_entry_screen.dart';
import 'screens/journal_entry_detail_screen.dart';
import 'screens/journal_entry_overview_screen.dart';
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
      supportedLocales: const [Locale('en', 'US'), Locale('de', 'DE')],
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        for (final supportedLocal in supportedLocales) {
          if (supportedLocal.languageCode == locale.languageCode &&
              supportedLocal.countryCode == locale.countryCode) {
            return supportedLocal;
          }
        }
        return supportedLocales.first;
      },
      debugShowCheckedModeBanner: false,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
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
