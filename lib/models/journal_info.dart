import 'dart:ui';

class JournalInfo {
  JournalInfo(
      {this.accFeeling,
      this.totalEntries,
      this.totalSpecialDays,
      this.mostRecentEntryDate,
      this.created,
      this.entriesColor});
  int accFeeling;
  int totalEntries;
  int totalSpecialDays;
  DateTime mostRecentEntryDate;
  final DateTime created;
  Color entriesColor;
}
