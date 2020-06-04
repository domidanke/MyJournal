import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../widgets/home_card.dart';
import 'create_entry.dart';

String getCurrentDate() {
  final formatter = DateFormat('yyyy-MM-dd');
  final DateTime now = DateTime.now();
  return formatter.format(now);
}

class MyJournalScreen extends StatefulWidget {
  static String id = 'my_journal_screen';

  @override
  _MyJournalScreenState createState() => _MyJournalScreenState();
}

class _MyJournalScreenState extends State<MyJournalScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser loggedInUser;
  String userEmail = '';
  String lastJournalDate = '2020-05-31';
  int totalJournalEntries = 22;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  // ignore: avoid_void_async
  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
        setState(() {
          userEmail = loggedInUser.email;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFfffff3),
      appBar: AppBar(
        leading: const Text(''),
        //backgroundColor: headerColor,
        title: const Text(
          'MyJournal',
          // style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.lock_open),
            onPressed: () {
              _auth.signOut();
              Navigator.pop(context);
            },
          ),
        ],
      ),
      //backgroundColor: ,
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
              child: Center(
                child: Text(
                  'Welcome Back \n $userEmail',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 35.0,
                      color: Colors.black87),
                ),
              ),
            ),
            HomeCard(
              image: const AssetImage('images/journal.jpg'),
              text: 'Create Your Journal Entry',
              icon: Icon(
                Icons.create,
                //color: ,
              ),
              headerText: getCurrentDate(),
              onTap: () {
                Navigator.pushNamed(context, CreateEntry.id);
              },
            ),
            HomeCard(
              image: const AssetImage('images/journalEdit.jpeg'),
              text: 'Edit Your Last Journal Entry',
              icon: Icon(
                Icons.more_horiz,
                //color: ,
              ),
              headerText: 'Last Entry: $lastJournalDate',
              onTap: () {
                print('Edit Tapped');
              },
            ),
            HomeCard(
              image: const AssetImage('images/calendar.jpeg'),
              text: 'View Your Journal Entry',
              icon: Icon(
                Icons.remove_red_eye,
                //color: ,
              ),
              headerText: 'Total Entries: $totalJournalEntries',
              onTap: () {
                print('View Tapped');
              },
            ),
          ],
        ),
      ),
    );
  }
}
