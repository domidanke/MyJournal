import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_journal/constants.dart';

class CreateEntry extends StatefulWidget {
  static String id = 'create_entry_screen';
  @override
  _CreateEntryState createState() => _CreateEntryState();
}

class _CreateEntryState extends State<CreateEntry> {
  int selectedIcon = 0;
  String dateText = DateFormat.yMMMd().format(DateTime.now());

  void updateSelectedIcon(int selected) {
    setState(() {
      selectedIcon = selected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
          child: Center(
              child: Container(
            height: 210.0,
            decoration: kCardDecoration,
            child: Column(
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
                                                MainAxisAlignment.spaceAround,
                                            children: <Widget>[
                                              SizedBox(
                                                height: 250.0,
                                                child: CupertinoDatePicker(
                                                  mode: CupertinoDatePickerMode
                                                      .date,
                                                  initialDateTime:
                                                      DateTime.now(),
                                                  onDateTimeChanged:
                                                      (selectedDate) {
                                                    dateText =
                                                        DateFormat.yMMMd()
                                                            .format(
                                                                selectedDate);
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
                  'How Did you feel?',
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
                          color: selectedIcon == 1 ? pink : Colors.white,
                          size: selectedIcon == 1 ? 50.0 : 40.0,
                        ),
                        onPressed: () {
                          updateSelectedIcon(1);
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.cloud,
                          color: selectedIcon == 2 ? pink : Colors.white,
                          size: selectedIcon == 2 ? 50.0 : 40.0,
                        ),
                        onPressed: () {
                          updateSelectedIcon(2);
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.compare_arrows,
                          color: selectedIcon == 3 ? pink : Colors.white,
                          size: selectedIcon == 3 ? 50.0 : 40.0,
                        ),
                        onPressed: () {
                          updateSelectedIcon(3);
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.child_friendly,
                          color: selectedIcon == 4 ? pink : Colors.white,
                          size: selectedIcon == 4 ? 50.0 : 40.0,
                        ),
                        onPressed: () {
                          updateSelectedIcon(4);
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.accessibility_new,
                          color: selectedIcon == 5 ? pink : Colors.white,
                          size: selectedIcon == 5 ? 50.0 : 40.0,
                        ),
                        onPressed: () {
                          updateSelectedIcon(5);
                        },
                      )
                    ],
                  ),
                )
              ],
            ),
          )),
        ),
      ]),
    ));
  }
}
