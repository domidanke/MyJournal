import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:mockito/mockito.dart';
import 'package:my_journal/screens/create_entry.dart';
import 'package:my_journal/widgets/rounded_button.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  testWidgets('Create Entry Screen is loaded and rendered properly',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: CreateEntry()));

    expect(find.byType(CreateEntry), findsOneWidget);
    expect(
        find.text(DateFormat.yMMMd().format(DateTime.now())), findsOneWidget);
    expect(find.byIcon(Icons.date_range), findsOneWidget);
    expect(find.text('Change Date'), findsOneWidget);
    expect(find.text('How Did You feel?'), findsOneWidget);
    expect(find.byType(IconButton), findsNWidgets(7));
    expect(find.byType(TextField), findsNWidgets(2));
    expect(find.text('Special Day'), findsOneWidget);
    expect(find.byType(RoundedButton), findsOneWidget);
    expect(find.text('Save Journal Entry'), findsOneWidget);
  });

  testWidgets('TextFields receive and render user input correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: CreateEntry()));
    final headerTextField = find.byKey(const Key('headerTextFieldKey'));
    final contentTextField = find.byKey(const Key('contentTextFieldKey'));
    await tester.enterText(headerTextField, 'This is a Test Header');
    expect(find.text('This is a Test Header'), findsOneWidget);
    await tester.enterText(contentTextField,
        'This is a Test for the content a user ought to create');
    expect(find.text('This is a Test for the content a user ought to create'),
        findsOneWidget);
  });

  testWidgets('FaveIconButton changes correctly on tap',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: CreateEntry()));

    final faveIcon = find.byIcon(Icons.favorite_border);
    await tester.tap(faveIcon);
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.favorite), findsOneWidget);
    final faveIconTapped = find.byIcon(Icons.favorite);
    await tester.tap(faveIconTapped);
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.favorite_border), findsOneWidget);
  });
}