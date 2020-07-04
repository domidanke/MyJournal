import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_journal/classes/journal_entry.dart';
import 'package:my_journal/constants.dart';
import 'package:my_journal/screens/create_journal_entry_screen.dart';
import 'package:my_journal/screens/welcome_screen.dart';
import 'package:my_journal/widgets/journal_entry_card.dart';

final _fireStore = Firestore.instance;
FirebaseUser loggedInUser;

class JournalEntryOverviewScreen extends StatefulWidget {
  static String id = 'select_entry_screen';
  @override
  _JournalEntryOverviewScreenState createState() =>
      _JournalEntryOverviewScreenState();
}

class _JournalEntryOverviewScreenState
    extends State<JournalEntryOverviewScreen> {
  final _auth = FirebaseAuth.instance;
  List<JournalEntryCard> entryCards;

  @override
  void initState() {
    entryCards = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: kPink,
          child: Icon(
            Icons.add,
            size: 30.0,
          ),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CreateJournalEntryScreen()));
          },
        ),
        body: SafeArea(
          child: FutureBuilder(
            future: _auth.currentUser(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                loggedInUser = snapshot.data;
                return Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 5.0),
                      child: Container(
                        height: 50.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Expanded(
                              flex: 3,
                              child: Text(
                                'Welcome Back!',
                                style: TextStyle(
                                    fontSize: 25.0, color: Colors.white),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: IconButton(
                                icon: Icon(Icons.lock_open,
                                    color: Colors.white, size: 30.0),
                                onPressed: () {
                                  _auth.signOut();
                                  Navigator.pushNamed(
                                      context, WelcomeScreen.id);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    JournalEntryStream(),
                  ],
                );
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
        ));
  }
}

class JournalEntryStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _fireStore
          .collection('entries_' + loggedInUser.uid)
          .orderBy('eventDate', descending: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Padding(
            padding: EdgeInsets.only(top: 50.0),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        final journalEntries = snapshot.data.documents.reversed;
        final List<JournalEntryCard> journalEntryCards = [];

        // ignore: avoid_function_literals_in_foreach_calls
        journalEntries.forEach((entry) {
          print(entry.data['eventDate'].toDate());
          final eventDate = entry.data['eventDate'].toDate();
          final headerText = entry.data['header'];
          final content = entry.data['content'];
          final feeling = entry.data['feeling'];
          final isFavorite = entry.data['isFavorite'];

          /// Use Eventually
          /// final createdOn = entry.data['createdOn'].toDate();

          final JournalEntry journalEntry = JournalEntry(
            eventDate: eventDate,
            headerText: headerText,
            content: content,
            feeling: feeling,
            isFavorite: isFavorite,

            ///createdOn: createdOn,
          );
          journalEntryCards.add(JournalEntryCard(
            journalEntry: journalEntry,
          ));
        });

        return Expanded(
          child: Column(
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 5.0),
                child: Container(
                  height: 20.0,
                  child: Center(
                    child: Text(
                      'Total Journal Entries: ${journalEntryCards.length}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 20.0),
                  children: journalEntryCards,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
