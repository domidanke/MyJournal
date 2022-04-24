import 'package:flutter/cupertino.dart';

class Journal {
  Journal(
      {this.journalID,
      this.title,
      this.category,
      this.image,
      this.icon,
      this.sortOrder,
      this.created,
      this.accFeeling,
      this.totalEntries,
      this.totalSpecialDays,
      this.mostRecentEntryDate,
      this.entriesColor,
      this.comingFromHome = false});

  final String journalID;
  String title;
  String category;
  dynamic image;
  Icon icon;
  final int sortOrder;
  DateTime created;
  final int accFeeling;
  final int totalEntries;
  final int totalSpecialDays;
  final DateTime mostRecentEntryDate;
  bool comingFromHome;
  Color entriesColor;
}
