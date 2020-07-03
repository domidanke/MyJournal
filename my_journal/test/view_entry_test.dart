import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_journal/classes/journal_entry.dart';
import 'package:my_journal/screens/view_entry.dart';

void main() {
  final JournalEntry entry = JournalEntry(
      headerText: 'Header Text',
      content: 'Test Content blabla',
      eventDate: DateTime.now(),
      feeling: 3,
      isFavorite: true);

  testWidgets('View Entry Screen is loaded and rendered properly',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: ViewEntry(
      journalEntry: entry,
    )));
    expect(find.byType(ViewEntry), findsOneWidget);
  });
}
