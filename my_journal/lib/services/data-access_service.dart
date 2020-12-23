import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_journal/models/app_user.dart';
import 'package:my_journal/models/entry.dart';
import 'package:my_journal/models/journal.dart';
import 'package:my_journal/screens/journal/edit_journal_sort_order_screen.dart';

import '../utils/constants.dart';

class DataAccessService {
  final _auth = FirebaseAuth.instance;
  final _fireStore = FirebaseFirestore.instance;
  final _storage =
      FirebaseStorage(storageBucket: 'gs://myjournal-2942d.appspot.com');

  //region User

  //region Create User
  Future<void> createUser(AppUser newUser) async {
    await _fireStore.collection('users').add({
      'userID': newUser.userID,
      'email': newUser.email,
      'darkMode': false,
      'created': DateTime.now()
    });
  }
  //endregion

  //region Get User Information
  Future<AppUser> getUserInformation() async {
    final userLoaded = await _fireStore
        .collection('users')
        .where('userID', isEqualTo: _auth.currentUser.uid)
        .get();
    String downloadedImageURL = '';
    try {
      final String filePath = 'profile-images/${_auth.currentUser.uid}';
      downloadedImageURL = await downloadImage(filePath);
    } catch (e) {
      downloadedImageURL = null;
    }
    final userData = userLoaded.docs[0].data();
    return AppUser(
        userID: userData['userID'],
        email: userData['email'],
        darkMode: userData['darkMode'],
        created: DateTime.parse(userData['created'].toDate().toString()),
        userImage: downloadedImageURL);
  }
  //endregion

  //region Is Dark Mode
  Future<bool> isDarkMode() async {
    final userLoaded = await _fireStore
        .collection('users')
        .where('userID', isEqualTo: _auth.currentUser.uid)
        .get();
    final userData = userLoaded.docs[0].data();
    return userData['darkMode'];
  }
  //endregion

  //region Toggle Dark Mode
  Future<void> toggleDarkMode(bool darkMode) async {
    final userLoaded = await _fireStore
        .collection('users')
        .where('userID', isEqualTo: _auth.currentUser.uid)
        .get();
    final userData = userLoaded.docs[0];
    await _fireStore
        .collection('users')
        .doc(userData.id)
        .update({'darkMode': darkMode});
  }
  //endregion

  Future<void> signOut() => _auth.signOut();
  //endregion

  // region Journal

  // region Get Journal Categories (Commented Out)
  // Future<List<JournalCategory>> getJournalCategories() async {
  //   final List<JournalCategory> journalCategories = [];
  //   final categories = await _fireStore
  //       .collection('journal-categories')
  //       .orderBy('desc', descending: false)
  //       .get();
  //   // ignore: avoid_function_literals_in_foreach_calls
  //   categories.docs.forEach((category) {
  //     journalCategories.add(
  //       JournalCategory(desc: category['desc'], code: category['code']),
  //     );
  //   });
  //   return journalCategories;
  // }
  //endregion

  //region Create Journal
  Future<bool> createJournal(Journal newJournal) async {
    try {
      final journalCreated = await _fireStore.collection('journals').add({
        'title': newJournal.title,
        'category': newJournal.category,
        'userID': _auth.currentUser.uid,
        'created': DateTime.now(),
        'modified': DateTime.now(),
        'sortOrder': 0,
        'accFeeling': 0,
        'totalEntries': 0,
        'totalSpecialDays': 0,
        'entriesColor': '',
        'mostRecentEntryDate': DateTime.parse('1969-06-09'),
      });
      await _fireStore
          .collection('journals')
          .doc(journalCreated.id)
          .collection('entries')
          .add({});
      StorageUploadTask _uploadTask;
      final String filePath = 'journal-images/${journalCreated.id}';
      _uploadTask = _storage.ref().child(filePath).putFile(newJournal.image);
      await _uploadTask.onComplete;
      return true;
    } catch (e) {
      return false;
    }
  }
  //endregion

  //region Get Journals
  Future<List<Journal>> getJournals() async {
    final List<Journal> journals = [];
    final journalsLoaded = await _fireStore
        .collection('journals')
        .where('userID', isEqualTo: _auth.currentUser.uid)
        .orderBy('sortOrder')
        .get();
    for (final journal in journalsLoaded.docs) {
      String downloadedImageURL = '';
      try {
        final String filePath = 'journal-images/${journal.id}';
        downloadedImageURL = await downloadImage(filePath);
      } catch (e) {
        downloadedImageURL = null;
      }
      journals.add(Journal(
        journalID: journal.id,
        sortOrder: journal['sortOrder'],
        title: journal['title'],
        category: journal['category'],
        icon: Icon(kCategoryIconMapping[journal['category']]),
        image: downloadedImageURL,
        entriesColor: toColor(journal['entriesColor']),
        created: DateTime.parse(journal['created'].toDate().toString()),
        accFeeling: journal['accFeeling'],
        totalEntries: journal['totalEntries'],
        totalSpecialDays: journal['totalSpecialDays'],
        mostRecentEntryDate:
            DateTime.parse(journal['mostRecentEntryDate'].toDate().toString()),
      ));
    }
    return journals;
  }
  //endregion

  //region Get Journal Info Stream
  Stream getJournalInfoStream(Journal journal) {
    return _fireStore.collection('journals').doc(journal.journalID).snapshots();
  }
  //endregion

