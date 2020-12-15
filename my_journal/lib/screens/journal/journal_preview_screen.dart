import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_journal/models/journal.dart';
import 'package:my_journal/services/data-access_service.dart';
import 'package:my_journal/services/navigation_service.dart';
import 'package:my_journal/widgets/buttons/rounded_button.dart';
import 'package:my_journal/widgets/journal/journal_card.dart';

import '../../services/locator.dart';

final DataAccessService _dataAccessService = locator<DataAccessService>();
final NavigationService _navigationService = locator<NavigationService>();

class JournalPreviewScreen extends StatefulWidget {
  const JournalPreviewScreen(this.journal);
  final Journal journal;
  static String id = 'journal_preview_screen';

  @override
  _JournalPreviewScreenState createState() => _JournalPreviewScreenState();
}

class _JournalPreviewScreenState extends State<JournalPreviewScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            JournalCard(
              journal: widget.journal,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RoundedButton(
                  width: 120,
                  text: 'Back',
                  onPressed: () {
                    _navigationService.goBack();
                  },
                ),
                RoundedButton(
                  color: Colors.teal[700],
                  width: 120,
                  text: widget.journal.comingFromHome ? 'Create' : 'Save',
                  onPressed: () async {
                    if (widget.journal.comingFromHome) {
                      await _dataAccessService.createJournal(widget.journal);
                    } else {
                      await _dataAccessService.updateJournal(widget.journal);
                    }
                    _navigationService.navigateHome();
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}