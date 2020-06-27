import 'package:flutter/material.dart';
import 'package:my_journal/classes/user_manager.dart';
import 'package:my_journal/constants.dart';
import 'package:my_journal/screens/welcome_screen.dart';

import '../widgets/home_card.dart';
import 'create_entry.dart';
import 'select_entry.dart';

class MyJournalScreen extends StatefulWidget {
  static String id = 'my_journal_screen';

  @override
  _MyJournalScreenState createState() => _MyJournalScreenState();
}

class _MyJournalScreenState extends State<MyJournalScreen> {
  UserManager userManager = UserManager();
  String today = '';
  String lastJournalDate = '';
  String totalJournalEntries = '';
  bool isInit = false;

  @override
  void initState() {
    super.initState();
    userManager.initUserData(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 40.0, top: 10.0, right: 25.0, bottom: 5.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Center(
                        child: Text(
                          'Welcome Back',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25.0,
                              foreground: Paint()..shader = headerGradient),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.lock_open,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          userManager.logOut();
                          Navigator.pushNamed(context, WelcomeScreen.id);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            HomeCard(
              cardKey: const Key('CreateEntryKey'),
              image: const AssetImage('images/journal.jpg'),
              text: 'Create Your Journal Entry',
              icon: Icon(
                Icons.create,
              ),
              headerText: userManager.getTodayFormatted(),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CreateEntry()));
              },
            ),
//            HomeCard(
//              cardKey: const Key('EditLastEntryKey'),
//              image: const AssetImage('images/journalEdit.jpeg'),
//              text: 'Edit Your Last Journal Entry',
//              icon: Icon(
//                Icons.more_horiz,
//              ),
//              headerText: 'Last Entry: $lastJournalDate',
//              onTap: () {
//                print('Edit Tapped');
//              },
//            ),
            HomeCard(
              cardKey: const Key('SelectEntriesKey'),
              image: const AssetImage('images/calendar.jpeg'),
              text: 'View Your Journal Entries',
              icon: Icon(Icons.remove_red_eye),
              headerText: 'Remember your experiences',
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SelectEntry(
                              userManager: userManager,
                            )));
              },
            ),
          ],
        ),
      ),
    );
  }
}
