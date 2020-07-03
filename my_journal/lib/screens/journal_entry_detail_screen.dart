import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_journal/classes/journal_entry.dart';
import 'package:my_journal/constants.dart';

class JournalEntryDetailScreen extends StatefulWidget {
  const JournalEntryDetailScreen({this.journalEntry});
  static String id = 'view_entry_screen';
  final JournalEntry journalEntry;

  @override
  _JournalEntryDetailScreenState createState() =>
      _JournalEntryDetailScreenState();
}

class _JournalEntryDetailScreenState extends State<JournalEntryDetailScreen> {
  String formatDate(date) {
    return date.month.toString() +
        '-' +
        date.day.toString() +
        '-' +
        date.year.toString();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
            child: Center(
                child: Container(
                    decoration: kCardDecoration,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 20.0),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: !widget.journalEntry.isFavorite
                                    ? const Text('')
                                    : Icon(
                                        Icons.favorite,
                                      ),
                              ),
                              Text(
                                formatDate(widget.journalEntry.eventDate),
                                style: const TextStyle(fontSize: 20.0),
                              ),
                              Expanded(
                                flex: 1,
                                child: !widget.journalEntry.isFavorite
                                    ? const Text('')
                                    : Icon(
                                        Icons.favorite,
                                      ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: <Widget>[
                            widget.journalEntry.getFeelingIcon(),
                            Text(
                              widget.journalEntry.headerText,
                              style: const TextStyle(fontSize: 30.0),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 20.0, right: 20.0, bottom: 10.0),
                              child: Text(
                                widget.journalEntry.content,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 20.0,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    )))),
      ),
    );
  }
}
