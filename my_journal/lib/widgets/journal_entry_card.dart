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
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => JournalEntryDetailScreen(
                      journalEntry: journalEntry,
                    )));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: Container(
          decoration: kCardDecoration,
          height: 100,
          child: Column(
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: Text(
                        formatDate(journalEntry.eventDate),
                        style: const TextStyle(fontSize: 20.0),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: journalEntry.isFavorite
                          ? Icon(Icons.favorite)
                          : const Text(''),
                    )
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: Text(
                        journalEntry.headerText,
                        style: const TextStyle(fontSize: 15.0),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: journalEntry.getFeelingIcon(),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
