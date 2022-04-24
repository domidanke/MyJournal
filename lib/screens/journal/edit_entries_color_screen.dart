import 'package:flutter/material.dart';
import 'package:flutter_circle_color_picker/flutter_circle_color_picker.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:my_journal/models/entry.dart';
import 'package:my_journal/models/journal.dart';
import 'package:my_journal/services/alert_service.dart';
import 'package:my_journal/services/locator.dart';
import 'package:my_journal/services/navigation_service.dart';
import 'package:my_journal/widgets/buttons/custom_fab.dart';
import 'package:my_journal/widgets/entry/entry_card.dart';

final NavigationService _navigationService = locator<NavigationService>();
final AlertService _alertService = locator<AlertService>();

class EditEntriesColorScreen extends StatefulWidget {
  const EditEntriesColorScreen(this.journal);
  final Journal journal;
  static String id = 'edit-entries-color-screen';

  @override
  _EditEntriesColorScreenState createState() => _EditEntriesColorScreenState();
}

class _EditEntriesColorScreenState extends State<EditEntriesColorScreen> {
  Color selectedColor;
  bool calendarView = false;
  DateTime now = DateTime.now();

  @override
  void initState() {
    super.initState();
    selectedColor = widget.journal.entriesColor;
  }

  List<Widget> getEntryCards() {
    final List<Widget> mockEntryCards = [];
    for (int i = 0; i < 6; i++) {
      mockEntryCards.add(EntryCard(
          isCalendarView: calendarView,
          entry: Entry(
              journal: Journal(entriesColor: selectedColor),
              header: 'Your Title ${i + 1}',
              content: 'Your Content',
              eventDate: DateTime(now.year, now.month, now.day - i),
              isMockEntry: true,
              specialDay: i % 3 == 0,
              feeling: 4 - i % 4)));
    }
    return mockEntryCards;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: CustomFab(
        childButtons: [
          SpeedDialChild(
              child: const Icon(Icons.done),
              backgroundColor: Colors.teal[700],
              label: 'Confirm Change',
              labelStyle: const TextStyle(color: Colors.black),
              onTap: () {
                if (widget.journal.entriesColor == selectedColor) {
                  _alertService.generalAlert(
                      'Color did not change', '', context);
                } else {
                  _alertService.updateEntriesColor(
                      context, widget.journal, selectedColor);
                }
              }),
          SpeedDialChild(
              child: const Icon(Icons.refresh),
              backgroundColor: Colors.teal[800],
              label: 'Set Default',
              labelStyle: const TextStyle(color: Colors.black),
              onTap: () {
                setState(() {
                  selectedColor = null;
                });
              }),
          SpeedDialChild(
              child: const Icon(Icons.date_range),
              backgroundColor: Colors.teal[900],
              label: 'Change View',
              labelStyle: const TextStyle(color: Colors.black),
              onTap: () {
                setState(() {
                  calendarView = !calendarView;
                });
              }),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
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
                      _navigationService.goBack(n: 2);
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
            Expanded(
              child: GridView.count(
                  primary: false,
                  padding: const EdgeInsets.all(20),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  crossAxisCount: calendarView ? 1 : 2,
                  children: getEntryCards()),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Divider(
                thickness: 4.0,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 12.0, bottom: 24.0),
              child: CircleColorPicker(
                thumbSize: 18.0,
                textStyle: const TextStyle(color: Colors.white, fontSize: 20.0),
                onChanged: (color) {
                  setState(() {
                    selectedColor = color;
                  });
                },
                size: Size(MediaQuery.of(context).size.width * 0.75,
                    MediaQuery.of(context).size.width * 0.75),
                colorCodeBuilder: (context, color) {
                  return const Center();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
