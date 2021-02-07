import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_journal/generated/l10n.dart';
import 'package:my_journal/models/entry.dart';
import 'package:my_journal/models/journal.dart';

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
  void loginFailed(FirebaseAuthException error, BuildContext context) {
    Map<String, String> loginAlertMap = {
      'invalid-email': S.of(context).loginScreenErrorInvalidEmail,
      'user-not-found': S.of(context).loginScreenErrorUserNotFound,
      'wrong-password': S.of(context).loginScreenErrorWrongPassword,
      'operation-not-allowed': S.of(context).loginScreenErrorDefault
    };

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CustomAlert(
          alertTitle: S.of(context).loginScreenErrorTitle,
          alertMessage: loginAlertMap[error.code],
          onPressed1: () => _navigationService.goBack(),
        );
      },
    );
  }
  //endregion

  //region Registration failed
  void registrationFailed(FirebaseAuthException error, BuildContext context) {
    Map<String, String> registrationAlertMap = {
      'invalid-email': S.of(context).registrationScreenErrorInvalidEmail,
      'weak-password': S.of(context).registrationScreenErrorWeakPassword,
      'email-already-in-use':
          S.of(context).registrationScreenErrorEmailAlreadyInUse,
      'operation-not-allowed': S.of(context).registrationScreenErrorDefault
    };

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CustomAlert(
          alertTitle: S.of(context).registrationScreenErrorTitle,
          alertMessage: registrationAlertMap[error.code],
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
            await _dataAccessService.deleteEntry(entry).then((_) async {
              _navigationService.goBack();
              await popUpSuccess(context, 'Entry Deleted!');
              _navigationService.goBack();
            }).catchError((Object error) async {
              await popUpError(context);
            });
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

  //region Delete Journal
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
            await _dataAccessService.deleteJournal(journal).then((_) async {
              _navigationService.goBack();

              await popUpSuccess(context, 'Journal Deleted!');
              _navigationService.navigateHome();
            }).catchError((Object error) async {
              await popUpError(context);
            });
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
  Future<void> updateEntriesColor(
      BuildContext context, Journal journal, Color color) async {
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
            await _dataAccessService
                .updateEntriesColor(journal, color)
                .then((_) async {
              _navigationService.goBack();

              await popUpSuccess(context, 'Colors changed!');
              _navigationService.navigateHome();
            }).catchError((Object error) async {
              await popUpError(context);
            });
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

  //region Pop Up Success
  Future<void> popUpSuccess(BuildContext context, String title) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CustomPopUp(
          popUpTitle: title,
          popUpContent: Center(
            child: Icon(
              Icons.check,
              color: Colors.teal[500],
            ),
          ),
        );
      },
    );
    await Future.delayed(const Duration(seconds: 2), () {});
    _navigationService.goBack();
  }
  //endregion

  //region Pop Up Error
  Future<void> popUpError(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CustomPopUp(
          popUpTitle: 'Something Went Wrong!',
          popUpContent: Center(
            child: Icon(
              Icons.clear,
              color: Colors.red[500],
            ),
          ),
        );
      },
    );
    await Future.delayed(const Duration(seconds: 2), () {});
    _navigationService.goBack();
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

//region Custom Pop Up Widget
class CustomPopUp extends StatelessWidget {
  const CustomPopUp({this.popUpTitle, this.popUpContent});
  final String popUpTitle;
  final Widget popUpContent;

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoAlertDialog(
        title: Text(popUpTitle),
        content: popUpContent,
      );
    } else {
      return AlertDialog(
        title: Text(popUpTitle),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              popUpContent,
            ],
          ),
        ),
      );
    }
  }
}
//endregion
