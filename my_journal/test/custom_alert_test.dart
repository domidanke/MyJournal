import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_journal/widgets/custom_alert.dart';

MaterialApp _buildAppWithDialog(Widget dialog) {
  return MaterialApp(
    home: Material(
      child: Builder(builder: (BuildContext context) {
        return Center(
          child: RaisedButton(
            child: const Text('X'),
            onPressed: () {
              showDialog<void>(
                context: context,
                builder: (BuildContext context) {
                  return dialog;
                },
              );
            },
          ),
        );
      }),
    ),
  );
}

void main() {
  testWidgets('CustomAlert is properly rendered', (WidgetTester tester) async {
    // Create CustomAlert
    final CustomAlert dialog = CustomAlert(
      alertTitle: 'Test Title',
      alertMessage: 'Test Message.',
    );
    // Build testable CustomAlert
    await tester.pumpWidget(_buildAppWithDialog(dialog));

    // Invoke CustomAlert
    await tester.tap(find.text('X'));
    await tester.pumpAndSettle();

    // Create Finders
    final customAlertFinder = find.byType(CustomAlert);
    final titleFinder = find.text('Test Title');
    final messageFinder = find.text('Test Message.');
    final actionFinder = find.text('OK');

    // Verify that CustomAlert exists and is properly rendered
    expect(customAlertFinder, findsOneWidget);
    expect(titleFinder, findsOneWidget);
    expect(messageFinder, findsOneWidget);
    expect(actionFinder, findsOneWidget);
  });

  testWidgets('CustomAlert is properly dismissed', (WidgetTester tester) async {
    // Create CustomAlert
    final CustomAlert dialog = CustomAlert(
      alertTitle: 'Test Title',
      alertMessage: 'Test Message.',
    );
    // Build testable CustomAlert
    await tester.pumpWidget(_buildAppWithDialog(dialog));

    // Invoke CustomAlert
    await tester.tap(find.text('X'));
    await tester.pumpAndSettle();

    // Create Finders
    final customAlertFinder = find.byType(CustomAlert);

    // Verify that CustomAlert exists
    expect(customAlertFinder, findsOneWidget);

    // Dismiss CustomAlert
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    // Verify that CustomAlert no longer exists
    expect(customAlertFinder, findsNothing);
  });
}
