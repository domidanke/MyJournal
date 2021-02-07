import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_journal/models/entry.dart';
import 'package:my_journal/models/journal.dart';

import 'data-access_service.dart';
import 'locator.dart';
import 'navigation_service.dart';

final NavigationService _navigationService = locator<NavigationService>();
final DataAccessService _dataAccessService = locator<DataAccessService>();

Map<String, String> kAlertMap = const {
  'invalid-email': 'Please enter a valid email address.',
  'user-not-found': 'Sorry, we can\'t find an account with this email address.',
  'wrong-password': 'Username or password is invalid. Please try again.',
  'weak-password': 'The password must be at least 6 characters long.',
  'email-already-in-use':
      'The email address is already in use by another account.',
  'operation-not-allowed': 'Something went wrong on the Server'
};

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
            await _dataAccessService.deleteEntry(entry).then((value) async {
              _navigationService.goBack();
              if (value) {
                await popUpSuccess(context, 'Entry Deleted!');
                _navigationService.goBack();
              } else {
                await popUpError(context);
              }
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
            await _dataAccessService.deleteJournal(journal).then((value) async {
              _navigationService.goBack();
              if (value) {
                await popUpSuccess(context, 'Journal Deleted!');
                _navigationService.navigateHome();
              } else {
                await popUpError(context);
              }
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
                .then((value) async {
              _navigationService.goBack();
              if (value) {
                await popUpSuccess(context, 'Colors changed!');
                _navigationService.navigateHome();
              } else {
                await popUpError(context);
              }
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
