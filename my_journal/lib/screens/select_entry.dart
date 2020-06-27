import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_journal/classes/user_manager.dart';

class SelectEntry extends StatefulWidget {
  const SelectEntry({this.userManager});
  final UserManager userManager;
  static String id = 'select_entry_screen';
  @override
  _SelectEntryState createState() => _SelectEntryState();
}

class _SelectEntryState extends State<SelectEntry> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: widget.userManager.entryCards.isNotEmpty
                ? Column(
                    children: <Widget>[
                      Container(
                        height: 50,
                        child: Center(
                          child: Text(
                            'Total Entries: ${widget.userManager.getTotalJournalEntries()}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 20.0),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView(
                          children: widget.userManager.entryCards,
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
