import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_journal/constants.dart';
import 'package:my_journal/widgets/rounded_button.dart';

class CreateEntry extends StatefulWidget {
  static String id = 'create_entry_screen';
  @override
  _CreateEntryState createState() => _CreateEntryState();
}

class _CreateEntryState extends State<CreateEntry>
    with SingleTickerProviderStateMixin {
  String dateText = DateFormat.yMMMd().format(DateTime.now());
  int selectedIcon = 0;
  bool toggledFavoriteIcon = false;
  final _headerTextFieldController = TextEditingController();
  final _contentTextFieldController = TextEditingController();

  void updateSelectedIcon(int selected) {
    setState(() {
      selectedIcon = selected;
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
                        dateText = DateFormat.yMMMd().format(selectedDate);
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
          dateText = DateFormat.yMMMd().format(selectedDate);
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
                                      showCustomDatePicker(context);
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
                                color: selectedIcon == 1 ? kPink : Colors.white,
                                size: selectedIcon == 1 ? 42.0 : 40.0,
                              ),
                              onPressed: () {
                                updateSelectedIcon(1);
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.cloud,
                                color: selectedIcon == 2 ? kPink : Colors.white,
                                size: selectedIcon == 2 ? 42.0 : 40.0,
                              ),
                              onPressed: () {
                                updateSelectedIcon(2);
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.compare_arrows,
                                color: selectedIcon == 3 ? kPink : Colors.white,
                                size: selectedIcon == 3 ? 42.0 : 40.0,
                              ),
                              onPressed: () {
                                updateSelectedIcon(3);
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.child_friendly,
                                color: selectedIcon == 4 ? kPink : Colors.white,
                                size: selectedIcon == 4 ? 42.0 : 40.0,
                              ),
                              onPressed: () {
                                updateSelectedIcon(4);
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.accessibility_new,
                                color: selectedIcon == 5 ? kPink : Colors.white,
                                size: selectedIcon == 5 ? 42.0 : 40.0,
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
                                        print(MediaQuery.of(context)
                                            .viewInsets
                                            .bottom);
                                        print(
                                            MediaQuery.of(context).size.height);
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
                  print('Saved: ' +
                      _headerTextFieldController.text +
                      '\n' +
                      _contentTextFieldController.text);
                },
              ),
            ),
          ]),
        ));
  }
}
