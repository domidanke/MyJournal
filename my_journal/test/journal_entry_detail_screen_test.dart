import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_journal/classes/journal_entry.dart';
import 'package:my_journal/screens/journal_entry_detail_screen.dart';

void main() {
  final JournalEntry entry = JournalEntry(
      headerText: 'Header Text',
      content: 'Test Content blabla',
      eventDate: DateTime.now(),
      feeling: 3,
      isFavorite: true);

  testWidgets('JournalEntryDetailScreen is loaded and rendered properly',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: JournalEntryDetailScreen(
      journalEntry: entry,
    )));
    expect(find.byType(JournalEntryDetailScreen), findsOneWidget);
  });
}
