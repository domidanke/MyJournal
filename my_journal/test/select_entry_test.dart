import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_journal/screens/select_entry.dart';

void main() {
  final List journalEntryData = [
    {
      'content': 'testtesttest',
      'dateSelected': 'Apr 14, 2020',
      'header': 'Test Header',
      'feeling': 1,
      'isFavorite': true
    },
    {
      'content': 'More and more testing to see if scrollview works.',
      'dateSelected': 'Apr 16, 2020',
      'header': 'Scroll View Add',
      'feeling': 2,
      'isFavorite': false
    }
  ];

  testWidgets('View Entry Screen is loaded and rendered properly',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: SelectEntry(
      journalEntryData: journalEntryData,
    )));
    expect(find.byType(SelectEntry), findsOneWidget);
  });
}
