import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final List<IconData> feelingIcons = [
  Icons.clear,
  Icons.cloud,
  Icons.compare_arrows,
  Icons.child_friendly,
  Icons.accessibility_new,
];

class JournalEntry {
  JournalEntry(
      {String headerText,
      DateTime eventDate,
      bool isFavorite,
      int feeling,
      String content,
      Timestamp createdOn}) {
    _headerText = headerText;
    _eventDate = eventDate;
    _isFavorite = isFavorite;
    _feeling = feeling;
    _content = content;
    _createdOn = createdOn;
  }

  String _headerText;

  String get headerText => _headerText;
  DateTime _eventDate;
  String _content;
  bool _isFavorite;
  int _feeling;
  Timestamp _createdOn;

  Icon getFeelingIcon({iconSize}) {
    return Icon(
      feelingIcons[_feeling],
      size: iconSize,
    );
  }

  Timestamp get createdOn => _createdOn;

  DateTime get eventDate => _eventDate;

  String get content => _content;

  bool get isFavorite => _isFavorite;

  int get feeling => _feeling;
}
