import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_journal/classes/journal_entry.dart';
import 'package:my_journal/constants.dart';

class ViewEntry extends StatefulWidget {
  const ViewEntry({this.entry});
  static String id = 'view_entry_screen';
  final JournalEntry entry;

  @override
  _ViewEntryState createState() => _ViewEntryState();
}

class _ViewEntryState extends State<ViewEntry> {
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
                                child: !widget.entry.isFavorite
                                    ? const Text('')
                                    : Icon(
                                        Icons.favorite,
                                      ),
                              ),
                              Text(
                                widget.entry.eventDate,
                                style: const TextStyle(fontSize: 20.0),
                              ),
                              Expanded(
                                flex: 1,
                                child: !widget.entry.isFavorite
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
                            widget.entry.getFeelingIcon(),
                            Text(
                              widget.entry.headerText,
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
                                widget.entry.content,
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
