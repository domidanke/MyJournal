import 'journal.dart';

class Entry {
  Entry(
      {this.entryID,
      this.journal,
      this.header,
      this.content,
      this.feeling,
      this.specialDay,
      this.eventDate,
      this.created,
      this.isMockEntry = false});
  String entryID;
  Journal journal;
  String header;
  DateTime eventDate;
  String content;
  bool specialDay;
  int feeling;
  DateTime created;
  DateTime modified;
  bool isMockEntry;
}
