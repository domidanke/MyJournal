import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:my_journal/models/entry.dart';
import 'package:my_journal/models/journal.dart';
import 'package:my_journal/services/data-access_service.dart';
import 'package:my_journal/services/navigation_service.dart';
import 'package:my_journal/widgets/buttons/custom_fab.dart';
import 'package:my_journal/widgets/buttons/toggle_button.dart';
import 'package:my_journal/widgets/entry/entry_card.dart';
import 'package:my_journal/widgets/journal/journal_info_sheet.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../services/locator.dart';
import 'create_entry_screen.dart';

final NavigationService _navigationService = locator<NavigationService>();
final DataAccessService _dataAccessService = locator<DataAccessService>();

class EntryOverviewScreen extends StatefulWidget {
  const EntryOverviewScreen(this.journal);
  final Journal journal;
  static String id = 'entry_overview_screen';
  @override
  _EntryOverviewScreenState createState() => _EntryOverviewScreenState();
}

class _EntryOverviewScreenState extends State<EntryOverviewScreen> {
  Stream entryStream;
  bool sortByRecent = true;
  bool displayCalendarView = false;
  DateTime selectedDay;
  List<dynamic> selectedEvents;
  Map<DateTime, List<dynamic>> entryMap = {};

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    selectedDay = DateTime(now.year, now.month, now.day);
    selectedEvents = [];
    entryStream = getEntryStream();
  }

  Stream getEntryStream() =>
      _dataAccessService.getEntryStream(widget.journal, sortByRecent);

  //region On Date Selected
  void onDateSelected(DateTime day, List entries, List holidays) {
    setState(() {
      selectedDay = DateTime(day.year, day.month, day.day);
      selectedEvents = entries;
    });
  }
  //endregion

  //region Get Event List
  Widget getEventList() {
    final List<Widget> calendarViewEntryCards = [];
    for (final Entry entry in selectedEvents) {
      calendarViewEntryCards.add(EntryCard(
        entry: entry,
        isCalendarView: true,
      ));
    }

    if (calendarViewEntryCards.isNotEmpty) {
      return Expanded(
        child: GridView.count(
            primary: false,
            padding: const EdgeInsets.all(20),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            crossAxisCount: 1,
            children: calendarViewEntryCards),
      );
    }
    return const Padding(
      padding: EdgeInsets.only(top: 48.0),
      child: Center(
        child: Text('No Entries'),
      ),
    );
  }
  //endregion

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: CustomFab(
          childButtons: [
            SpeedDialChild(
                child: const Icon(Icons.info_outline),
                backgroundColor: Colors.teal[500],
                label: 'Info',
                labelStyle: const TextStyle(color: Colors.black),
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return JournalInfoSheet(
                          journal: widget.journal,
                        );
                      });
                }),
            SpeedDialChild(
                child: const Icon(Icons.date_range),
                backgroundColor: Colors.teal[700],
                label: 'Change View',
                labelStyle: const TextStyle(color: Colors.black),
                onTap: () {
                  setState(() {
                    displayCalendarView = !displayCalendarView;
                  });
                }),
            SpeedDialChild(
              child: const Icon(
                Icons.add,
              ),
              backgroundColor: Colors.teal[900],
              label: 'Add Entry',
              labelStyle: const TextStyle(color: Colors.black),
              onTap: () {
                _navigationService.navigateTo(CreateEntryScreen.id,
                    args: widget.journal);
              },
            ),
          ],
        ),
        body: SafeArea(
            child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    icon: const Icon(
                      Icons.chevron_left,
                      size: 32.0,
                    ),
                    onPressed: () {
                      _navigationService.goBack();
                    },
                  ),
                  Text(
                    '${widget.journal.title}',
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 32.0),
                    child: widget.journal.icon,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 8.0,
            ),
            StreamBuilder<QuerySnapshot>(
              stream: entryStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 50.0),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else if (snapshot.connectionState == ConnectionState.active) {
                  entryMap = {};
                  final List<EntryCard> entryCards = [];
                  final entryDocs = snapshot.data.docs;
                  for (final QueryDocumentSnapshot entryData in entryDocs) {
                    final entry = Entry(
                      entryID: entryData.id,
                      eventDate: DateTime.parse(
                          entryData['eventDate'].toDate().toString()),
                      feeling: entryData['feeling'],
                      specialDay: entryData['specialDay'],
                      header: entryData['header'],
                      content: entryData['content'],
                      journal: widget.journal,
                    );
                    final DateTime eventDate = DateTime(entry.eventDate.year,
                        entry.eventDate.month, entry.eventDate.day);
                    if (entryMap.containsKey(eventDate)) {
                      final List<dynamic> tmp = entryMap[eventDate];
                      tmp.add(entry);
                      entryMap[eventDate] = tmp;
                    } else {
                      entryMap[eventDate] = [entry];
                    }
                    entryCards.add(EntryCard(entry: entry));
                  }

                  /// On Change
                  if (entryMap.containsKey(selectedDay)) {
                    selectedEvents = entryMap[selectedDay];
                  } else {
                    selectedEvents = [];
                  }

                  return !displayCalendarView
                      ? Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      const Padding(
                                        padding: EdgeInsets.all(4.0),
                                        child: Icon(Icons.arrow_downward),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 24.0),
                                        child: ToggleButton(
                                          firstText: 'Recent',
                                          secondText: 'Oldest',
                                          toggle: sortByRecent,
                                          color: Colors.teal[500],
                                          onPressed: () {
                                            setState(() {
                                              sortByRecent = !sortByRecent;
                                            });
                                            entryStream = getEntryStream();
                                          },
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 8.0,
                              ),
                              Expanded(
                                child: GridView.count(
                                    primary: false,
                                    padding: const EdgeInsets.all(20),
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                    crossAxisCount: 2,
                                    children: entryCards),
                              )
                            ],
                          ),
                        )
                      : Expanded(
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(6.0),
                                    gradient: LinearGradient(colors: [
                                      Colors.teal[400],
                                      Colors.teal[700]
                                    ]),
                                  ),
                                  child: TableCalendar(
                                    headerStyle: const HeaderStyle(
                                        formatButtonVisible: false,
                                        leftChevronIcon: Icon(
                                          Icons.chevron_left,
                                          color: Colors.white,
                                          size: 18.0,
                                        ),
                                        rightChevronIcon: Icon(
                                          Icons.chevron_right,
                                          color: Colors.white,
                                          size: 18.0,
                                        ),
                                        titleTextStyle: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18.0)),
                                    focusedDay: null,
                                    lastDay: null,
                                    firstDay: null,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 8.0,
                              ),
                              getEventList(),
                            ],
                          ),
                        );
                } else {
                  return const Center(
                    child: Text('Something went wrong'),
                  );
                }
              },
            ),
          ],
        )));
  }

  @override
  void dispose() {
    super.dispose();
  }
}
