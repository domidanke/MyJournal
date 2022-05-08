import 'package:flutter/material.dart';
import 'package:my_journal/screens/entry/entry_detail_screen.dart';
import 'package:my_journal/services/navigation_service.dart';

import '../../models/entry.dart';
import '../../services/locator.dart';
import '../../utils/constants.dart';

final NavigationService _navigationService = locator<NavigationService>();

class EntryCard extends StatefulWidget {
  const EntryCard({@required this.entry});
  final Entry entry;

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
          _navigationService.navigateTo(EntryDetailScreen.id,
              args: widget.entry);
        },
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
          child: ListTile(
            tileColor: widget.entry.journal.entriesColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0)),
            leading: Icon(
              kFeelingIcons[widget.entry.feeling],
              size: 22.0,
            ),
            title: Text(
              widget.entry.header,
            ),
            subtitle: Text(
              formatDate(widget.entry.eventDate),
            ),
            trailing: Icon(
              widget.entry.specialDay ? Icons.star : null,
              color: Colors.orangeAccent,
              size: 24.0,
            ),
          ),
        ));
  }
}
