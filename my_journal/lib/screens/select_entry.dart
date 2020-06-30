import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_journal/classes/journal_entry.dart';
import 'package:my_journal/screens/view_entry.dart';
import 'package:my_journal/widgets/journal_entry_card.dart';

class SelectEntry extends StatefulWidget {
  const SelectEntry({this.journalEntryData});
  final List journalEntryData;
  static String id = 'select_entry_screen';
  @override
  _SelectEntryState createState() => _SelectEntryState();
}

class _SelectEntryState extends State<SelectEntry> {
  List<JournalEntryCard> entryCards = [];
  @override
  void initState() {
    super.initState();
    createCards();
  }

  void createCards() {
    for (final entryData in widget.journalEntryData) {
      final JournalEntry journalEntry = JournalEntry(
        eventDate: entryData['dateSelected'],
        headerText: entryData['header'],
        feeling: entryData['feeling'],
        isFavorite: entryData['isFavorite'],
        content: entryData['content'],
      );
      entryCards.add(JournalEntryCard(
        entry: journalEntry,
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ViewEntry(
                        entry: journalEntry,
                      )));
        },
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: entryCards.isNotEmpty
                ? Column(
                    children: <Widget>[
                      Container(
                        height: 50,
                        child: Center(
                          child: Text(
                            'Total Entries: ${entryCards.length}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 20.0),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView(
                          children: entryCards,
                        ),
                      )
                    ],
                  )
                : Center(
                    child: Container(
                      child: const Text(
                        "You don't have any\nEntries yet",
                        style: TextStyle(
                          fontSize: 25.0,
                          color: Colors.white,
                          letterSpacing: 2.0,
                          height: 2.0,
                        ),
                      ),
                    ),
                  )));
  }
}
