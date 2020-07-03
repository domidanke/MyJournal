import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_journal/screens/select_entry.dart';

void main() {
  testWidgets('View Entry Screen is loaded and rendered properly',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: SelectEntry()));
    expect(find.byType(SelectEntry), findsOneWidget);
  });
}
