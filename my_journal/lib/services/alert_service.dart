import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_journal/models/entry.dart';
import 'package:my_journal/models/journal.dart';

import '../utils/constants.dart';
import 'data-access_service.dart';
import 'locator.dart';
import 'navigation_service.dart';

final NavigationService _navigationService = locator<NavigationService>();
final DataAccessService _dataAccessService = locator<DataAccessService>();

class AlertService {
  //region General Alert
  void generalAlert(String title, String message, BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CustomAlert(
          alertTitle: title,
          alertMessage: message,
          onPressed1: () => _navigationService.goBack(),
        );
      },
    );
  }
  //endregion

  //region Login failed
  void loginFailed(String alertCode, BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CustomAlert(
          alertTitle: 'Login failed',
          alertMessage: kAlertMap[alertCode],
          onPressed1: () => _navigationService.goBack(),
        );
      },
    );
  }
  //endregion

  //region Registration failed
  void registrationFailed(String alertCode, BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CustomAlert(
          alertTitle: 'Registration failed',
          alertMessage: kAlertMap[alertCode],
          onPressed1: () => _navigationService.goBack(),
        );
      },
    );
  }
  //endregion

  //region Max Journals Reached
  void maxJournals(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CustomAlert(
          alertTitle: 'Adding Journal Failed',
          alertMessage: 'You have reached the maximum number of journals.',
          onPressed1: () => _navigationService.goBack(),
        );
      },
    );
  }
  //endregion

  //region Delete Entry
  void deleteEntry(BuildContext context, Entry entry) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CustomAlert(
          alertTitle: 'Are you sure?',
          alertMessage:
              "Clicking OK will delete Entry '${entry.header}' permanently.",
          onPressed1: () async {
            await _dataAccessService.deleteEntry(entry);
            _navigationService.goBack(n: 2);
          },
          secondOption: 'Cancel',
          onPressed2: () {
            _navigationService.goBack();
          },
        );
      },
    );
  }
  //endregion

  //region Delete Entry
  void deleteJournal(BuildContext context, Journal journal) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CustomAlert(
          alertTitle: 'Are you sure?',
          alertMessage:
              "Clicking OK will delete Journal '${journal.title}' permanently.",
          onPressed1: () async {
            await _dataAccessService.deleteJournal(journal);
            _navigationService.navigateHome();
          },
          secondOption: 'Cancel',
          onPressed2: () {
            _navigationService.goBack();
          },
        );
      },
    );
  }
  //endregion

  //region Update Entries Color
  void updateEntriesColor(BuildContext context, Journal journal, Color color) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CustomAlert(
          alertTitle: 'Are you sure?',
          alertMessage: color != null
              ? 'Clicking OK will apply selected Color'
              : 'Clicking OK will set Entries Color to Default',
          onPressed1: () async {
            await _dataAccessService.updateEntriesColor(journal, color);
            _navigationService.navigateHome();
          },
          secondOption: 'Cancel',
          onPressed2: () {
            _navigationService.goBack();
          },
        );
      },
    );
  }
  //endregion

}

//region Custom Alert Widget
class CustomAlert extends StatelessWidget {
  const CustomAlert(
      {this.alertTitle,
      this.alertMessage,
      this.firstOption = 'OK',
      this.onPressed1,
      this.secondOption,
      this.onPressed2});
  final String alertTitle;
  final String alertMessage;
  final String firstOption;
  final Function onPressed1;
  final String secondOption;
  final Function onPressed2;

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoAlertDialog(
        title: Text(alertTitle),
        content: Text(alertMessage),
        actions: secondOption != null
            ? <Widget>[
                CupertinoDialogAction(
                  child: Text(firstOption),
                  onPressed: onPressed1,
                ),
                CupertinoDialogAction(
                  child: Text(secondOption),
                  onPressed: onPressed2,
                )
              ]
            : <Widget>[
                CupertinoDialogAction(
                  child: Text(firstOption),
                  onPressed: onPressed1,
                ),
              ],
      );
    } else {
      return AlertDialog(
        title: Text(alertTitle),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(alertMessage),
            ],
          ),
        ),
        actions: secondOption != null
            ? <Widget>[
                FlatButton(
                  child: Text(firstOption),
                  onPressed: onPressed1,
                ),
                FlatButton(
                  child: Text(secondOption),
                  onPressed: onPressed2,
                ),
              ]
            : <Widget>[
                FlatButton(
                  child: Text(firstOption),
                  onPressed: onPressed1,
                ),
              ],
      );
    }
  }
}
//endregion