import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyJournalScreen extends StatefulWidget {
  static String id = 'my_jounral_screen';

  @override
  _MyJournalScreenState createState() => _MyJournalScreenState();
}

class _MyJournalScreenState extends State<MyJournalScreen> {
  final _auth = FirebaseAuth.instance;
  FirebaseUser loggedInUser;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Text(''),
        backgroundColor: Colors.blueAccent,
        title: Text('MyJournal'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              _auth.signOut();
              Navigator.pop(context);
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Text(
              'Hello',
            ),
          ],
        ),
      ),
    );
  }
}
