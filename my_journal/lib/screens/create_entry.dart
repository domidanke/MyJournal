import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_journal/constants.dart';
import 'package:my_journal/screens/my_journal_screen.dart';
import 'package:my_journal/widgets/custom_alert.dart';
import 'package:my_journal/widgets/rounded_button.dart';

//TODO: Add created on date and time to message document
//TODO: Maybe pass in the userManager at this point, still debatable

final _fireStore = Firestore.instance;
FirebaseUser loggedInUser;

class CreateEntry extends StatefulWidget {
  static String id = 'create_entry_screen';
  @override
  _CreateEntryState createState() => _CreateEntryState();
}

class _CreateEntryState extends State<CreateEntry> {
  final _auth = FirebaseAuth.instance;
  String dateText = DateFormat.yMMMd().format(DateTime.now());
  DateTime date;
  int selectedIcon = 2;
  bool toggledFavoriteIcon = false;
  final _headerTextFieldController = TextEditingController();
  final _contentTextFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  void updateSelectedIcon(int selected) {
    setState(() {
      selectedIcon = selected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        key: const Key('CreateEntryKey'),
        body: SafeArea(
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
                                dateText,
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
                                      if (Platform.isIOS) {
                                        showModalBottomSheet(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(25.0),
                                            ),
                                            isDismissible: false,
                                            context: context,
                                            builder: (BuildContext bc) {
                                              return Container(
                                                height: 350.0,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: <Widget>[
                                                    SizedBox(
                                                      height: 250.0,
                                                      child:
                                                          CupertinoDatePicker(
                                                        mode:
                                                            CupertinoDatePickerMode
                                                                .date,
                                                        initialDateTime:
                                                            DateTime.now(),
                                                        onDateTimeChanged:
                                                            (selectedDate) {
                                                          dateText = DateFormat
                                                                  .yMMMd()
                                                              .format(
                                                                  selectedDate);
                                                        },
                                                      ),
                                                    ),
                                                    RaisedButton(
                                                      child:
                                                          const Text('Confirm'),
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
                                            dateText = DateFormat.yMMMd()
                                                .format(selectedDate);
                                          });
                                        });
                                      }
                                    },
                                  ),
                                  Text(
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
                                Icons.clear,
                                color: selectedIcon == 0 ? kPink : Colors.white,
                                size: selectedIcon == 0 ? 42.0 : 40.0,
                              ),
                              onPressed: () {
                                updateSelectedIcon(0);
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.cloud,
                                color: selectedIcon == 1 ? kPink : Colors.white,
                                size: selectedIcon == 1 ? 42.0 : 40.0,
                              ),
                              onPressed: () {
                                updateSelectedIcon(1);
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.compare_arrows,
                                color: selectedIcon == 2 ? kPink : Colors.white,
                                size: selectedIcon == 2 ? 42.0 : 40.0,
                              ),
                              onPressed: () {
                                updateSelectedIcon(2);
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.child_friendly,
                                color: selectedIcon == 3 ? kPink : Colors.white,
                                size: selectedIcon == 3 ? 42.0 : 40.0,
                              ),
                              onPressed: () {
                                updateSelectedIcon(3);
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.accessibility_new,
                                color: selectedIcon == 4 ? kPink : Colors.white,
                                size: selectedIcon == 4 ? 42.0 : 40.0,
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
                                    child: TextField(
                                      key: const Key('headerTextFieldKey'),
                                      controller: _headerTextFieldController,
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
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
                                  child: TextField(
                                    key: const Key('contentTextFieldKey'),
                                    controller: _contentTextFieldController,
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
                onPressed: () {
                  try {
                    _fireStore.collection('entries_' + loggedInUser.email).add({
                      'dateSelected': dateText,
                      'feeling': selectedIcon,
                      'header': _headerTextFieldController.text,
                      'isFavorite': toggledFavoriteIcon,
                      'content': _contentTextFieldController.text,
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
                          builder: (context) => MyJournalScreen()));
                },
              ),
            ),
          ]),
        ));
  }
}
