import 'package:flutter/material.dart';
import 'package:my_journal/models/journal.dart';
import 'package:my_journal/models/journal_info.dart';
import 'package:my_journal/services/data-access_service.dart';
import 'package:my_journal/utils/constants.dart';

import '../../services/locator.dart';

final DataAccessService _dataAccessService = locator<DataAccessService>();

class JournalInfoSheet extends StatefulWidget {
  const JournalInfoSheet({this.journal});
  final Journal journal;

  @override
  _JournalInfoSheetState createState() => _JournalInfoSheetState();
}

class _JournalInfoSheetState extends State<JournalInfoSheet> {
  Stream journalInfoStream;

  @override
  void initState() {
    super.initState();

    journalInfoStream = getJournalInfoStream();
  }

  Stream getJournalInfoStream() =>
      _dataAccessService.getJournalInfoStream(widget.journal);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: StreamBuilder(
          stream: journalInfoStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Padding(
                padding: EdgeInsets.only(top: 50.0),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (snapshot.connectionState == ConnectionState.active) {
              final info = snapshot.data;
              final JournalInfo journalInfo = JournalInfo(
                  accFeeling: info['accFeeling'],
                  totalEntries: info['totalEntries'],
                  totalSpecialDays: info['totalSpecialDays'],
                  entriesColor: toColor(info['entriesColor']),
                  mostRecentEntryDate: DateTime.parse(
                      info['mostRecentEntryDate'].toDate().toString()),
                  created: DateTime.parse(info['created'].toDate().toString()));
              return ListView(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 30.0),
                    child: Row(
                      children: <Widget>[
                        const Expanded(
                          child: Center(
                            child: Text(
                              'Created Date',
                              style: TextStyle(fontSize: 18.0),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              formatDate(journalInfo.created),
                              style: const TextStyle(fontSize: 18.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 30.0),
                    child: Row(
                      children: <Widget>[
                        const Expanded(
                          child: Center(
                            child: Text(
                              'Total Entries',
                              style: TextStyle(fontSize: 18.0),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              '${journalInfo.totalEntries}',
                              style: const TextStyle(fontSize: 18.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 30.0),
                    child: Row(
                      children: <Widget>[
                        const Expanded(
                          child: Center(
                            child: Text(
                              'Special Days',
                              style: TextStyle(fontSize: 18.0),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              '${journalInfo.totalSpecialDays}',
                              style: const TextStyle(fontSize: 18.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 30.0),
                    child: Row(
                      children: <Widget>[
                        const Expanded(
                          child: Center(
                            child: Text(
                              'Average Feeling',
                              style: TextStyle(fontSize: 18.0),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: journalInfo.totalEntries > 0
                                ? Icon(
                                    kFeelingIcons[(journalInfo.accFeeling /
                                            journalInfo.totalEntries)
                                        .round()],
                                    size: 32.0,
                                  )
                                : Icon(kFeelingIcons[2]),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 30.0),
                    child: Row(
                      children: <Widget>[
                        const Expanded(
                          child: Center(
                            child: Text(
                              'Recent Addition',
                              style: TextStyle(fontSize: 18.0),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: journalInfo.totalEntries > 0
                                ? Text(
                                    formatDate(journalInfo.mostRecentEntryDate),
                                    style: const TextStyle(fontSize: 18.0),
                                  )
                                : const Text(
                                    '-',
                                    style: TextStyle(fontSize: 18.0),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            } else {
              return const Center(
                child: Text('Something went wrong'),
              );
            }
          }),
    );
  }
}
