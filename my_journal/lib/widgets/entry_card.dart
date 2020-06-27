import 'package:flutter/material.dart';
import 'package:my_journal/constants.dart';

import '../classes/entry.dart';

class EntryCard extends StatelessWidget {
  const EntryCard({this.entry, this.onTap});
  final Entry entry;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: Container(
          decoration: kCardDecoration,
          height: 100,
          child: Column(
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: Text(
                        entry.date,
                        style: const TextStyle(fontSize: 25.0),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: entry.isFavorite
                          ? Icon(Icons.favorite)
                          : const Text(''),
                    )
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: Text(
                        entry.headerText,
                        style: const TextStyle(fontSize: 15.0),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: entry.getFeelingIcon(),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
