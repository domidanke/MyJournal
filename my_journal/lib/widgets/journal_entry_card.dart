import 'package:flutter/material.dart';
import 'package:my_journal/constants.dart';
import 'package:my_journal/screens/journal_entry_detail_screen.dart';

import '../classes/journal_entry.dart';

class JournalEntryCard extends StatelessWidget {
  const JournalEntryCard({this.journalEntry});
  final JournalEntry journalEntry;

  String formatDate(date) {
    return date.month.toString() +
        '-' +
        date.day.toString() +
        '-' +
        date.year.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        decoration: kCardDecoration,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: Text(journalEntry.headerText),
              subtitle: Text(formatDate(journalEntry.eventDate)),
              trailing: journalEntry.isFavorite
                  ? Icon(Icons.favorite)
                  : const Text(''),
              leading: journalEntry.getFeelingIcon(iconSize: 40.0),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => JournalEntryDetailScreen(
                              journalEntry: journalEntry,
                            )));
              },
            ),
          ],
        ),
      ),
    );
  }
}