  //region Update Journal Sort Order
  Future<bool> updateJournalSortOrder(
      Map<String, JournalCheckObject> newOrder) async {
    try {
      newOrder.forEach((k, v) {
        _fireStore
            .collection('journals')
            .doc(v.journalID)
            .update({'sortOrder': v.indexAssigned});
      });
      return true;
    } catch (e) {
      return false;
    }
  }
  //endregion

  //region Update Entries Color
  Future<bool> updateEntriesColor(Journal journal, Color color) async {
    try {
      _fireStore
          .collection('journals')
          .doc(journal.journalID)
          .update({'entriesColor': color.toString()});
      return true;
    } catch (e) {
      return false;
    }
  }
  //endregion

  //region Update Journal
  Future<bool> updateJournal(Journal journal) async {
    try {
      await _fireStore.collection('journals').doc(journal.journalID).update({
        'modified': DateTime.now(),
        'title': journal.title,
        'category': journal.category
      });
      StorageUploadTask _uploadTask;
      if (journal.image != null && journal.image.runtimeType != String) {
        final String filePath = 'journal-images/${journal.journalID}';
        _uploadTask = _storage.ref().child(filePath).putFile(journal.image);
        await _uploadTask.onComplete;
      }
      return true;
    } catch (e) {
      return false;
    }
  }
  //endregion

  //region Delete Journal
  Future<bool> deleteJournal(Journal journal) async {
    try {
      await _fireStore.collection('journals').doc(journal.journalID).delete();
      final String filePath = 'journal-images/${journal.journalID}';
      await deleteImage(filePath);
      return true;
    } catch (e) {
      return false;
    }
  }
  //endregion

  //endregion

  //region Entry

  //region Add New Entry
  Future<bool> addNewEntry(Entry entry) async {
    try {
      await _fireStore
          .collection('journals')
          .doc(entry.journal.journalID)
          .collection('entries')
          .add({
        'header': entry.header,
        'content': entry.content,
        'feeling': entry.feeling,
        'specialDay': entry.specialDay,
        'eventDate': entry.eventDate,
        'created': DateTime.now(),
        'modified': DateTime.now()
      });

      final journalToUpdate = await _fireStore
          .collection('journals')
          .doc(entry.journal.journalID)
          .get();

      await _fireStore
          .collection('journals')
          .doc(entry.journal.journalID)
          .update({
        'totalEntries': journalToUpdate.data()['totalEntries'] + 1,
        'totalSpecialDays': entry.specialDay
            ? journalToUpdate.data()['totalSpecialDays'] + 1
            : journalToUpdate.data()['totalSpecialDays'],
        'accFeeling': journalToUpdate.data()['accFeeling'] + entry.feeling,
        'mostRecentEntryDate': DateTime.now()
      });
      return true;
    } catch (e) {
      return false;
    }
  }
  //endregion

  //region Get Entry Stream
  Stream getEntryStream(Journal journal, bool sortByRecent) {
    return _fireStore
        .collection('journals')
        .doc(journal.journalID)
        .collection('entries')
        .orderBy('eventDate', descending: sortByRecent)
        .snapshots();
  }
  //endregion

  //region Update Entry
  Future<bool> updateEntry(Entry entry) async {
    try {
      await _fireStore
          .collection('journals')
          .doc(entry.journal.journalID)
          .collection('entries')
          .doc(entry.entryID)
          .update({
        'modified': DateTime.now(),
        'header': entry.header,
        'content': entry.content
      });
      return true;
    } catch (e) {
      return false;
    }
  }
  //endregion

  //region Delete Entry
  Future<bool> deleteEntry(Entry entry) async {
    try {
      await _fireStore
          .collection('journals')
          .doc(entry.journal.journalID)
          .collection('entries')
          .doc(entry.entryID)
          .delete();

      final journalToUpdate = await _fireStore
          .collection('journals')
          .doc(entry.journal.journalID)
          .get();

      await _fireStore
          .collection('journals')
          .doc(entry.journal.journalID)
          .update({
        'totalEntries': journalToUpdate.data()['totalEntries'] - 1,
        'totalSpecialDays': entry.specialDay
            ? journalToUpdate.data()['totalSpecialDays'] - 1
            : journalToUpdate.data()['totalSpecialDays'],
        'accFeeling': journalToUpdate.data()['accFeeling'] - entry.feeling,
      });
      return true;
    } catch (e) {
      return false;
    }
  }
  //endregion

  //endregion

  //region Image

  //region Upload Image
  Future<void> uploadImage(File file, String filePath) async {
    StorageUploadTask _uploadTask;
    _uploadTask = _storage.ref().child(filePath).putFile(file);
    await _uploadTask.onComplete;
  }
  //endregion

  //region Download Image
  Future<String> downloadImage(String filePath) async {
    final dynamic downloadedFile =
        await _storage.ref().child(filePath).getDownloadURL();
    return downloadedFile.toString();
  }
  //endregion

  //region Delete Image
  Future<void> deleteImage(String filePath) async {
    await _storage
        .ref()
        .child(filePath)
        .delete()
        .then((_) => print('Successfully deleted $filePath storage item'))
        .catchError((onError) => print(onError));
  }
  //endregion

  //endregion
}
