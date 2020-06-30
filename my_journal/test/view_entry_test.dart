import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_journal/screens/view_entry.dart';

void main() {
  testWidgets('View Entry Screen is loaded and rendered properly',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: ViewEntry()));
    expect(find.byType(ViewEntry), findsOneWidget);
  });
}
