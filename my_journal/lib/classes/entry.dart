import 'package:flutter/material.dart';

final List<IconData> feelingIcons = [
  Icons.clear,
  Icons.cloud,
  Icons.compare_arrows,
  Icons.child_friendly,
  Icons.accessibility_new,
];

class Entry {
  Entry(
      {String headerText,
      String date,
      bool isFavorite,
      int feeling,
      String content}) {
    _headerText = headerText;
    _date = date;
    _isFavorite = isFavorite;
    _feeling = feeling;
    _content = content;
  }

  String _headerText;

  String get headerText => _headerText;
  String _date;
  String _content;
  bool _isFavorite;
  int _feeling;

  Icon getFeelingIcon() {
    return Icon(feelingIcons[_feeling]);
  }

  String get date => _date;

  String get content => _content;

  bool get isFavorite => _isFavorite;

  int get feeling => _feeling;
}
