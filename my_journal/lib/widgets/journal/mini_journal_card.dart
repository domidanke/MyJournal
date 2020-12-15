import 'package:flutter/material.dart';
import 'package:my_journal/models/journal.dart';
import 'package:my_journal/screens/entry/create_entry_screen.dart';
import 'package:my_journal/screens/journal/edit_entries_color_screen.dart';
import 'package:my_journal/screens/journal/edit_journal_screen.dart';
import 'package:my_journal/services/locator.dart';
import 'package:my_journal/services/navigation_service.dart';

final NavigationService _navigationService = locator<NavigationService>();

class MiniJournalCard extends StatelessWidget {
  const MiniJournalCard({@required this.journal, @required this.origin});

  final Journal journal;
  final String origin;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        switch (origin) {
          case 'Home':
            {
              final Journal journalTransfer = Journal(
                  journalID: journal.journalID,
                  title: journal.title,
                  icon: journal.icon,
                  comingFromHome: true);
              _navigationService.navigateTo(CreateEntryScreen.id,
                  args: journalTransfer);
              break;
            }
          case 'Settings/Edit-Colors':
            {
              _navigationService.navigateTo(EditEntriesColorScreen.id,
                  args: journal);
              break;
            }
          case 'Settings/Edit-Journal':
            {
              _navigationService.navigateTo(EditJournalScreen.id,
                  args: journal);
              break;
            }
        }
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: ListTile(
          leading: journal.icon,
          title: Text(journal.title),
        ),
      ),
    );
  }
}
