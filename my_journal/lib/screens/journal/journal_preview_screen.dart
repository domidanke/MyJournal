import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_journal/models/journal.dart';
import 'package:my_journal/services/alert_service.dart';
import 'package:my_journal/services/data-access_service.dart';
import 'package:my_journal/services/navigation_service.dart';
import 'package:my_journal/widgets/buttons/rounded_button.dart';
import 'package:my_journal/widgets/journal/journal_card.dart';

import '../../services/locator.dart';

final DataAccessService _dataAccessService = locator<DataAccessService>();
final NavigationService _navigationService = locator<NavigationService>();
final AlertService _alertService = locator<AlertService>();

class JournalPreviewScreen extends StatefulWidget {
  const JournalPreviewScreen(this.journal);
  final Journal journal;
  static String id = 'journal_preview_screen';

  @override
  _JournalPreviewScreenState createState() => _JournalPreviewScreenState();
}

class _JournalPreviewScreenState extends State<JournalPreviewScreen> {
  bool loading = false;

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
                  isAsync: loading,
                  onPressed: () async {
                    setState(() {
                      loading = true;
                    });
                    if (widget.journal.comingFromHome) {
                      await _dataAccessService
                          .createJournal(widget.journal)
                          .then((_) async {
                        setState(() {
                          loading = false;
                        });
                        await _alertService.popUpSuccess(
                            context, 'Journal Created');
                      }).catchError((Object error) async {
                        await _alertService.popUpError(context);
                      });
                    } else {
                      await _dataAccessService
                          .updateJournal(widget.journal)
                          .then((_) async {
                        setState(() {
                          loading = false;
                        });
                        await _alertService.popUpSuccess(
                            context, 'Journal Saved!');
                      }).catchError((Object error) async {
                        await _alertService.popUpError(context);
                      });
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
