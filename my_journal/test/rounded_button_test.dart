import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_journal/widgets/rounded_button.dart';

void main() {
  testWidgets('RoundedButton is properly rendered',
      (WidgetTester tester) async {
    // Create RoundedButton
    final Widget roundedButton = RoundedButton(
      text: 'Test',
      color: Colors.lightBlueAccent,
      onPressed: () {},
    );

    // Build testable RoundedButton using WidgetTester
    await tester.pumpWidget(
      MaterialApp(
        home: roundedButton,
      ),
    );

    // Create Finders
    final widgetFinder = find.byWidget(roundedButton);
    final buttonTextFinder = find.text('Test');

    // Verify that RoundedButton exists and is properly rendered
    expect(widgetFinder, findsOneWidget);
    expect(buttonTextFinder, findsOneWidget);
  });

  //TODO: Test onPress functionality of RoundedButton
}
