import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_journal/classes/entry.dart';
import 'package:my_journal/constants.dart';

class ViewEntry extends StatefulWidget {
  const ViewEntry({this.entry});
  static String id = 'view_entry_screen';
  final Entry entry;

  @override
  _ViewEntryState createState() => _ViewEntryState();
}

class _ViewEntryState extends State<ViewEntry> {
  String dateSelected = '';
  int feeling = 0;
  String header = '';
  String content = '';
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    dateSelected = widget.entry.date;
    feeling = widget.entry.feeling;
    header = widget.entry.headerText;
    content = widget.entry.content;
    isFavorite = widget.entry.isFavorite;
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
                                child: !isFavorite
                                    ? const Text('')
                                    : Icon(
                                        Icons.favorite,
                                      ),
                              ),
                              Text(
                                dateSelected,
                                style: const TextStyle(fontSize: 20.0),
                              ),
                              Expanded(
                                flex: 1,
                                child: !isFavorite
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
                              header,
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
                                content,
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
