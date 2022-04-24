import 'package:flutter/material.dart';
import 'package:my_journal/screens/entry/entry_detail_screen.dart';
import 'package:my_journal/services/navigation_service.dart';
import 'package:my_journal/utils/constants.dart';

import '../../models/entry.dart';
import '../../services/locator.dart';

final NavigationService _navigationService = locator<NavigationService>();

class EntryCard extends StatefulWidget {
  const EntryCard({@required this.entry, this.isCalendarView = false});
  final Entry entry;
  final bool isCalendarView;

  @override
  _EntryCardState createState() => _EntryCardState();
}

class _EntryCardState extends State<EntryCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _navigationService.navigateTo(EntryDetailScreen.id, args: widget.entry);
      },
      child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
        color: widget.entry.journal.entriesColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12.0, top: 12.0),
                    child: Icon(
                      kFeelingIcons[widget.entry.feeling],
                      size: widget.isCalendarView ? 56.0 : 36.0,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12.0, top: 12.0),
                    child: Text(
                      formatDate(widget.entry.eventDate),
                      style: widget.isCalendarView
                          ? Theme.of(context).textTheme.headline6
                          : Theme.of(context).textTheme.headline6,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: Align(
                alignment: Alignment.topCenter,
                child: Text(
                  widget.entry.header,
                  textAlign: TextAlign.center,
                  style: widget.isCalendarView
                      ? Theme.of(context).textTheme.headline3
                      : Theme.of(context).textTheme.headline5,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Icon(
                      widget.entry.specialDay ? Icons.star : null,
                      color: Colors.orangeAccent,
                      size: widget.isCalendarView ? 44.0 : 24.0,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
