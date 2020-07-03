import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_journal/screens/journal_entry_overview_screen.dart';

void main() {
  testWidgets('JournalEntryOverviewScreen is loaded and rendered properly',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: JournalEntryOverviewScreen()));
    expect(find.byType(JournalEntryOverviewScreen), findsOneWidget);
  });
}
