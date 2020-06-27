import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_journal/classes/entry.dart';
import 'package:my_journal/screens/view_entry.dart';

import '../widgets/entry_card.dart';

class UserManager {
  final _fireStore = Firestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseUser _loggedInUser;
  List<EntryCard> _entryCards;

  FirebaseAuth get auth => _auth;
  FirebaseUser get loggedInUser => _loggedInUser;
  List<EntryCard> get entryCards => _entryCards;

  Future<void> initUserData(BuildContext context) async {
    _entryCards = [];
    _loggedInUser = await getCurrentUser();
    _entryCards = await loadJournalEntries(context);
  }

  Future<FirebaseUser> getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        return user;
      }
    } catch (e) {
      print(e);
    }
  }

  Future<List<EntryCard>> loadJournalEntries(BuildContext context) async {
    final List<EntryCard> tmpList = [];
    _fireStore
        .collection('entries_' + _loggedInUser.email)
        .orderBy('dateSelected', descending: false)
        .snapshots()
        .listen((data) {
      // ignore: prefer_foreach
      for (final x in data.documents) {
        final Entry entry = Entry(
          date: x.data['dateSelected'],
          headerText: x.data['header'],
          feeling: x.data['feeling'],
          isFavorite: x.data['isFavorite'],
          content: x.data['content'],
        );
        tmpList.add(EntryCard(
          entry: entry,
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ViewEntry(
                          entry: entry,
                        )));
          },
        ));
      }
    });
    return tmpList;
  }

  String getTodayFormatted() {
    return DateFormat.yMMMd().format(DateTime.now());
  }

  Entry getMostRecentEntry() {
    return _entryCards[0].entry;
  }

  int getTotalJournalEntries() {
    return _entryCards.length;
  }

  void logOut() {
    _auth.signOut();
  }
}
