import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_journal/constants.dart';
import 'package:my_journal/screens/journal_entry_overview_screen.dart';
import 'package:my_journal/widgets/custom_alert.dart';
import 'package:my_journal/widgets/rounded_button.dart';

import '../classes/custom_icons_icons.dart';

final _fireStore = Firestore.instance;
FirebaseUser loggedInUser;

class CreateJournalEntryScreen extends StatefulWidget {
  static String id = 'create_entry_screen';
  @override
  _CreateJournalEntryScreenState createState() =>
      _CreateJournalEntryScreenState();
}

class _CreateJournalEntryScreenState extends State<CreateJournalEntryScreen> {
  final _auth = FirebaseAuth.instance;
  DateTime eventDate;
  int selectedIconIndex;
  bool toggledFavoriteIcon;
  TextEditingController headerTextFieldController;
  TextEditingController contentTextFieldController;
  final _createEntryFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    eventDate = DateTime.now();
    selectedIconIndex = 2;
    toggledFavoriteIcon = false;
    headerTextFieldController = TextEditingController();
    contentTextFieldController = TextEditingController();
  }

  String formatDate(date) {
    return date.month.toString() +
        '-' +
        date.day.toString() +
        '-' +
        date.year.toString();
  }

  Future<FirebaseUser> getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        return user;
      }
    } catch (e) {
      print(e);
      return null;
    }
    return null;
  }

  void updateSelectedIcon(int selected) {
    setState(() {
      selectedIconIndex = selected;
    });
  }

  void showCustomDatePicker(BuildContext context) {
    if (Platform.isIOS) {
      showModalBottomSheet(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          isDismissible: false,
          context: context,
          builder: (BuildContext bc) {
            return Container(
              height: 350.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  SizedBox(
                    height: 250.0,
                    child: CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.date,
                      initialDateTime: DateTime.now(),
                      onDateTimeChanged: (selectedDate) {
                        eventDate = selectedDate;
                      },
                    ),
                  ),
                  RaisedButton(
                    child: const Text('Confirm'),
                    onPressed: () {
                      setState(() {});
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            );
          });
    } else {
      showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime.now())
          .then((selectedDate) {
        setState(() {
          eventDate = selectedDate;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        key: const Key('CreateEntryKey'),
        body: SafeArea(
          child: Form(
            key: _createEntryFormKey,
            child: Column(children: <Widget>[
              Visibility(
                // ignore: avoid_bool_literals_in_conditional_expressions
                visible: MediaQuery.of(context).viewInsets.bottom == 0.0
                    ? true
                    : false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 20.0),
                  child: Center(
                      child: Container(
                    height: 210.0,
                    decoration: kCardDecoration,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 20.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  formatDate(eventDate),
                                  style: TextStyle(
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                Column(
                                  children: <Widget>[
                                    IconButton(
                                      icon: Icon(
                                        Icons.date_range,
                                        color: Colors.white,
                                        size: 30.0,
                                      ),
                                      onPressed: () {
                                        showCustomDatePicker(context);
                                      },
                                    ),
                                    const Text(
                                      'Change Date',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 10.0),
                                    )
                                  ],
                                )
                              ]),
                        ),
                        Text(
                          'How Did You feel?',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              IconButton(
                                icon: Icon(
                                  CustomIcons.angry,
                                  color: selectedIconIndex == 0
                                      ? kPink
                                      : Colors.white,
                                  size: selectedIconIndex == 0 ? 42.0 : 40.0,
                                ),
                                onPressed: () {
                                  updateSelectedIcon(0);
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  CustomIcons.sad,
                                  color: selectedIconIndex == 1
                                      ? kPink
                                      : Colors.white,
                                  size: selectedIconIndex == 1 ? 42.0 : 40.0,
                                ),
                                onPressed: () {
                                  updateSelectedIcon(1);
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  CustomIcons.meh,
                                  color: selectedIconIndex == 2
                                      ? kPink
                                      : Colors.white,
                                  size: selectedIconIndex == 2 ? 42.0 : 40.0,
                                ),
                                onPressed: () {
                                  updateSelectedIcon(2);
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  CustomIcons.smile_2,
                                  color: selectedIconIndex == 3
                                      ? kPink
                                      : Colors.white,
                                  size: selectedIconIndex == 3 ? 42.0 : 40.0,
                                ),
                                onPressed: () {
                                  updateSelectedIcon(3);
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  CustomIcons.happy,
                                  color: selectedIconIndex == 4
                                      ? kPink
                                      : Colors.white,
                                  size: selectedIconIndex == 4 ? 42.0 : 40.0,
                                ),
                                onPressed: () {
                                  updateSelectedIcon(4);
                                },
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  )),
                ),
              ),
              Expanded(
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 10.0),
                    child: Container(
                        decoration: kCardDecoration,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: Container(
                                      child: TextFormField(
                                        key: const Key('headerTextFieldKey'),
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'Please enter a Header';
                                          }
                                          return null;
                                        },
                                        controller: headerTextFieldController,
                                        maxLength: 15,
                                        decoration: const InputDecoration(
                                          hintText: 'Header',
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 10.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5.0),
                                  child: Column(
                                    children: <Widget>[
                                      IconButton(
                                        iconSize: 30.0,
                                        icon: toggledFavoriteIcon
                                            ? Icon(Icons.favorite)
                                            : Icon(Icons.favorite_border),
                                        onPressed: () {
                                          setState(() {
                                            toggledFavoriteIcon
                                                ? toggledFavoriteIcon = false
                                                : toggledFavoriteIcon = true;
                                          });
                                        },
                                      ),
                                      const Text(
                                        'Special Day',
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 10.0),
                                  child: Container(
                                    height: MediaQuery.of(context)
                                                .viewInsets
                                                .bottom ==
                                            0.0
                                        ? 250.0
                                        : MediaQuery.of(context).size.height -
                                            150.0 -
                                            MediaQuery.of(context)
                                                .viewInsets
                                                .bottom,
                                    child: TextFormField(
                                      key: const Key('contentTextFieldKey'),
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Please enter some Content';
                                        }
                                        return null;
                                      },
                                      controller: contentTextFieldController,
                                      style: const TextStyle(
                                        height: 1.5,
                                      ),
                                      decoration: const InputDecoration(
                                        hintText: 'Content',
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 10.0, vertical: 10.0),
                                      ),
                                      keyboardType: TextInputType.multiline,
                                      maxLines: null,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ))),
              ),
              Visibility(
                // ignore: avoid_bool_literals_in_conditional_expressions
                visible: MediaQuery.of(context).viewInsets.bottom == 0.0
                    ? true
                    : false,
                child: RoundedButton(
                  text: 'Save Journal Entry',
                  color: const Color(0xff49a09d),
                  onPressed: () async {
                    if (_createEntryFormKey.currentState.validate()) {
                      loggedInUser = await getCurrentUser();
                      try {
                        _fireStore
                            .collection('entries_' + loggedInUser.uid)
                            .add({
                          'eventDate': eventDate,
                          'header': headerTextFieldController.text,
                          'content': contentTextFieldController.text,
                          'feeling': selectedIconIndex,
                          'isFavorite': toggledFavoriteIcon,
                          'createdOn': DateTime.now()
                        });
                      } on Exception catch (e) {
                        print(e);
                        showDialog(
                          context: context,
                          barrierDismissible: false, // user must tap button!
                          builder: (BuildContext context) {
                            return CustomAlert(
                              alertTitle: 'Saving Entry failed',
                              alertMessage: e.toString(),
                            );
                          },
                        );
                      }
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  JournalEntryOverviewScreen()));
                    }
                  },
                ),
              ),
            ]),
          ),
        ));
  }
}
